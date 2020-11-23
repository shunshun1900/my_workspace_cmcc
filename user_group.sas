%let j=date();
data _null_;
call symput("curday",intnx('day',&j.,-1));
call symput("premon_day",intnx('month',intnx('day',&j.,-1),-1,'same'));
call symput("premon_firstday",intnx('month',intnx('day',&j.,-1),-1,'b'));
call symput("curday_1",put(intnx('day',&j.,-1),yymmddn8.));
call symput("curmon_firstday",intnx('month',intnx('day',&j.,-1),0,'b'));
call symput("curmon_firstday_1",put(intnx('month',intnx('day',&j.,-1),0,'b'),yymmddn8.));
run;


proc sql;
create table xr_group as
select a.* ,b.group_id from xr_info a left join  
(select sub_id  as user_id , cust_id as group_id from dw61.bass1_group_mem_&curday_1. where flag='1') b 
on a.user_id = b.user_id ;
quit;


data xr_group1;
set xr_group;
if group_id^='';
run;


proc sql;
create table xr_group_kb as
select a.* ,b.cust_name, b.vocation, c.GRP_AREA_NAME, d.GRP_DIST_NAME

from xr_group1 a

left join dw61.DWD_PRTY_GRP_INFO_&curday_1. b on a.group_id=b.group_id

left join dw61.DIM_GRP_REGION_DTL c on b.M_GRP_AREA_ID=c.GRP_AREA_ID and c.end_date>&curday.

left join dw61.DIM_GRP_REGION_DTL d on b.M_GRP_DIST_ID=d.GRP_DIST_ID and d.end_date>&curday.;

quit;

roc sort data=xr_group_kb nodupkey;
by phone_no;
run;


data xr_group_kb1;
set xr_group_kb;
if grp_area_name='' then grp_area_name='其他';
if grp_area_name in ('','代理','集客行业','集客重要','其他') 
or (grp_area_name='集团客户部' and grp_dist_name='合作管理部') then grp_dist_name='集团客户部-其他';
if grp_area_name in ('','代理','集客行业','集客重要','其他') then grp_area_name='集团客户部';
run; 


