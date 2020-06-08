/*  sas macro   */
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

/* loop */
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

%kb;