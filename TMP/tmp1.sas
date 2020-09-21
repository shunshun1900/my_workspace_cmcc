%_eg_conditional_dropds();

%macro task_basic_data();

%local month;
%let month=202006;

/* --------------------------- 
basic users from kb
 ---------------------    */
proc sql;
create table basic_dataset as
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

from share_yy.kb_&month.
where
USER_STATE_ID in (100)
and lvl1_plan_id in (11010,11020,11030)
and  m2m_flag^=1 
and data_crd_flag^=1 
and length(phone_no)=11
and online_id>=24
;
quit;

/*
tmn used period
bgq.IMEI_KU_LAST0630
bgq.IMEI_KU_FIRST
*/
PROC SQL;
   CREATE TABLE WORK.QUERY_FOR_IMEI_KU_FIRST AS 
   SELECT t1.USER_ID, 
          t1.imei, 
          t1.dt LABEL="第一次使用时间" AS start_dt, 
          t2.dt LABEL="最后一次使用时间" AS end_dt
      FROM BGQ.IMEI_KU_FIRST t1, BGQ.IMEI_KU_LAST0630 t2
      WHERE (t1.USER_ID = t2.USER_ID AND t1.imei = t2.imei);
QUIT;

data imei_data;
set QUERY_FOR_IMEI_KU_FIRST;
use_day=intck(day,input(start_dt,YYMMDDN8.),input(end_dt,YYMMDDN8.));
use_month=intck(month,input(start_dt,YYMMDDN8.),input(end_dt,YYMMDDN8.));
tac=substr(imei,1,8);
STOP;
run;




%mend task_basic_data;

%macro task_join();

%mend task_join;

%macro main();

%mend main;

%main
run; quit;

%_eg_conditional_dropds();