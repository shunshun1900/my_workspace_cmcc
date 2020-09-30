*syntax;
https://support.sas.com/documentation/cdl/en/proc/61895/HTML/default/viewer.htm#a002291718.htm

PROC PRINT <option(s)>;
BY <DESCENDING> variable-1 <...<DESCENDING> variable-n><NOTSORTED>;
PAGEBY BY-variable;
SUMBY BY-variable;
ID variable(s) <option>;
SUM variable(s) <option>;
VAR variable(s) <option>;
	
options nodate pageno=1 linesize=80 pagesize=30 obs=10;

proc print data=exprev double;
 Note about code	
   var country price sale_type;
   title 'Monthly Price Per Unit and Sale Type for Each Country';
   footnote '*prices in USD'; 
run;

*create default pdf file;
options nodate pageno=1 linesize=80 pagesize=40 obs=10;
 Note about code	
ods pdf file='your_file.pdf';
proc print data=exprev split='*' n obs='Observation*Number*===========';
   var country sale_type price;
   label country='Country Name**============'
         sale_type='Order Type**=========='
         price='Price Per Unit in USD**==============';
   
   format price dollar10.2;
   title 'Order Type and Price Per Unit in Each Country';
run;
 Note about code	
ods pdf close;
