#5G终端用户换5G套餐-机套匹配
#存量3月办理4月5G套餐生效且4月是5G终端的用户3月和4月价值变化
select count(distinct a.user_id),
sum(value(D.GPRS_MISS_FLOW,0)) AS DOU4,
SUM(value(D.BFR_ALCT_TOTAL_FEE,0)) AS ARPU4,
SUM(value(D.MOC_BILL_DUR,0)) AS MOU4,
sum(value(D.LAST1_GPRS_MISS_FLOW,0)) AS DOU3,
SUM(value(D.LAST1_BFR_ALCT_TOTAL_FEE,0)) AS ARPU3,
SUM(value(D.LAST1_BILL_DUR,0)) AS MOU3,
sum(c.user_zhekou) as user_zhekou4,
sum(e.user_zhekou) as user_zhekou3
from #st_mkt_term_g5_dtl_202004 a
left join #ST_MKT_ORD_5G_USR_DTL_20200505 b
on a.user_id=b.user_id
left join #DWA_USR_BEH_ALL_202004 d
on a.user_id=d.user_id
left join 
(
select user_id, sum(ZKZR_SHH) as user_zhekou 
from #ST_MKT_ALL_USR_ZKZR_202004 
group by user_id
) c
on a.user_id=c.user_id
left join 
(
select user_id, sum(ZKZR_SHH) as user_zhekou 
from #ST_MKT_ALL_USR_ZKZR_202003
group by user_id
) e
on a.user_id=e.user_id
where b.create_5G_fir_date between '2020-03-01' and '2020-03-31'
and b.eff_date ='2020-04-01'


--  sas

/*month reach account*/
%let stat_month=202005;

proc sql;
create table cur_user as
select a.user_id,a.phone_no,a.last_imei as imei,
a.BFR_ALCT_TOTAL_FEE as cur_arpu,
a.area_name,
d.offer_id
from share_yy.kb_&stat_month A
inner join share_yy.imei_5g_&stat_month B
on substr(a.last_imei,1,8)=b.imei8
inner join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id
where a.USER_STATE_ID in (100,111)  and  a.m2m_flag^=1 and a.data_crd_flag^=1 and length(a.phone_no)=11;
quit;

proc sql;
create table kb as 
select a.*,
kb2.last_imei,
kb2.plan_offer_id,
kb2.bfr_alct_total_fee as pre_arpu
from cur_user A 
inner join share_yy.kb_202004 kb2 on a.user_id=kb2.user_id;
quit;

proc sql;
create table kb1 as
select  a.*,
case when b.imei8 is null then 0 else  1 end as tmn_flag,
case when d.offer_id is null then 0 else  1 end as plan_flag
from kb A
left join share_yy.imei_5g_202005 B
on substr(a.last_imei,1,8)=b.imei8
left join fengtao.dim_5g_plan D on a.plan_offer_id=d.offer_id;
quit;

proc sort data = kb1 nodupkey; by user_id ; run;