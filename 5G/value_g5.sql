%let i=0;

data _null_;
call symput("start_day",put(INTNX('day',"30Apr2020"d,0),date9.));
call symput("end_day",put(INTNX('day',"13may2020"d,0),date9.));
run;

data _null_;
call symput("start_dt",put(INTNX('day',"&start_day"d,0),YYMMDDN8.));
call symput("end_dt",put(INTNX('day',"&end_day"d,0),YYMMDDN8.));
call symput("start_date",put(INTNX('day',"&start_day"d,0),YYMMDD10.));
call symput("end_date",put(INTNX('day',"&end_day"d,0),YYMMDD10.));
run;

data _null_;
call symput("start_month",put(INTNX('month',"&start_day"d,&i),YYMMN6.));

run;

data _null_;
call symput("start_month_day",put(INTNX('month',"&start_day"d,&i),date9.));
run;

data _null_;
call symput("start_month_first_date",put(INTNX('month',&start_month_day,0,'b'),YYMMDD10.));
call symput("start_month_last_date",put(INTNX('month',&start_month_day,0,'e'),YYMMDD10.));
run;

%put start_month;
%put start_month_first_date;
%put start_month_last_date;

/* 5g user; g5_user */
proc sql;
create table g5_user as
select distinct user_id, 0 as flag
from shiyang.ST_MKT_TERM_G5_DTL_&start_dt;
quit;

/* 5g net user; g5_ net_user */
proc sql;
create table g5_net_user as
select distinct sub_id as user_id,3 as flag from dw61.ST_INDEX_USER_5G_FLOW_DM 
where substr(stat_date,1,10)>="&start_month_first_date" and substr(stat_date,1,10)<="&start_month_last_date"; 
quit;

/* main plan from kb  */
/*   from order table */
proc sql;
create table order_1  as
select b.user_id,b.offer_id,create_date,eff_date,exp_date,
a.offer_name,
a.diejia_flag,
a.quanyi_flag,
a.main_flag,
a.group_flag
from
shiyang.dim_5g_plan A
inner join
dw61.DWD_SVC_OFF_URVAS_INS_&start_dt B
on a.offer_id=b.offer_id
;
quit;

proc sql;
create table order_2  as
select b.user_id,b.offer_id,b.create_date,b.eff_date,b.exp_date,
a.offer_name,
a.diejia_flag,
a.quanyi_flag,
a.main_flag,
a.group_flag
from
shiyang.dim_5g_plan A
inner join
dw61.dwd_svc_off_main_inst_&start_dt B
on a.offer_id=b.offer_id
;
quit;

data shiyang.order_&start_month;
set order1 order2;
run;

data cur_order;
set shiyang.order_&start_month;
if eff_date NE exp_date and eff_date<="&start_day"d;
run;

proc sql;
create table main_plan as
select distinct user_id,1 as flag from cur_order
where group_flag=1 and (main_flag=1 or diejia_flag=1);
quit;

proc sql;
create table quanyi_plan as
select distinct user_id ,2 as flag from cur_order
where group_flag=1 and quanyi_flag=1;
quti;

data user;
set g5_user main_plan quanyi_plan g5_net_user;
run;

proc sql;
create table kb as
select a.*,
b.bfr_alct_total_fee as arpu, 
b.gprs_miss_flow as dou
from user a 
left join share_yy.kb_&start_month b
on a.user_id=b.user_id
;
quit;

proc sql;
create table kb as
select
a.*,
c.user_zhekou
from kb A
left join 
(
select user_id, sum(ZKZR_SHQ) as user_zhekou 
from dw61.ST_MKT_ALL_USR_ZKZR_&start_month 
group by user_id
) c
on a.user_id=c.user_id
;
quit;

data shiyang.tmp_week_&start_month;
set kb;
if arpu=. then arpu=0;
if user_zhekou=. then arpu=0;
arpu_zhekou=arpu+user_zhekou;
run;

proc sql;
create table shiyang.tmn_kb_&start_month as
select a.*,
	case when c.user_id is null then 0 else 1 end as plan_flag,
	case when d.user_id is null then 0 else 1 end as net_flag
from (select * from kb where flag=0) as A
left join main_plan C on a.user_id=c.user_id
left join g5_net_user D on a.user_id=d.user_id;
quit; 

proc means data=shiang.tmp_week_&start_month;
class flag;
var arpu_zhekou;
run;

proc means data=shiang.tmn_kb_&start_month;
where plan_flag=1;
var arpu_zhekou;
run;

proc means data=shiang.tmn_kb_&start_month;
where net_flag=1;
var arpu_zhekou;
run;

proc means data=shiang.tmn_kb_&start_month;
where net_flag=1 and plan_flag=1;
var arpu_zhekou;
run;




