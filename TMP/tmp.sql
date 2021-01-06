proc sql;
create table g5_kb_&month. AS
select
a.user_id,a.phone_no,a.imei,
case when a.user_id is null then 0 else 1 end as is_dpi,
case when b.user_id is null then 0 else 1 end as is_g5_local,
case when c.user_id is null then 0 else 1 end as is_g5_roam
from shiyang.g5_tmn_kb_&month. a 
left join net_user_&month b 
left join (select distinct user_id from g5_flow_&month. where roam_type=0 ) b on  a.user_id=b.user_id
left join (select distinct user_id from g5_flow_&month. where roam_type=4 ) c on  a.user_id=c.user_id
;
quit;