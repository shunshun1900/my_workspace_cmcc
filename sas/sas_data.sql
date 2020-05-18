-- sas data step

-- create newid

Proc sort data=test;
By id;
Run;

Data test2;
Set test;
By id;
Retain newid 0;
If first.id then newid=newid+1;
Run;