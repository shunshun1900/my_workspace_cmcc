%let WeekDate  = %sysfunc(date(),weekdate29.) ;
%let DateCCYY  = %sysfunc(date(),year4.)      ;
%let DateMonth = %sysfunc(date(),MonName9.)   ;   %*September:9;
%let Date_MM   = %sysfunc(date(),Month2.)     ;   %*01:12;
%let Date_DD   = %sysfunc(date(),Day2.)       ;   %*01:31;
%let Date_Day  = %sysfunc(date(),downame9.)   ;   %*Wednesday:9;
%let DateJul   = %sysfunc(date(),julian7.)    ;   %*ccYYddd;
%let DateJulDay= %sysfunc(date(),julday3.)    ;   %*ddd;
%let Date_Qtr  = %sysfunc(date(),qtr1.)       ;   %*1:4;
%let Time      = %sysfunc(time(),time8.0)     ;   %*HH:MM:SS;
%let Time_HH   = %scan(&Time.,1,:)            ;
%let Time_MM   = %scan(&Time.,2,:)            ;
%let Time_SS   = %scan(&Time.,3,:)            ;
%let TimeAMPM  = %sysfunc(time(),timeAmPm8.0) ;   %*HH:MM AM;
 
%put Weekdate  = &WeekDate  ;
%put DateCCYY  = &Dateccyy  ;
%put DateMonth = &DateMonth ;
%put Date_MM   = &Date_mm   ;
%put Date_DD   = &Date_dd   ;
%put Date_Day  = &Date_Day  ;
%put DateJul   = &DateJul   ;
%put DateJulDay= &DateJulDay;
%put Date_Qtr  = &Date_Qtr  ;
%put Time      = &Time      ;
%put Time_HH   = &Time_hh   ;
%put Time_MM   = &Time_mm   ;
%put Time_SS   = &Time_ss   ;
%put TimeAMPM  = &TimeAmpm  ;

%Let StDate = &SysDate.;
%*Let StDate = %sysfunc(date(),yymmddn8.);
%Put StDate: &StDate.:
 
%let DatePart  = %sysfunc(datepart(%substr(&SysProcessId.,1,16)x));
%let Year      = %sysfunc(year(&Datepart.));
%let Month     = %sysfunc(putn(&Datepart.,  month2.));
%let Month     = %sysfunc(putn(&Month.   ,      z2.));
%let MonthName = %sysfunc(putn(&Datepart.,monname3.));
%let Day       = %sysfunc(putn(&Datepart.,     day.));
%let Day       = %sysfunc(putn(&Day.     ,      z2.));