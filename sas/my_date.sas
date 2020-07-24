/* data format in sas  */
/* init date */
data _null_;
call symput("start_day",put(INTNX('day',"07may2020"d,0),date9.));
call symput("end_day",put(INTNX('day',"13may2020"d,0),date9.));
run;

data _null_;
call symput("span",intck('day', "&start_day"d, "&end_day"d));
run;

data _null_;
call symput("start_dt",put(INTNX('day',"&start_day"d,0),YYMMDDN8.));
call symput("end_dt",put(INTNX('day',"&end_day"d,0),YYMMDDN8.));
call symput("start_date",put(INTNX('day',"&start_day"d,0),YYMMDD10.));
call symput("end_date",put(INTNX('day',"&end_day"d,0),YYMMDD10.));
run;

/* relative date */
data _null_;
call symput("pre_day",put(INTNX('day',date(),-1),date9.));
call symput("cur_day",put(INTNX('day',date(),0),date9.));
call symput("pre_dt",put(INTNX('day',date(),-1),YYMMDDN8.));
call symput("cur_dt",put(INTNX('day',date(),0),YYMMDDN8.));
call symput("pre_date",put(INTNX('day',date(),-1),YYMMDD10.));
call symput("cur_date",put(INTNX('day',date(),0),YYMMDD10.));
run;

data _null_;
call symput("cur_month",put(INTNX('month',INTNX('day',date(),0),0),YYMMN6.));
call symput("start_month",put(INTNX('month',INTNX('day',"&start_day"d,0),0),YYMMN6.));
call symput("pre_month",put(INTNX('month',INTNX('day',date(),0),-1),YYMMN6.));
run;

data _null_;
call symput("cur_month_first_day",put(INTNX('month',INTNX('day',date(),0),0,'b'),date9.));
call symput("cur_month_last_day",put(INTNX('month',INTNX('day',date(),0),0,'e'),date9.));
call symput("cur_month_first_dt",put(INTNX('month',INTNX('day',date(),0),0,'b'),YYMMDDN8.));
call symput("cur_month_last_dt",put(INTNX('month',INTNX('day',date(),0),0,'e'),YYMMDDN8.));
call symput("cur_month_first_date",put(INTNX('month',INTNX('day',date(),0),0,'b'),YYMMDD10.));
call symput("cur_month_last_date",put(INTNX('month',INTNX('day',date(),0),0,'e'),YYMMDD10.));

call symput("pre_month_first_day",put(INTNX('month',INTNX('day',date(),0),-1,'b'),date9.));
call symput("pre_month_last_day",put(INTNX('month',INTNX('day',date(),0),-1,'e'),date9.));
call symput("pre_month_first_dt",put(INTNX('month',INTNX('day',date(),0),-1,'b'),YYMMDDN8.));
call symput("pre_month_last_dt",put(INTNX('month',INTNX('day',date(),0),-1,'e'),YYMMDDN8.));
call symput("pre_month_first_date",put(INTNX('month',INTNX('day',date(),-1),0,'b'),YYMMDD10.));
call symput("pre_month_last_date",put(INTNX('month',INTNX('day',date(),-1),0,'e'),YYMMDD10.));
run;

/* bias date */
data _null_;
call symput("cur_date_b7",put(INTNX('day',date(),-7),YYMMDD10.));
run;


