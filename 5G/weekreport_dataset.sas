/*
#input  table

shiyang.g5_user
shiyang.g5_net_user
shiyang.g5_plan_user
shiyang.g5_group_plan_user_detail
shiyang.user_5g_yy
shiyang.dm_imei_&pre_month
hdpyp02.tmp_days_local
share_yy.gprs_fee_202005
	--user_id gprs_fee
share_yy.main_fee_zixuan
	--user_id plan_fee

# output table

shiyang.kb_sent
shiyang.kb_yy
shiyang.kb_plan_market
shiyang.kb_plan_up 
shiyang.call
shiyang.gprs


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


/*    KB: put all together, based on 5G user */

*initial;
proc sql;
create table shiyang.g5_kb as 
select distinct a.user_id, a.phone_no, a.imei
from shiyang.g5_user A;
quit;

*join net user ;
proc sql;
create table shiyang.g5_kb as 
select a.*,
case when b.user_id is null then 0 else 1 end as net_flag
from shiyang.g5_kb A
left join shiyang.g5_net_user B on a.user_id=b.user_id;
quit;

*join plan user;
proc sql;
create table shiyang.g5_kb as 
select a.*,
case when b.user_id is null then 0 else 1 end as plan_flag
from shiyang.g5_kb A
left join shiyang.g5_plan_user B on a.user_id=b.user_id;
quit;

*join main plan info. detail ;
proc sql;
create table shiyang.g5_kb as 
select a.*,
b.plan_fee as gprs_plan_fee,
case when b.user_id is null then 0 else 1 end as zixuan_flag
from shiyang.g5_kb A
left join
(select * from share_yy.main_fee_zixuan where offer_name like "%流量%") B
on a.user_id=b.user_id;
quit;

proc sql;
create table shiyang.g5_kb as 
select a.*,
b.plan_name_next as plan_name,
b.plan_fee_next as plan_fee
from shiyang.g5_kb A
left join share_yy.MAIN_OFFER_FEE_NEXT B on a.user_id=b.user_id;
quit;

*join diejia quanyi info.; 
proc sql;
create table shiyang.g5_kb as 
select a.*,
case when b.user_id is null then 0 else 1 end as diejia_flag
from shiyang.g5_kb A
left join
(select distinct user_id from shiyang.g5_group_plan_user_detail where offer_type=2)
 B on a.user_id=b.user_id;
quit;

proc sql;
create table shiyang.g5_kb as 
select a.*,
case when b.user_id is null then 0 else 1 end as quanyi_flag
from shiyang.g5_kb A
left join
(select distinct user_id from shiyang.g5_group_plan_user_detail where offer_type=3)
 B on a.user_id=b.user_id;
quit;

*join location stay;
proc sql;
create table shiyang.g5_kb as 
select a.*,
b.days_cnt,
b.dur,
b.lac_cnt
from shiyang.g5_kb A
left join shiyang.days_local B on a.phone_no=b.msisdn;
quit;

*join gprs in cur_month;
proc sql;
create table shiyang.g5_kb as 
select a.*,
b.gprs_miss_flow as cur_dou,
b.inner_roam_flow, 
b.inner_roam_onnet_days,
b.local_onnet_days ,
b.lively_days as gprs_lively_days,
b.local_flow,
case when b.user_id is null then 0 else 1 end as gprs_flag
from shiyang.g5_kb A
left join shiyang.gprs B on a.user_id=b.user_id;
quit;

*join gprs in recent 30 days;
proc sql;
create table shiyang.g5_kb as 
select a.*,
b.dou as dou_30,
b.sum_flow as sum_flow_30
from shiyang.g5_kb A
left join shiyang.tmp_flow_&end_dt B on a.user_id=b.user_id;
quit;

*join call in cur_month;
proc sql;
create table shiyang.g5_kb as 
select a.*,
e.bill_dur as cur_bill_dur,
e.local_bill_dur, 
e.inner_roam_bill_dur, 
e.lively_days as call_lively_days,
case when e.user_id is null then 0 else 1 end as call_flag
from shiyang.g5_kb A
left join shiyang.call E on a.user_id=e.user_id;
quit;

*join dm info;
proc sql;
create table shiyang.g5_kb as 
select a.*,
b.double_flag,
b.dm_flag,
b.main_carrier,
b.sec_carrier
from shiyang.g5_kb A
left join shiyang.dm_imei_&pre_month B on a.imei=b.imei;
quit;

proc sql;
create table shiyang.g5_kb as 
select a.*,
b.main_flag
from shiyang.g5_kb A
left join shiyang.dm_imei_&pre_month B on a.imei=b.imei;
quit;

*join gprs fee;
proc sql;
create table shiyang.g5_kb as 
select a.*,
b.gprs_fee
from shiyang.g5_kb A
left join share_yy.gprs_fee_&pre_month B on a.user_id=b.user_id;
quit;

*modify kb for final reports;
proc sort data=shiyang.g5_kb nodupkey; by user_id;run;

data shiyang.g5_kb;
set shiyang.g5_kb;
*modify location stay var.;
days_local=days_cnt;
if days_local=. then days_local=0;
if lac_cnt=. then lac_cnt=0;
*modify gprs var;
if local_bill_dur=. then local_bill_dur=0;
if local_flow=. then local_flow=0;
inner_roam_flow=inner_roam_flow/1024/1024;
local_flow=local_flow/1024/1024;
if dou_30=. then dou_30=0;
if cur_dou=. then cur_dou=0;
cur_dou=cur_dou/1024/1024;
*modify call var;
if cur_bill_dur=. then cur_bill_dur=0;
**add statistics flag;
*bill_flag;
bill_flag=gprs_flag+call_flag;
if bill_flag >=1 then bill_flag=1;
*local stay flag;
local_flag=days_local+local_bill_dur+local_flow;
if local_flag >=1 then local_flag=1;
else local_flag=0;
*5g plan flag;
group_plan_flag=0;
if  plan_flag=1 or diejia_flag=1 or quanyi_flag=1 then group_plan_flag=1;
*user value flag;
valuable_flag=0;
if gprs_plan_fee >= 100 or (plan_fee>=130 and zixuan_flag=0) then valuable_flag=1;
run;

