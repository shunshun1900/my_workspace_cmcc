proc sql;
create table temp as 
select 
user_Id,
phone_no,
plan_fee_next,
arpu,
dou,
mou,
main_total,
main_bhd,
age
from share_yy.GPRS_UPDATE_STRATEGY_202009
where
(
huchi_5gthb_flag=0 and 
(
IS_5GTH_30cut20_TAG=1
or IS_5GTH_30cut10_TAG=1
or IS_5GTH_50cut20_TAG=1
or IS_5GTH_50cut10_TAG=1
)
and plan_fee_next>=20 and plan_fee_next<=70
);

proc sql;
create table temp_kb as 
select a.*,
case when b.user_id is null then 0 else 1 end as is_thb
from temp_kb A
left join
(select distinct user_id from shiyang.G5_OFFER_KB_20201018 where  offer_type=1 or offer_type=3)
 B on a.user_id=b.user_id;
quit;

proc sql;
create table temp_kb as 
select a.*,
case when b.user_id is null then 0 else 1 end as is_g5_user
from temp_kb A
left join
shiyang.G5_TMN_KB_20201018
 B on a.user_id=b.user_id;
quit;

proc sql;
create table temp_kb as 
select a.*,
b.days,
b.lac_count
from temp_kb A
left join
share_yy.work_home_202009
 B on a.phone_no=b.msisdn;
quit;

proc sql;
create table temp_kb as 
select a.*,
case when b.user_id is null then 0 else 1 end as is_hj_mqs,
case when b.user_id is null then 0 else 1 end as is_hj_gjxd
from temp_kb A
left join
bgq.HUANJI_GOAL_335WAN B on a.user_id=b.user_id
 left join shiyang.ODS_GJXD_5GTERMINAL_20200830 c 
 on a.user_id=c.user_id
 ;
quit;


proc sql;
select count(*) from temp_kb
where dou>=1024*1024*1024
quit;