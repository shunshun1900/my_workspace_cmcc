-- 5g user; g5_user
proc sql;
create table shiyang.g5_user as
select distinct phone_no,user_id,imei
from dw61.ST_MKT_TERM_G5_DTL_&pre_dt;
quit;

/* since 27Aug2020 */
#ST_MKT_LE_5G_TAC_YYYYMMDD

-- 5g net user; g5_ net_user
proc sql;
create table shiyang.g5_net_user as
select distinct sub_id as user_id from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>="&cur_month_first_date" and substr(stat_date,1,10)<="&pre_date"; 
quit;

select count(distinct sub_id) from #ST_INDEX_USER_5G_FLOW_DM 
where stat_date>=TO_DATE('2020-05-01','yyyy-mm-dd') and stat_date>=TO_DATE('2020-05-31','yyyy-mm-dd')

-- 5g plan user; g5_plan_user
data shiyang.g5_plan_user;
set dw61.st_mkt_ord_5g_usr_dtl_&pre_dt;
if bass_user_state_id = 100 or bass_user_state_id = 111;
keep user_id phone_no;
run;
proc sort data=plan nodupkey ;by user_id phone_no  ;run;

-- 5g kb day
proc sql;
create table kb_day as
select a.phone_no, a.user_id, a.imei,
	case when c.user_id is null then 0 else 1 end as plan_flag,
	case when d.user_id is null then 0 else 1 end as net_flag
from user A
left join plan C on a.user_id=c.user_id
left join net_user D on a.user_id=d.user_id;
quit;

proc sort data=plan nodupkey ;by user_id phone_no  ;run;
proc contents data=dw61.ST_MKT_TERM_G5_DTL_20200526;run;
proc contents data=dw61.ST_INDEX_USER_5G_FLOW_DM;run;
proc contents data=dw61.st_mkt_ord_5g_usr_dtl_20200526;run;

/* g5_group_plan_user_detail
  -- user_id  offer_id offer_name create_date eff_date exp_date offer_type state_type
  note: 5G main plan has same fixed exp_date "06jun2099"

*/

proc sql;
create table order_1  as
select b.user_id,b.offer_id,create_date,eff_date,exp_date, a.offer_name,a.diejia_flag,a.quanyi_flag
from
shiyang.dim_5g_plan A
inner join
dw61.DWD_SVC_OFF_URVAS_INS_&pre_dt B
on a.offer_id=b.offer_id
where a.group_flag=1 and (a.diejia_flag=1 or a.quanyi_flag=1);

create table shiyang.g5_group_plan_user_detail as
select user_id, offer_id, offer_name, create_date, eff_date, "06jun2099"d as exp_date, 1 as offer_type
from dw61.st_mkt_ord_5g_usr_dtl_&pre_dt;

insert into shiyang.g5_group_plan_user_detail
select user_id, offer_id, offer_name, create_date, eff_date, exp_date, 2 as offer_type
from order_1
where diejia_flag=1;

insert into shiyang.g5_group_plan_user_detail
select user_id, offer_id, offer_name, create_date, eff_date, exp_date, 3 as offer_type
from order_1
where quanyi_flag=1;
quit;

proc sort data = shiyang.g5_group_plan_user_detail nodupkey; by user_id offer_id; run;

/*

China Mobile pro
*/
proc sql;
create table pro  as
select b.*,
a.offer_name
from
shiyang.dim_5g_plan A
inner join
fengtao.yewu_bl_all_dm_20200615 B
on a.offer_id=b.offer_id
where a.offer_name like "移动PRO%" or a.offer_name like "移动pro%"
;
quit;


/*
M-zone pro

*/

proc sql;
create table m_zone as 
select * from fengtao.yewu_bl_all_dm_20200615
where offer_id in (111000735281,111000735285,111000735289)
;
quit;


