ods html close;
data exprev;
input Country $ 1-24 Emp_ID $ 25-32 Order_Date $  Ship_Date $  Sale_Type $ & Quantity Price Cost;

datalines;
Antarctica              99999999     1/1/08      1/7/08            Internet    2     92.60      20.70 
Puerto Rico             99999999     1/1/08      1/5/08            Catalog     14    51.20      12.10 
Virgin Islands (U.S.)   99999999     1/1/08      1/4/08            In Store    25    31.10      15.65 
Aruba                   99999999     1/1/08      1/4/08            Catalog     30    123.70     59.00 
Bahamas                 99999999     1/1/08      1/4/08            Catalog     8     113.40     28.45 
Bermuda                 99999999     1/1/08      1/4/08            Catalog     7     41.00      9.25 
Belize                  120458       1/2/08      1/2/08            In Store    2     146.40     36.70 
British Virgin Islands  99999999     1/2/08      1/5/08            Catalog     11    40.20      20.20 
Canada                  99999999     1/2/08      1/5/08            Catalog     100   11.80      5.00 
Cayman Islands          120454       1/2/08      1/2/08            In Store    20    71.00      32.30 
Costa Rica              99999999     1/2/08      1/6/08            Internet    31    53.00      26.60 
Cuba                    121044       1/2/08      1/2/08            Internet    12    42.40      19.35 
Dominican Republic      121040       1/2/08      1/2/08            Internet    13    48.00      23.95 
El Salvador             99999999     1/2/08      1/6/08            Catalog     21    266.40     66.70 
Guatemala               120931       1/2/08      1/2/08            In Store    13    144.40     65.70 
Haiti                   121059       1/2/08      1/2/08            Internet    5     47.90      23.45 
Honduras                120455       1/2/08      1/2/08            Internet    20    66.40      30.25 
Jamaica                 99999999     1/2/08      1/4/08            In Store    23    169.80     38.70 
Mexico                  120127       1/2/08      1/2/08            In Store    30    211.80     33.65 
Montserrat              120127       1/2/08      1/2/08            In Store    19    184.20     36.90 
Nicaragua               120932       1/2/08      1/2/08            Internet    16    122.00     28.75 
Panama                  99999999     1/2/08      1/6/08            Internet    20    88.20      38.40 
Saint Kitts/Nevis       99999999     1/2/08      1/6/08            Internet    20    41.40      18.00 
St. Helena              120360       1/2/08      1/2/08            Internet    19    94.70      47.45 
St. Pierre/Miquelon     120842       1/2/08      1/16/08           Internet    16    103.80     47.25 
Turks/Caicos Islands    120372       1/2/08      1/2/08            Internet    10    57.70      28.95 
United States           120372       1/2/08      1/2/08            Internet    20    88.20      38.40 
Anguilla                99999999     1/2/08      1/6/08            In Store    15    233.50     22.25 
Antigua/Barbuda         120458       1/2/08      1/2/08            In Store    31    99.60      45.35 
Argentina               99999999     1/2/08      1/6/08            In Store    42    408.80     87.15 
Barbados                99999999     1/2/08      1/6/08            In Store    26    94.80      42.60 
Bolivia                 120127       1/2/08      1/2/08            In Store    26    66.00      16.60 
Brazil                  120127       1/2/08      1/2/08            Catalog     12    73.40      18.45 
Chile                   120447       1/2/08      1/2/08            In Store    20    19.10      8.75 
Colombia                121059       1/2/08      1/2/08            Internet    28    361.40     90.45 
Dominica                121043       1/2/08      1/2/08            Internet    35    121.30     57.80 
Ecuador                 121042       1/2/08      1/2/08            In Store    11    100.90     50.55 
Falkland Islands        120932       1/2/08      1/2/08            In Store    15    61.40      30.80 
French Guiana           120935       1/2/08      1/2/08            Catalog     15    96.40      43.85 
Grenada                 120931       1/2/08      1/2/08            Catalog     19    56.30      25.05 
Guadeloupe              120445       1/2/08      1/2/08            Internet    21    231.60     48.70 
Guyana                  120455       1/2/08      1/2/08            In Store    25    132.80     30.25 
Martinique              120841       1/2/08      1/3/08            In Store    16    56.30      31.05 
Netherlands Antilles    99999999     1/2/08      1/6/08            In Store    31    41.80      19.45 
Paraguay                120603       1/2/08      1/2/08            Catalog     17    117.60     58.90 
Peru                    120845       1/2/08      1/2/08            Catalog     12    93.80      41.75 
St. Lucia               120845       1/2/08      1/2/08            Internet    19    64.30      28.65 
Suriname                120538       1/3/08      1/3/08            Internet    22    110.80     29.35 
;
run;