-- sas date

-- date input format
20jan2019 date9.
20190120  yymmddn8.
201901    yymmn6.
2019jan   yymon7.
2019-01-20 yymmdd10.

-- datetime input format
01JAN1960:00:02:30  datetime20.
08:02:30            time8.
08:02:30            tod8.

-- date and datetime used in Editor
date='20jan2019'd
datetime='01JAN1960:00:01:30'dt

-- transform
--tips: 'input' transfer the string with informat into date, date=input(string,informat);
--while: 'put' transfer the num into string with defined format, str=put(123,$3.);

string -> date
  '20200120' -> 20jan2020 date9.
  date=input('20200120',yymmdd8.);
  format date date9.;

date -> string
  20jan2020 date9. -> '20200120'
  str=put('20jan2020'd,yymmddn8.)

num -> date
  20200102 -> '20200120' -> date9.
  date=input(put(20200102,$8.),yymmddn8.)

date -> num
  20jan2020 date9. -> '20200120' -> 20200120
  num=input(put('20jan2020'd,yymmddn8.),8.)

string -> num
  input('123',3.)

num -> string
  put(123,$3.)

-- date function

INTCK(interval <multiple> <.shift-index>, start-date, end-date, <'method'>)
For the CONTINUOUS method, the distance in months between January 15, 2000, and February 15, 2000, is one month.
For the DISCRETE method, the distance in months between January 31, 2013, and February 1, 2013, is one month.
interval in {year month day hour second dtday dtmonth} method in {'C','D'}
intck('month',pre_date,after_date);

  example1:
  data _null;
   from = input('01jan2013:12:34:56',datetime19.);
   to = input('15mar2013:00:00:00',datetime19.);
   call symputx('from',from);
   call symputx('to',to);
  run;

  data _null_;
   x = intck('dtmonth',&from,&to);
   put x=;
  run;

  results: x=2

-- date function
INTNX(interval <multiple><.shift-index>, start-from, increment <, 'alignment'>)
intnx('month', '15mar2000'd, 5, 'same');  returns 15AUG2000
intnx('year', '29feb2000'd, 2, 'same');   returns 28FEB2002
intnx('month', '31aug2001'd, 1, 'same');  returns 30SEP2001
intnx('year', '01mar1999'd, 1, 'same');   returns 01MAR2000 (the first day of the
                                                            3rd month of the year)

-- data function datepart
date=datepart(datetime19.)
time=timepart(datetime19.)
year=year(date)
month=month(date)

-- datetime()
option timezone='America/Los_Angeles';
data _null_;
   dt1=datetime();
   put dt1=nldatm.;
run;

results:
dt1=07Nov2012:11:22:30

-- today()
option timezone='Asia/Seoul';
data _null_;
   d2=today();
   put d2=nldate.;
run;

results:
d2=November 08, 2012
   2012年09月08日