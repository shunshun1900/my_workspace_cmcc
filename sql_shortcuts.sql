-- sql shortcuts

-- kb basic left join
create table kb1 as 
select a.*,
    kb.BFR_ALCT_TOTAL_FEE as arpu,
    kb.gprs_miss_flow as dou,
    kb.bill_dur as mou,
    kb.user_state_id,
    kb.plan_name,
    kb.join_date,
    kb.online_id
from table_A A 
left join share_yy.kb_&month kb on A.user_id = kb.user_id;

-- kb xz

create table qltx_kb as
select
a.*,
kb.phone_no,
case when kb.GRP_SVC_MBR_FLAG=0 and kb.GRP_INST_MBR_FLAG=0 then 0  else  1 end as grp_flag,
kb.join_date,
kb.bfr_alct_total_fee as arpu,
kb.gprs_miss_flow as dou,
kb.bill_dur as mou,
kb.GPRS_RM_PROV,
kb.GPRS_RM_COUNTRY,
kb.online_id,
kb.lvl3_plan_name,
kb.plan_name,
kb.plan_fee, 
kb.credit_level_id, 
kb.age,
kb.area_name,
kb.plan_fee
from user_comm_20200131  a
left join share_yy.kb_&month kb on a.user_id=kb.user_id;

-- left join scripts
%MACRO ;

%MEDN: