%let stat_day = 20200531;
-- 5g user; [5g]
proc sql;
create table user as
select distinct phone_no,user_id,imei
from dw61.ST_MKT_TERM_G5_DTL_&stat_day
quit;

-- 5g net user;
proc sql;
create table net_user as
select distinct sub_id as user_id from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>='2020-05-01' and substr(stat_date,1,10)<='2020-05-13'; 
quit;

-- 5g plan user
data plan;
set shiyang.st_mkt_ord_5g_usr_dtl_&stat_day;
keep user_id phone_no;
if bass_user_state_id = 100 or bass_user_state_id = 111;
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