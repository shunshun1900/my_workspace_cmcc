
/* loop by month */
%macro kb;
%let span=5;
%let dt=20201109;
%let start_day = 01May2020;
%do i=1 %to &span.;

data _null_;
call symput("month",put(intnx('month',"&start_day"d,&i),yymmn6.));
run;

%put &month.;

/*
*****************SQL start******************************
*/
/*edit here*/
proc sql;
create table shiyang.G5_YWZK_STRATEGY_&dt. as 
select a.*,
b.dm_type_&month.
from  SHIYANG.G5_TMN_KB_&dt. A
left join shiyang.dm_imei_&month. B on a.imei=b.imei
;
quit;
/*
*****************SQL end******************************
*/

%end;
%mend kb;