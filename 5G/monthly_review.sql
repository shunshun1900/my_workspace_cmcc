/*   5G marketing satistics for each month since Dec. 2019  */
/* 8 july 2020 */

%let span=7;
%macro loop;
%do i=1 %to &span;

data _null_;
call symput("stat_month_dt",put(INTNX('month',"01Nov2019"d,&i),YYMMN6.));
run;

data _null_;
call symput("stat_month",put(INTNX('month',"01dec2019"d,&i),date9.));
run;

data _null_;
call symput("stat_month_first_date",put(INTNX('month',&stat_month,0,'b'),YYMMDD10.));
call symput("stat_month_last_date",put(INTNX('month',&stat_month,0,'e'),YYMMDD10.));
run;

%put stat_month;
%put stat_month_dt;
%put stat_month_first_date;
%put stat_month_last_date;

%end;
%mend loop;

*scritps;

proc sql;
create table net_user as
select distinct sub_id as user_id from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>="&stat_month_first_date" and substr(stat_date,1,10)<="&stat_month_last_date";
quit;

proc sql;
create table shiyang.kb_5g_&stat_month as 
select kb.user_id, kb.phone_no, kb.last_imei, kb.plan_offer_id,
kb.bfr_alct_total_fee as arpu,
kb.gprs_miss_flow as dou,
case when b.user_id is null then 0 else 1 end as tmn_flag
from share_yy.kb_&stat_month kb
left join share_yy.imei_5g_202006 B
on substr(a.last_imei,1,8)=b.imei8
where  kb.USER_STATE_ID in (100,111)  and kb.lvl1_plan_id in (11010,11020,11030)
and  kb.m2m_flag^=1 and kb.data_crd_flag^=1 and length(kb.phone_no)=11
;
quit;

proc sql;
create table shiyang.kb_5g_&stat_month as 
select kb.*,
case when b.user_id is null then 0 else 1 end as plan_flag
from shiyang.kb_5g_&stat_month kb
left join fengtao.dim_5g_plan b 
on b.plan_offer_id=b.offer_id
;
quit;

proc sql;
create table shiyang.kb_5g_&stat_month as 
select kb.*,
case when b.user_id is null then 0 else 1 end as net_flag
from shiyang.kb_5g_&stat_month kb
left join net_user b on b.user_id=b.user_id
;
quit;

proc sql;
create table shiyang.tmp_stat_&stat_month_dt as
select count(distinct user_id) as cnt, avg(arpu) as arpu, avg(dou) as dou, 1 as type, "&stat_month_dt" as dt
from shiyang.kb_5g_&stat_month
where tmn_flag=1
;

insert into shiyang.tmp_stat_&stat_month_dt
select count(distinct user_id) as cnt, avg(arpu) as arpu, avg(dou) as dou, 2 as type, "&stat_month_dt" as dt
from shiyang.kb_5g_&stat_month
where net_flag=1
;

insert into shiyang.tmp_stat_&stat_month_dt
select count(distinct user_id) as cnt, avg(arpu) as arpu, avg(dou) as dou, 3 as type, "&stat_month_dt" as dt
from shiyang.kb_5g_&stat_month
where plan_flag=1
;

insert into shiyang.tmp_stat_&stat_month_dt
select count(distinct user_id) as cnt, avg(arpu) as arpu, avg(dou) as dou, 4 as type, "&stat_month_dt" as dt
from shiyang.kb_5g_&stat_month
where plan_flag=1 and tmn_flag=1
;

insert into shiyang.tmp_stat_&stat_month_dt
select count(distinct user_id) as cnt, avg(arpu) as arpu, avg(dou) as dou, 5 as type, "&stat_month_dt" as dt
from shiyang.kb_5g_&stat_month
where net_flag=1 and tmn_flag=1
;

insert into shiyang.tmp_stat_&stat_month_dt
select count(distinct user_id) as cnt, avg(arpu) as arpu, avg(dou) as dou, 6 as type, "&stat_month_dt" as dt
from shiyang.kb_5g_&stat_month
where net_flag=1 and tmn_flag=1 and plan_flag=1
;

quit;





