proc contents data=share_yy.APPNAME_202008;
run;

proc sql ;
select * from share_yy.APPNAME_202008
where imsi='';
quit;

