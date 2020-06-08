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
create table tmp_user_info_&pre_dt as
select 
phone_no,
user_id,
join_date, 
online_id,
DATA_CRD_FLAG,
WAP20_FLAG,
 USER_STATE_ID
from dw61.dwa_usr_info_&pre_dt
where  USER_STATE_ID in (100,111)  and lvl1_plan_id in (11010,11020,11030) and length(phone_no)=11;
quit;

-- pay user month
proc sql;
select * from share_yy.kb_&month
where is_dykz=1 and m2m_flag^=1 and data_crd_flag^=1;
quit;

-- pay user day
proc sql;
create table user_base as 
select distinct a.user_id,a.phone_no,&pre_dt as day  
from dw61.dwa_usr_info_&pre_dt a 
left join dw61.dwa_usr_info_ext_&pre_dt b 
on a.user_id=b.user_id 
inner join dw61.st_mkt_qwty_dtl_&pre_dt c 
on a.user_id=c.user_id
where  a.data_crd_flag^=1 
and b.m2m_inst_flag^=1 and b.m2m_plan_flag^=1 and 
 b.bass1_m2m_flag^=1 and a.user_state_id not in (103)
;
quit;
-- comm user month
create table user_comm_20200131 as 
select distinct user_id 
from dw61.ST_MKT_YWWG_COMM_CM_M_20200131
where user_id is not null;

-- comm user day