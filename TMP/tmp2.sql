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



-- 12jun2020
proc sql;
create table kb2 as 
select a.*,
b.after_yh_tcbase_fee as pre_tcbase_fee
from kb1 A
left join share_yy.tc_fee_fin_202004 B on a.user_id=b.user_id;
quit;

proc sql;
create table kb2 as 
select a.*,
b.after_yh_tcbase_fee as cur_tcbase_fee
from kb2 A
left join share_yy.tc_fee_fin_202005 B on a.user_id=b.user_id;
quit;


data kb3;
set kb2;
if missing(pre_tcbase_fee)=0 and missing(cur_tcbase_fee)=0;
if cur_tcbase_fee > pre_tcbase_fee then sd_flag = 1;
else if cur_tcbase_fee = pre_tcbase_fee then sd_flag = 2;
else if cur_tcbase_fee < pre_tcbase_fee then sd_flag = 3;
run;


%macro aaa();
%do i=201911 %to 201912;
proc sql;
create table user_tmbd_&i as
select distinct a.user_id,state,a.offer_id,prod_id,create_date,eff_date,exp_date,org_id,op_id 
from dw61.dwd_svc_off_TEM_BIDINS_&i a,lhy.xinyong_gouji_id as b 
where a.offer_id=b.offer_id ;
quit;
%end;
%mend;

proc sql;
create table user_tmbd as
select distinct user_id,state,offer_id,prod_id,create_date,eff_date,exp_date,org_id,op_id 
from dw61.dwd_svc_off_TEM_BIDINS_202005 
where offer_id=111000738054;
quit;


data shiyang.kb2;
set kb2;
run;

data kb2;
set shiyang.kb2;
if missing(pre_tcbase_fee)=0 and missing(cur_tcbase_fee)=0;
if (cur_tcbase_fee - pre_tcbase_fee)>0 then sd_flag = 1;
 if cur_tcbase_fee = pre_tcbase_fee then sd_flag = 2;
 if cur_tcbase_fee < pre_tcbase_fee then sd_flag = 3;
run;

proc sql;
create table kb4 as 
select a.*,
case when b.user_id is null then 0 else 1 end as tmbd_flag
from kb2 A
left join user_tmbd B on a.user_id=b.user_id;
quit;

-- 16jun2020
proc sql;
create table shiyang.wms as
select a.*
b.complain_desc,
b.lvl3desc,
b.lvl4desc,
b.lvl5desc,
b.lvl6desc,
b.lvl7desc
from dw61.dwd_evt_wms_wf_ins_his_dm_2020 a
left join shiyang.dim_evt_wms_complain_type b
on a.complain_type=b.complain_type
where a.op_date>='01may2020'd  and  a.op_date<='31may2020'd
and b.lvl2desc like "%网络质量%"
and (b.lvl3desc like "手机上网%5G通信%")
;
quit;

proc sort data=shiyang.wms nodupkey; by phone_No; run;

proc sql;
create table g5_net_user as
select sub_id as user_id, count(distinct substr(stat_date,1,10)) as cnt, sum(gprs_5g_flow) as g5_flow from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>="2020-05-01" and substr(stat_date,1,10)<="2020-05-31" group by sub_id; 
quit;

proc sql;
create table shiyang.wms as 
select a.*,
b.user_id
from shiyang.wms A
left join share_yy.kb_202005 B on a.phone_no=b.phone_no;
quit;

proc sql;
create table shiyang.wms as 
select a.*,
b.cnt,
b.g5_flow/1024/1024 as g5_flow
from shiyang.wms A
left join g5_net_user B on a.user_id=b.user_id;
quit;


-- 17jun2020

proc sql;
select * from share_yy.main_offer_fee_next WHERE user_id=''
quit;

proc sql;
select  user_id,phone_no,202005 as dt from share_yy.kb_202005 WHERE user_id=''
union

union

quit;