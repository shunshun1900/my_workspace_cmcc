%let stat_month=201905;

/*  basic from kb */
proc sql;
create table dataset as
select phone_no,user_id,last_imei,most_imei,

bfr_alct_total_fee as arpu,
gprs_miss_flow as dou,
bill_dur as mou,
gprs_fee,
MAIN_TOTAL,
KXB_TOTAL_AMOUNT,

plan_fee,
credit_level_id,
age,
GENDER_ID,
lvl1_plan_id

from share_yy.kb_&stat_month
where
USER_STATE_ID in (100)
and lvl1_plan_id in (11010,11020,11030)
and  m2m_flag^=1 
and data_crd_flag^=1 
and length(phone_no)=11
and online_id>=24
and oa_flag<>1
;
quit;

/*    terminal used 
bgq.test_change_model
     */

proc sql;
create table dataset as 
select a.*,
b.tac_past,
b.tac_now,
b.past_day,
b.past_month,
case when b.user_id is null then 0 else 1 end as is_change
from dataset A 
left join
(select * from bgq.test_change_model where change_month='06')  B 
on a.user_id=B.user_id
;
quit;


/* from  dm: is_double
shiyang.dm_imei_&stat_month

*/

proc sql;
create table dataset as 
select a.*,
b.card_num,
b.dm_flag,
b.main_carrier,
b.sec_carrier,
b.main_flag
from dataset A
left join shiyang.dm_imei_&stat_month B
on a.most_imei=B.imei
;
quit;


/* from work_home: is_urban_work is_urban_home  */
proc sql;
create table work_home as 
select a.msisdn,a.lacci_h,a.lacci_w,
b.district as district_h,
c.district as district_w
from share_yy.work_home_&stat_month A 
left join shiyang.laccell&stat_month B on a.lacci_h=b.laccell
left join shiyang.laccell&stat_month C on a.lacci_w=c.laccell
where length(a.phone_no)=11 and a.lacci_w is not null and a.lacci_w is not null
;
quit;

proc sql;
create table dataset as 
select a.*,
b.district_h,
b.district_w
from dataset A
left join work_home B
on a.phone_no=B.msisdn
;
quit;


/* training set */

/* feature nomarlization */