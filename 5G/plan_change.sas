/*   turn to low     */
data jd;
set share_yy.plan_fee_change_day_202006;
if  flag="c_降档" and is_dykz_&pre_month.=1;
run;

proc sql ;
create table jd as
select a.*,
case when b.offer_id is null then 0 else 1 end as plan_flag_202006
from jd a
left join fengtao.dim_5g_plan b on a.plan_offer_id_202006 = b.offer_id
;
quit;

proc sql ;
create table jd as
select a.*,
case when b.offer_id is null then 0 else 1 end as plan_flag_next
from jd a
left join fengtao.dim_5g_plan b on a.plan_offer_id_next = b.offer_id
;
quit;

data jd;
set jd;
if plan_flag_202006=0 and plan_flag_next=0 then change_type=0;
if plan_flag_202006=0 and plan_flag_next=1 then change_type=1;
if plan_flag_202006=1 and plan_flag_next=0 then change_type=2;
if plan_flag_202006=1 and plan_flag_next=1 then change_type=3;
run;

proc freq DATA = jd order=freq;
    table change_type ;
RUN;

proc freq DATA = jd(WHERE=(change_type=0)) order=freq;
    table plan_name_202006 plan_name_next ;
RUN;

proc freq DATA = jd(WHERE=(change_type=1)) order=freq;
    table plan_name_202006 plan_name_next ;
RUN;

proc freq DATA = jd(WHERE=(change_type=2)) order=freq;
    table plan_name_202006 plan_name_next ;
RUN;

proc freq DATA = jd(WHERE=(change_type=3)) order=freq;
    table plan_name_202006 plan_name_next ;
RUN;


