/*  sas macro scripts for left join, iteration etc...     */

/* loop */
%macro loop;
%do i=1 %to &span;

data _null_;
call symput("iter_day",put(intnx('day',"&start_day"d,&i),yymmddn8.));
run;

 %if &i = 1 %THEN %DO;

 proc sql ;
create table net_user as
select distinct user_id, "&iter_day" as dt from net_user_tmp where dt <= "&iter_day";
quit ;

 %end;
 %else %if &i ^= 1 %then %DO;

proc sql ;
INSERT into net_user
select distinct user_id, "&iter_day" as dt from net_user_tmp where dt <= "&iter_day";
quit ;

 %end;

%end;
%mend loop;

/* left join*/
/*
call: 
    %leftjoin()

*/
