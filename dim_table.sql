-- dummy code 
  --order offer_id state_type
    -- 00 -> 0
	-- 01 -> 1
	-- 10 -> 2
	-- 11 -> 3

  -- 5G plan user type : plan_type
    -- 000 -> 0 
	-- 001 -> 1
	-- 010 -> 2

  -- 5G offer_id type : offer_type
    -- 1 -> main_offer
	-- 2 -> diejia_offer
	-- 3 -> quanyi_offer

-- msc ID
data hdpyp02.dim_msc_id;
set dim_msc_id;
run;

-- area name
proc sql;
create table xz_out2 as
select a.*,
b.area_name
from xz_out1 a
left join dw61.ST_MKT_YWWG_SDH_20191121 b on a.user_id=b.user_id;
quit;

-- area_name name using org_id
proc sql;
create table xz_in1 as
select a.*,
case when b.area_name='南汇' then '浦东' 
	    when b.area_name='东区' then '浦东' 
else area_name end as area_name
from xz_in a
left join shiyang.DIM_PRTY_ORG_INFO b on a.org_id=b.org_id;
quit;


-- area_name sum statistics
proc sql;
create table tmp as
select a.*,b.dept_name,b.log_vs from 
shiyang.dim_xz_area A left join(
select dept_name, count(distinct user_id) as log_vs from vs group by dept_name) B
on a.area_name=b.dept_name
order by a.area_id;
quit; 

