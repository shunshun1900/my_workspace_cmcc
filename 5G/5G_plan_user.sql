
%let stat_month=202006;
%let stat_dt=20200630;

/*   from st_mkt    */
data plan;
set shiyang.st_mkt_ord_5g_usr_dtl_&stat_dt;
FORMAT gprs_eff_date date9.;
gprs_eff_date=datepart(gprs_eff_time);
if bass_user_state_id = 100 or bass_user_state_id = 111;
if eff_date>="01jul2020"d then delete;
if gprs_eff_date>="01jul2020"d then delete;
run;

proc sort data= plan nodupkey ;by user_id phone_no;run;

/*   from kb plan_offer_id  */

proc sql;
create table kb_5g_&stat_month as 
select kb.user_id, kb.phone_no, kb.last_imei, kb.plan_offer_id,
kb.plan_offer_id_next,
kb.user_state_id,
kb.lvl1_plan_id,
case when b.offer_id is null then 0 else 1 end as plan_flag_cur,
case when c.offer_id is null then 0 else 1 end as plan_flag_next
from share_yy.kb_&stat_month kb
left join fengtao.dim_5g_plan b 
on kb.plan_offer_id=b.offer_id
left join fengtao.dim_5g_plan c
on kb.plan_offer_id=c.offer_id
where length(kb.phone_no)=11
;
quit;

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
dw61.DWD_SVC_OFF_URVAS_INS_&stat_dt B
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
dw61.dwd_svc_off_main_inst_&stat_dt B
on a.offer_id=b.offer_id
;
quit;

data order;
set order1 order2;
run;

/*  statistic   */

data plan_all;
set shiyang.st_mkt_ord_5g_usr_dtl_&stat_dt;
FORMAT gprs_eff_date date9.;
gprs_eff_date=datepart(gprs_eff_time);
run;


title 'current effective plan';
proc sql;
select count(distinct user_id) as from_skt from plan
;

select count(distinct user_id) as from_kb from kb_5g_&stat_month
where plan_flag_cur=1
;

select count(distinct user_id) as from_order from order
where eff_date<="30jun2020"d and exp_date>"01jul2020"d and main_flag=1
;
quit;


title 'next period effective plan';
proc sql;
select count(distinct user_id) as from_skt from plan_all
where eff_date>="01jul2020"d or gprs_eff_date>="01jul2020"d
;

select count(distinct user_id) as from_kb from kb_5g_&stat_month
where plan_flag_next=1 and plan_flag_cur=0
;

select count(distinct user_id) as from_order from order
where eff_date>="01jul2020"d and exp_date<>eff_date and main_flag=1
;
quit;


tile 'all ordered plan';
proc sql;
select count(distinct user_id) as from_skt from plan_all
;

select count(distinct user_id) as from_kb from kb_5g_&stat_month
where plan_flag_next=1 or plan_flag_cur=1
;

select count(distinct user_id) as from_order from order
where exp_date<>eff_date and main_flag=1
;
quit;
