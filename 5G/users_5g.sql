-- 5g user;
proc sql;
create table user as
select distinct phone_no,user_id,imei
from dw61.ST_MKT_TERM_G5_DTL_&stat_day;
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
run;

proc sort data=plan nodupkey ;by user_id phone_no  ;run;