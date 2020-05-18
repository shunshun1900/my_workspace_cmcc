-- personal user month
proc sql;
create table tmp_1 as
select phone_no,user_id,imsi 
from share_yy.kb_&month
where  USER_STATE_ID in (100,111)  and lvl1_plan_id in (11010,11020,11030)
and  m2m_flag^=1 and data_crd_flag^=1 and length(phone_no)=11;
quit;

-- personal user day
proc sql;
create table tmp_user_info_&cur_day as
select 
phone_no,
user_id,
join_date, 
online_id,
DATA_CRD_FLAG,
WAP20_FLAG,
 USER_STATE_ID
from dw61.dwa_usr_info_&cur_day
where  USER_STATE_ID in (100,111)  and lvl1_plan_id in (11010,11020,11030) and length(phone_no)=11;
quit;

-- pay user month
proc sql;
select * from share_yy.kb_&month
where is_dykz=1 and m2m_flag^=1 and data_crd_flag^=1;
quit;

-- comm user month
create table user_comm_20200131 as 
select distinct user_id 
from dw61.ST_MKT_YWWG_COMM_CM_M_20200131
where user_id is not null;
