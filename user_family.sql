proc sql outobs=10;
create table r as
select * from dw61.st_mkt_bc_key_person_202003;
quit;

proc sql ;
create table sc_yw as 
select user_id,phone_no ,group_no,small_circle_bs,area_name,GROUP_NUM_YIWANG from dw61.st_mkt_bc_key_person_202003 where 
GROUP_NUM_YIWANG >0;
quit;