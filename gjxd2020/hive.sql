/*  linux  */
hadoop fs -ls /user/gjxdshuser/

/* hive SQL  */
drop table gjxdshuser.mqs_st_a;
create table gjxdshuser.mqs_st_a(user_id string) row format delimited fields terminated by ',' stored as textfile;
load data inpath '/user/gjxdshuser/gjxd_mqs_001.txt' into table gjxdshuser.mqs_st_a;

drop table gjxdshuser.mqs_st_ab;
create table gjxdshuser.mqs_st_ab row format delimited fields terminated by '|' stored as textfile as  
select user_id  
from zh1_hw_qwsjuser.mc_86075_sh_dwv_m_cust_plan_high_lvl_info_m 
where statis_date='202006' 
 and user_id in (select user_id from gjxdshuser.mqs_st_a)
group by user_id
;

select count(user_id) from gjxdshuser.mqs_st_ab;

/*  match output var.  */
drop table gjxdshuser.mqs_st_ab_1;
create table gjxdshuser.mqs_st_ab_1 row format delimited fields terminated by '|' stored as textfile as
select 
user_id,
cm_term_brand,
cm_voice_plan_fee, 
cm_flux_plan_fee, 
cm_base_plan_name, 
cm_base_plan_type, 
cm_base_plan_prc, 
is_5g_term_user, 
is_5g_plan_user 
from zh1_hw_qwsjuser.mc_86074_sh_dwv_m_cust_5g_user_m 
where statis_date='202006' 
 and user_id in (select user_id from gjxdshuser.mqs_st_ab)
;

select * from gjxdshuser.mqs_st_ab_1 limit 10;

/* output */
模型ID_数据日期_P省份缩写_重传序号.dat
/user/gjxdshuser/86074_20200908_SH_00.dat
/user/gjxdshuser/86075_20200901_SH_00.dat


insert overwrite directory '/user/gjxdshuser/86074_20200908_SH_00' row format delimited fields terminated by '|'
select * from gjxdshuser.mqs_st_ab_1; 

hadoop fs -cat /user/gjxdshuser/86074_20200908_SH_00.dat | head -2
hadoop fs -rm /user/gjxdshuser/86074_20200908_SH_00.dat/
hadoop fs -getmerge /user/gjxdshuser/86074_20200908_SH_00 86074_20200908_SH_00.dat
hadoop fs -put 86074_20200908_SH_00.dat /user/gjxdshuser/

/* market */
select count(*) from #ODS_GJXD_5GFLOW_PACKET_20200830 where is_recommend=1
-- 1905602

select count(*) from #ODS_GJXD_5GTERMINAL_20200830
--100000