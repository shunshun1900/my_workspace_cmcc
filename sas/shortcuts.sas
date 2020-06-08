/* left join */

%MACRO leftjoin(out=t1, TABLE_A=, TABLE_B=, key_a=user_id, key_b=user_id );
proc sql;
create TABLE t1 as 
select
a.*,
b.plan_fee
from &TABLE_A A 
left join &TABLE_B B
on a.&key_a = b.&key_b;
quit;

%MEND leftjoin;

%leftjoin(
out=t1,
table_a=shiyang.dim_5g_plan,
table_b=fengtao.dim_5g_plan,
key_a=offer_id, 
key_b=offer_id);
run;
