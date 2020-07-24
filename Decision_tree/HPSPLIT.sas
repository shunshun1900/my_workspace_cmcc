data test;
input x y;
datalines;
1 1
2 1
3 1
4 0
5 0
6 0
7 0
8 1
run;

ods graphics on;

proc hpsplit data=test seed=123;
   class y;
   model y (event='1') =
         x;
   grow entropy;
   prune costcomplexity;
run;