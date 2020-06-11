/*
#input  table

shiyang.g5_user
shiyang.g5_net_user
shiyang.g5_plan_user
shiyang.g5_group_plan_user_detail
shiyang.user_5g_yy
shiyang.dm_imei_&pre_month
hdpyp02.tmp_days_local

# output table

shiyang.kb_sent
shiyang.kb_yy
shiyang.kb_plan_market
shiyang.kb_plan_up 

*/
/*    机网匹配    */

* location_stay;
data shiyang.days_local;
set hdpyp02.tmp_days_local;
run;

*gprs call roam ;
data shiyang.gprs;
set dw61.DWA_BEH_GPRS_DT_&end_dt;
keep user_id gprs_miss_flow local_flow inner_roam_flow inner_roam_onnet_days local_onnet_days lively_days;
run;

data shiyang.call;
set dw61.DWA_USR_BEH_CALL_DM_&end_dt;
keep user_id bill_dur local_bill_dur inner_roam_bill_dur lively_days;
run;

*登网短信;
proc sql;
create table shiyang.net_user_compare as
select distinct sub_id as user_id from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>='2020-04-01' and substr(stat_date,1,10)<="2020-04-31"; 
quit;

proc sql;
create table net_user_current as
select distinct sub_id as user_id from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>='2020-05-01' and substr(stat_date,1,10)<="&end_date"; 
quit;

proc sql;
create table sent as
select distinct phone_no from dw61.DWA_TI_O_SMS_ALL_DM_202005
where ct_ext_id='2080848';

insert into sent 
select distinct phone_no from dw61.DWA_TI_O_SMS_ALL_DM_&cur_month
where ct_ext_id='2080848';
quit;

proc sort data=sent nodupkey; by phone_no; run;

proc sql;
create table sent1 as
select a.phone_no, a.user_id from share_yy.kb_202005 a
inner join sent b on a.phone_no=b.phone_no;
run;

proc sql;
create table shiyang.kb_sent as
select a.user_id,
case when b.user_id is null then 0 else 1 end as net_flag,
case when c.user_id is null then 0 else 1 end as net_flag_compare
from sent1 a 
left  join net_user_current b on a.user_id=b.user_id
left join net_user_compare C on a.user_id=c.user_id;
quit;

/*proc freq data=kb_sent;*/
/*table net_flag;*/
/*run;*/

/* 预约客户跟踪 */

proc sql;
create table shiyang.kb_yy as
select a.* ,
	case when c.user_id is null then 0 else 1 end as plan_flag,
	case when d.user_id is null then 0 else 1 end as td_flag,
	case when e.user_id is null then 0 else 1 end as net_flag
from  shiyang.user_5g_yy A
left join shiyang.g5_plan_user C on a.user_id=c.user_id
left join shiyang.g5_user D on a.user_id=d.user_id
left join shiyang.g5_net_user E on a.user_id=e.user_id;
quit;

/*    机套匹配   */

*有机无套客群运营分析;
proc sql;
create table shiyang.kb_plan_market as
select a.phone_no,a.group_id ,
case when b.phone_no is null then 0 else 1 end as plan_flag
from share_yy.market_5g_group_20200531 a
left join shiyang.g5_plan_user B on a.phone_no=b.phone_no
where a.group_id>=2 and a.group_id<=7;
quit;

*外呼升档：5G升档推荐;
proc sql;
create table shiyang.waihu_update as 
select user_id from share_yy.waihu_update_20200407
union
select user_id from share_yy.waihu_update_20200503 
union
select user_id from share_yy.waihu_update_20200522 
union
select user_id from share_yy.waihu_update_20200529
union
select user_id from share_yy.waihu_update_20200602
union
select user_id from share_yy.waihu_update_20200605 ;
quit;

proc sql;
create table a as
select a.user_id 
from a inner join shiyang.g5_user b on a.user_id=b.user_id;
quit;

proc sort data=a nodupkey; by user_id; run;  /*32.5 w */

proc sql;
create table shiyang.kb_plan_up as 
select a.user_id,
case when b.user_id is not null then 1 else 0 end as sd_flag,
b.g5_plan_flag
from a
left join 
(select user_id, g5_plan_flag from share_yy.plan_fee_change_day_202004 where flag='a_升档'
union 
select user_id, g5_plan_flag from share_yy.plan_fee_change_day_202005 where flag='a_升档'
union 
select user_id, g5_plan_flag from share_yy.plan_fee_change_day_202006 where flag='a_升档'
) b on a.user_id=b.user_id;
quit;

proc sort data=shiyang.kb_plan_up nodupkey;by user_id;run;


