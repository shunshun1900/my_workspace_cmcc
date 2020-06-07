-- 5g user; g5_user
proc sql;
create table shiyang.g5_user as
select distinct phone_no,user_id,imei
from dw61.ST_MKT_TERM_G5_DTL_&pre_dt;
quit;

-- 5g net user; g5_ net_user
proc sql;
create table shiyang.g5_net_user as
select distinct sub_id as user_id from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>="&cur_month_first_date" and substr(stat_date,1,10)<="&pre_date"; 
quit;

-- 5g plan user; g5_plan_user
data shiyang.g5_plan_user;
set dw61.st_mkt_ord_5g_usr_dtl_&pre_dt;
keep user_id phone_no;
run;

proc sort data=plan nodupkey ;by user_id phone_no  ;run;
proc contents data=dw61.ST_MKT_TERM_G5_DTL_20200526;run;
proc contents data=dw61.ST_INDEX_USER_5G_FLOW_DM;run;
proc contents data=dw61.st_mkt_ord_5g_usr_dtl_20200526;run;

-- g5_group_plan_user

-- g5_reservation_user
