-- tmp file
/*month reach account*/
proc sql;
create table user_03 as
select a.user_id,a.phone_no,a.last_imei as imei,
a.BFR_ALCT_TOTAL_FEE as arpu,
a.area_name,
d.offer_id
from share_yy.kb_202003 A
inner join share_yy.imei_5g_202004 B
on substr(a.last_imei,1,8)=b.imei8
inner join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id
 where a.USER_STATE_ID in (100,111)  and  a.m2m_flag^=1 and a.data_crd_flag^=1 and length(a.phone_no)=11;
quit;

proc sql;
create table kb as 
select a.*,
kb2.last_imei,
kb2.plan_offer_id,
kb4.bfr_alct_total_fee as arpu_4
from user_03 A 
left join share_yy.kb_202002 kb2 on a.user_id=kb2.user_id
left join share_yy.kb_202004 kb4 on a.user_id=kb4.user_id;
quit;


proc sql;
create table kb1 as
select  a.*,
case when b.imei8 is null then 0 else then 1 end as tmn_flag,
case when d.offer_id is null then 0 else then 1 end as plan_flag,
from kb1 A
left join share_yy.imei_5g_202004 B
on substr(a.last_imei,1,8)=b.imei8
left join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id;
quit;

proc sort data = kb1; by user_id nodupkey; run;

proc means data=kb1(where=(tmn_flag=0 or plan_flag=0));
class area_name;
var arpu arpu_4;
run;

-- newid

/*month reach account*/
proc sql;
create table user_03 as
select a.user_id,a.phone_no,a.last_imei as imei,
a.BFR_ALCT_TOTAL_FEE as arpu4,
a.area_name,
d.offer_id
from share_yy.kb_202004 A
inner join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id
 where a.USER_STATE_ID in (100,111)  and  a.m2m_flag^=1 and a.data_crd_flag^=1 and length(a.phone_no)=11;
quit;

proc sql;
create table kb as 
select a.*,
kb2.last_imei,
kb2.plan_offer_id,
kb2.bfr_alct_total_fee as arpu3
from user_03 A 
left join share_yy.kb_202003 kb2 on a.user_id=kb2.user_id;
quit;

proc sql;
create table kb1 as
select  a.*,
case when d.offer_id is null then 0 else  1 end as plan_flag
from kb A
left join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id;
quit;

proc sort data = kb1 nodupkey; by user_id ; run;

proc means data=kb1(where=(plan_flag=0));
var arpu3 arpu4;
run;

proc sql;
create table kb_area as 
select a.id,a.area_name,
b.cnt,
b.arpu3,
b.arpu4
from shiyang.dim_xz_area A
left join (select area_name, avg(arpu3) as arpu3, avg(arpu4) as arpu4, count(distinct user_id) as cnt from kb1 where plan_flag=0 group by area_name) B 
on a.area_name=b.area_name
ORDER by a.id;
quit;