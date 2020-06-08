-- tmp file
/*month reach account*/
proc sql;
create table user_03 as
select a.user_id,a.phone_no,a.last_imei as imei,
a.BFR_ALCT_TOTAL_FEE as arpu4,
a.area_name,
d.offer_id
from share_yy.kb_202004 A
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
kb2.bfr_alct_total_fee as arpu3
from user_03 A 
left join share_yy.kb_202003 kb2 on a.user_id=kb2.user_id;
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

proc sql;
create table kb_area as 
select a.id,a.area_name,
b.arpu3,
b.arpu4
from shiyang.dim_xz_area A
left join (select area_name, avg(arpu3) as arpu3, avg(arpu4) as arpu4 from kb1 group by area_name) B 
on a.area_name=b.area_name
ORDER by a.id;
quit;


-- 5g plan
proc sql;
create table plan as
select a.user_id,a.phone_no,a.last_imei as imei,
a.BFR_ALCT_TOTAL_FEE as arpu4,
a.area_name,
a.online_id,
d.offer_id
from share_yy.kb_202004 A
inner join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id
 where a.USER_STATE_ID in (100,111)  and  a.m2m_flag^=1 and a.data_crd_flag^=1 and length(a.phone_no)=11;
quit;

proc sql;
create table plan_1 as
select a.*,
d.bfr_alct_total_fee as arpu3
case when d.offer_id is null then 0 else then 1 end as plan_flag
from share_yy.kb_202003 A
left join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id
 where a.USER_STATE_ID in (100,111)  and  a.m2m_flag^=1 and a.data_crd_flag^=1 and length(a.phone_no)=11;
quit;

proc sql;
create table plan_1 as 
select a.*,
case when d.offer_id is null then 0 else then 1 end as plan_flag
from plan A 
left join share_yy.kb_202003 d on a.user_id=d.user_id;
quit;


proc sort data = plan_1; by user_id nodupkey; run;

proc sql;
create table kb_area as 
select a.id,a.area_name,
b.arpu3,
b.arpu4
from shiyang.dim_xz_area A
left join (select area_name, avg(arpu3) as arpu3, avg(arpu4) as arpu4 from plan_1 group by area_name) B 
on a.area_name=b.area_name
ORDER by a.id;
quit;

proc means data=kb_area(where=( plan_flag=0 and online_id>2));
var arpu3 arpu_4;
run;

proc means data=kb_area(where=( plan_flag=0 and online_id>2));
class area_name;
var arpu3 arpu_4;
run;


-- 28may2020
proc sql;
create table test as
select a.*, 
case when b.user_id is null then 0 else 1 end as f_flag,
b.plan_name_next,
b.plan_offer_id_next
from dw61.st_mkt_ord_5g_usr_dtl_20200525 A 
left join b on a.user_id=b.user_id;
quit;

proc sql;
create table test as
select a.*, 
case when b.user_id is null then 0 else 1 end as kg_flag
from test A 
left join  lhy.USER_BASE_20200525 b on a.user_id=b.user_id;
quit;

-- 29may2020
proc sql;
create table plan AS
select distinct phone_no, user_id, dt from shiyang.st_mkt_ord_5g_usr_dtl_dm
where  dt>="&start_dt" and dt<= "&end_dt";
run;

proc freq data = shiyang.st_mkt_ord_5g_usr_dtl_dm;
table dt;
run;

%let iter_day=&start_dt;

proc sql ;
create table plan AS
select distinct user_id, "&iter_day" as dt from shiyang.st_mkt_ord_5g_usr_dtl_&iter_day A 
inner join lhy.USER_BASE_&iter_day B on a.user_id=b.user_id;
quit ;

%macro kb();
%do i=1 %to &span;
data _null_;
call symput("iter_day",put(intnx('day',"&start_day"d,&i),yymmddn8.));
run;

proc sql ;
INSERT into plan
select distinct user_id, "&iter_day" as dt from shiyang.st_mkt_ord_5g_usr_dtl_&iter_day A 
inner join lhy.USER_BASE_&iter_day B on a.user_id=b.user_id;
quit ;

%end;
%mend;
%kb();

-- 02jun2020
data kb1;
set  shiyang.checkpoint_0529_1;
if days_local=. then days_local=0;
if local_bill_dur=. then local_bill_dur=0;
if local_flow=. then local_flow=0;
if dou=. then dou=0;
if bill_dur=. then bill_dur=0;
if lac_cnt=. then lac_cnt=0;
bill_flag=gprs_flag+call_flag;
if bill_flag >=1 then bill_flag=1;
local_flag=days_local+local_bill_dur+local_flow;
if local_flag >=1 then local_flag=1;
else local_flag=0;
dou=dou/1024/1024;
inner_roam_flow=inner_roam_flow/1024/1024;
local_flow=local_flow/1024/1024;
run;

proc sql;
create table t1 as
select a.*, b.OA_FLAG
from
kb1 A left join
share_yy.kb_202004 B on a.user_id=b.user_id;
quit;

data t2;
set t1;
if net_flag = 0 and local_flag=1 and OA_FLAG = 1;
run;

data xyrj;
set xyrj xyrj2 xyrj_result;
run;

proc sort data = xyrj nodupkey; by phone_no; run;

proc sql;
create table t2 AS
select a.*, b.name, b.email, b.f6, b.f7
from t2 A left join xyrj B on a.phone_no=b.phone_no;
quit;

proc sql;
create table shiyang.t3 AS 
select a.*,b.pp, b.xh, b.xh_sale
from t2 A left join share_yy.imei_5g_202004 B
on substr(a.last_imei,1,8)=b.imei8;
quit;

proc sql;
create table shiyang.dim_5g_plan as 
select a.*, b.prod_item_name, b.prod_item_type
from dim_5g_plan A 
left join dw61.dim_svc_prod_item b on a.prod_item_id = b.prod_item_id;
quit;


