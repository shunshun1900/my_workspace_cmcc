/*  sas macro  syn */
%MACRO printit;
PROC PRINT DATA = models NOOBS;
 TITLE 'Current Models';
 VAR Model Class Frame Price;
 FORMAT Price DOLLAR6.;
RUN;
%MEND printit;
%printit
PROC SORT DATA = models;
 BY Price;
%printit

%MACRO macro-name (parameter-1=, parameter-2=, . . . parameter-n=);
 macro-text
%MEND macro-name;

/* auto delete the past tables , but reserve the first and last days of a month  */
%macro auto_delete;
%local cur_dt_b7 first_dt  last_dt;

%let cur_dt_b7 = %sysfunc(INTNX(day,"&sysdate9."d,-7),YYMMDDN8.);
%let first_dt = %sysfunc(INTNX(month,"&sysdate9."d,0,b),YYMMDDN8.);
%let last_dt = %sysfunc(INTNX(month,"&sysdate9."d,-1,e),YYMMDDN8.);

 %if  &cur_dt_b7. = &first_dt. or &cur_dt_b7. = &last_dt.
 %then %return;
%else %do;

proc sql;

drop table shiyang.g5_order_&cur_dt_b7;

quit;

%end;
%mend;

/* conditional logic if else */
%IF condition %THEN action;
 %ELSE %IF condition %THEN action;
 %ELSE action;
%IF condition %THEN %DO;
 action;
%END;

%MACRO reports;
 %IF &SYSDAY = Monday %THEN %DO;
 PROC PRINT DATA = orders NOOBS;
 FORMAT OrderDate DATE7.;
 TITLE "&SYSDAY Report: Current Orders";
 %END;
 %ELSE %IF &SYSDAY = Friday %THEN %DO;
 PROC TABULATE DATA = orders;
 CLASS CustomerID;
 VAR Quantity;
 TABLE CustomerID ALL, Quantity;
 TITLE "&SYSDAY Report: Summary of Orders";
 %END;
%MEND reports;
RUN;
%reports
RUN;

/* call symput */
*Sort by Quantity;
PROC SORT DATA = orders;
 BY DESCENDING Quantity;
*Use CALL SYMPUT to find biggest order;
DATA _NULL_;
 SET orders;
 IF _N_ = 1 THEN
 CALL SYMPUT("biggest", CustomerID);
 ELSE STOP;
*Print all obs for customer with biggest order;
PROC PRINT DATA = orders NOOBS;
 WHERE CustomerID = "&biggest";
 FORMAT OrderDate DATE7.;
 TITLE "Customer &biggest Had the Single Largest Order";
RUN;

/* loop by day */
%macro kb;
%do i=1 %to &span;

data _null_;
call symput("iter_day",put(intnx('day',"&start_day"d,&i),yymmddn8.));
run;

proc sql ;
INSERT into net_user
select distinct user_id, "&iter_day" as dt from net_user_tmp where dt <= "&iter_day";
quit ;

%end;
%mend kb;

/* loop by month */
%macro kb;
%let span=5;
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
/*
*****************SQL end******************************
*/

%end;
%mend kb;

/*  sas task templete schedule   */
%macro tmp;
/*  date  */
%local  pre_dt first_dt last_dt cur_month pre_month;

%let pre_dt = %sysfunc(INTNX(day,%sysfunc(date()),-1),YYMMDDN8.);
%let first_dt = %sysfunc(INTNX(month,%sysfunc(date()),0,b),YYMMDDN8.);
%let last_dt = %sysfunc(INTNX(month,%sysfunc(date()),-1,e),YYMMDDN8.);

%let cur_month = %sysfunc(INTNX(month,%sysfunc(date()),0),YYMMN6.);
%let pre_month = %sysfunc(INTNX(month,%sysfunc(date()),-1),YYMMN6.);

%put &cur_month. &pre_month. &pre_dt.  &first_dt. &last_dt;

/*
*****************SQL start******************************
*/


/*
*****************SQL end******************************
*/
%mend;
/*  sas task templete temp   */
%macro tmp;
/*  date  */
%local  pre_dt first_dt last_dt cur_month pre_month;

%let day = %sysfunc(INTNX(day,""d,0),date9.);
%let dt = %sysfunc(INTNX(day,"&day"d,0),YYMMDDN8.);
%let month = %sysfunc(INTNX(month,"&day"d,0),YYMMN6.);
%let pre_month = %sysfunc(INTNX(month,"&day"d,-1),YYMMN6.);

%let pre_dt = %sysfunc(INTNX(day,%sysfunc(date()),-1),YYMMDDN8.);
%let first_dt = %sysfunc(INTNX(month,%sysfunc(date()),0,b),YYMMDDN8.);
%let last_dt = %sysfunc(INTNX(month,%sysfunc(date()),-1,e),YYMMDDN8.);

%let cur_month = %sysfunc(INTNX(month,%sysfunc(date()),0),YYMMN6.);
%let pre_month = %sysfunc(INTNX(month,%sysfunc(date()),-1),YYMMN6.);

%put &cur_month. &pre_month. &pre_dt.  &first_dt. &last_dt;

/*
*****************SQL start******************************
*/


/*
*****************SQL end******************************
*/
%mend;

/*  sas macro scripts for left join, iteration etc...     */

%MACRO leftjoin(out=t1, TABLE_A=, TABLE_B=, key_a=user_id, key_b=user_id );

proc sql;
create TABLE t1 as 
select
a.*,
b.plan_fee
from &TABLE_A A 
left join &TABLE_B B
on a.&key_a = b.&key_b
;
quit;

%MEND leftjoin;


%MACRO print(table /* data set you want print within 100 obs */ );

proc print data= &table(obs=100);
run;

%MEND print;
