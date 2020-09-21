data _null_;
call symput("start_day",put(INTNX('day',"30jun2020"d,0),date9.));
run;

data _null_;
call symput("start_dt",put(INTNX('day',"&start_day"d,0),YYMMDDN8.));
call symput("end_dt",put(INTNX('day',"&end_day"d,0),YYMMDDN8.));
call symput("start_date",put(INTNX('day',"&start_day"d,0),YYMMDD10.));
call symput("end_date",put(INTNX('day',"&end_day"d,0),YYMMDD10.));
run;

data _null_;
call symput("cur_month",put(INTNX('month',INTNX('day',date(),0),0),YYMMN6.));
call symput("start_month",put(INTNX('month',INTNX('day',"&start_day"d,0),0),YYMMN6.));
call symput("pre_month",put(INTNX('month',INTNX('day',date(),0),-1),YYMMN6.));
run;

proc sql;
create table g5_user as
select distinct phone_no,user_id,imei
from dw61.ST_MKT_TERM_G5_DTL_&start_dt;
quit;

*join plan user;
proc sql;
create table shiyang.tmp_dm_kb as 
select a.*,
b.offer_id,
b.offer_name,
b.offer_fee,
b.gprs_name,
b.gprs_fee
case when b.user_id is null then 0 else 1 end as plan_flag
from g5_user A
left join dw61.st_mkt_ord_5g_usr_dtl_&start_dt B on a.user_id=b.user_id;
quit;

*join share_yy.kb;
proc sql;
create table shiyang.tmp_dm_kb as 
select a.*,
    kb.BFR_ALCT_TOTAL_FEE as arpu,
    kb.gprs_miss_flow as dou,
    kb.bill_dur as mou
from shiyang.tmp_dm_kb A 
left join share_yy.kb_&start_month kb on A.user_id = kb.user_id;
quit;

*join sale;
proc sql;
create table shiyang.tmp_dm_kb as 
select a.*,
case when b.imei is null then 0 else 1 end as sale_flag
from shiyang.tmp_dm_kb A
left join bgq.test_sale_imei_5g B on a.imei=b.imei;
quit;

*join dm info;
proc sql;
create table shiyang.tmp_dm_kb as 
select a.*,
b.dm_flag,
b.main_carrier,
b.sec_carrier,
b.main_flag,
b.local_flag,
b.imsi2_local_flag
from shiyang.tmp_dm_kb A
left join shiyang.dm_imei_&start_month B on a.imei=b.imei
;
quit;

/* obs dm used change in June of Apri users */
data _null_;
call symput("start_day",put(INTNX('day',"30Apr2020"d,0),date9.));
run;

data _null_;
call symput("start_dt",put(INTNX('day',"&start_day"d,0),YYMMDDN8.));
call symput("end_dt",put(INTNX('day',"&end_day"d,0),YYMMDDN8.));
call symput("start_date",put(INTNX('day',"&start_day"d,0),YYMMDD10.));
call symput("end_date",put(INTNX('day',"&end_day"d,0),YYMMDD10.));
run;

proc sql;
create table g5_user_apri as
select distinct phone_no,user_id,imei
from shiyang.ST_MKT_TERM_G5_DTL_&start_dt;
quit;

*join dm info;
proc sql;
create table shiyang.tmp_dm_kb_apri as 
select a.*,
b.dm_flag,
b.main_carrier,
b.sec_carrier,
b.main_flag,
b.local_flag,
b.imsi2_local_flag
from g5_user_apri A
left join shiyang.dm_imei_&start_month B on a.imei=b.imei
;
quit;

proc sql;
create table shiyang.tmp_dm_kb_apri as 
select a.*,
b.dm_flag as dm_flag_next,
b.main_carrier as main_carrier_next,
b.sec_carrier as sec_carrier_next,
b.main_flag as main_flag_next,
b.local_flag as local_flag_next,
b.imsi2_local_flag as imsi2_local_flag_next
from shiyang.tmp_dm_kb_apri A
left join shiyang.dm_imei_202006 B on a.imei=b.imei
;
quit;


--16 july 2020
proc sql;
create table shiyang.tmp_dm_kb_apri as
select a.*,
case when b.user_id is null then 0 else 1 end as family_flag
from  shiyang.tmp_dm_kb_apri  A 
left join share_yy.KUANDAI_RELATION_USER_202004 B
on a.user_id=b.user_id
;
quit;

proc sql;
create table shiyang.tmp_dm_kb_apri as
select a.*,
case when b.user_id is null then 0 else 1 end as family_flag_next
from  shiyang.tmp_dm_kb_apri  A 
left join share_yy.KUANDAI_RELATION_USER_202006 B
on a.user_id=b.user_id
;
quit;

*join share_yy.kb;
proc sql;
create table shiyang.tmp_dm_kb_apri as 
select a.*,
    kb.BFR_ALCT_TOTAL_FEE as arpu,
    kb.gprs_miss_flow as dou,
    kb.bill_dur as mou,
    kb.gprs_total,
    kb.rwk_total
from shiyang.tmp_dm_kb_apri A 
left join share_yy.kb_202004 kb on A.user_id = kb.user_id;
quit;

proc sql;
create table shiyang.tmp_dm_kb_apri as 
select a.*,
    kb.BFR_ALCT_TOTAL_FEE as arpu_next,
    kb.gprs_miss_flow as dou_next,
    kb.bill_dur as mou_next,
    kb.gprs_total as gprs_total_next,
    kb.rwk_total as rwk_total_next
from shiyang.tmp_dm_kb_apri A 
left join share_yy.kb_202006 kb on A.user_id = kb.user_id;
quit;


-- to yaxin

create table out as 
select a.user_id,
case when b.imei is null then 0 else 1 end as may_flag,
case when c.imei is null then 0 else 1 end as apr_flag,
case when d.imei is null then 0 else 1 end as mar_flag
from shiyang.tmp_dm_kb A
left join
(select distinct imei from shiyang.dm_imei_202005 where dm_flag=3) B on a.imei=b.imei
left join
(select distinct imei from shiyang.dm_imei_202004 where dm_flag=3) C on a.imei=c.imei
left join
(select distinct imei from shiyang.dm_imei_202003 where dm_flag=3) D on a.imei=d.imei
where a.dm_flag=3
;

proc freq data=out;
table may_flag apr_flag mar_flag;
run;


