proc sql outobs=10;
create table r as
select * from dw61.st_mkt_bc_key_person_202003;
quit;
proc sql ;
create table sc_yw as 
select user_id,phone_no ,group_no,small_circle_bs,area_name,GROUP_NUM_YIWANG from dw61.st_mkt_bc_key_person_202003 where 
GROUP_NUM_YIWANG >0;
quit;
proc sort data=sc_yw;
by user_id phone_no;
run;
proc sort data=sc_yw out=ys;
by user_id phone_no;
run;
proc sort data=ys nodupkey;
by user_id phone_no;
run;
proc sql ;
create table sc_yw_tc as 
select * from ys where user_id not in (select user_id from share_yy.yw_bc_highvalue_20200615);
quit;
/*proc sql;*/
/*create table sc_yw_tc_qz as*/
/*select a.* ,b.crowd_id from sc_yw_tc a left join (select user_id ,state as is_crowd,crowd_id from dw61.DWD_SVC_OFF_CROWD_INST_202005 where exp_date<='16jun2020'd) b*/
/*on a.user_id=b.user_id;*/
/*quit;*/
/*proc sql ;*/
/*create table sc_yw_tc_qz_kd as*/
/*select a.* ,b.LAN_USER_ID from sc_yw_tc_qz a left join (select user_id ,phone_no,LAN_USER_ID from dw61.DWA_USR_EVT_LAN_INFO_202004 where (EXP_DATE<='16jun2020'd )or (CE_EXP_DATE<='16jun2020'd)) b*/
/*on a.user_id=b.user_id;*/
/*quit;*/
proc sql;
create table sc_yw_tc_f as
select a.* ,b.is_main_bill from sc_yw_tc a left join (select distinct user_id,is_main_bill,EXT3 from DW61.DWD_SVC_FA_NT_ORD_INS_202005
where EXPIRE_DATE>EFFECTIVE_DATE AND datepart(EXPIRE_DATE)>'16jun2020'd and 
      EXT3 ne '') b on a.user_id=b.user_id;
quit;
proc sql ;
create table sc_yw_tc_fq as
select a.* ,b.MAIN_PHONE_NO_FLAG from sc_yw_tc_f a left join (SELECT distinct user_id, MAIN_PHONE_NO_FLAG,CROWD_ID
FROM DW61.DWD_SVC_OFF_CRD_INS_20200615 
WHERE OFFER_ID not IN (380000029188,350200000022,350200000004) 
and EXP_DATE>EFF_DATE AND EXP_DATE>'16jun2020'd and CROWD_ID ne '' ) b on a.user_id=b.user_id;
quit;
data sc_yw_tc_fq_1;
set sc_yw_tc_fq;
if is_main_bill='' and MAIN_PHONE_NO_FLAG=. then is_crowd=0;
else is_crowd=1;
run;
proc sql ;
create table sc_yw_tc_fq_lan as
select a.* ,b.lan_user_id from sc_yw_tc_fq_1 a left join (select distinct user_id , lan_user_id  from
dw61.ST_MKT_14