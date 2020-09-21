-- proc summary
-- identify the observations with the maximum and the minimum values

proc summary data=change_month4;
class phone_no;
var month;
output out=change_month5
        min=month
        MINID(month(id))=min_id;
run;

-- ways and TYPES
-- _ways_   how many classification variables are used
-- _level_   based on _type_, the increased id of each group of _type_

proc summary data=change_month4;
class phone_no;
var month;
*ways 0 2;
*types phone_no age*online_id;
output out=change_month5
        mean=month_mean
        /ways level;
run;

/* create index */
proc sql;
create index user_id	on
shiyang.user_base(user_id);
quit;