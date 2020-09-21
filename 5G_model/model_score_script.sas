DATA goodapps;
   SET &EM_IMPORT_SCORE
	curobs = N;
	obsnum = _N_;
   IF P_is_change1 <= 0.5 
     THEN delete;
   run;

DATA shiyang.goodapps;
set goodapps;
run;

PROC SORT data=goodapps ; 
   BY descending P_is_change1 ;
   run;

PROC PRINT data=goodapps(obs=100) noobs
   split='*' ;
   VAR  obsnum P_is_change1;
   LABEL P_is_change1='Predicted*Good_Bad=Good*=============';
   TITLE "Credit Worthy Applicants";
run;
