/* group user */
proc sql;
create table grp_jituan_&cur_day. as
select distinct a.*, b.cust_name, c.GRP_AREA_NAME, d.GRP_DIST_NAME，
 case when c.grp_area_name='集团客户部' and d.grp_dist_name^='合作管理部' then d.grp_dist_name
         when c.grp_area_name in ('','代理','集客行业','集客重要','其他') 
     or (c.grp_area_name='集团客户部' and d.grp_dist_name='合作管理部') then '集团客户部-其他'
      else c.grp_area_name end as grp_area_name2
from
(
select distinct cust_id as group_id, sub_id as user_id, cust_service_level
from dw61.BASS1_GROUP_MEM_&cur_day. where flag='1'
) a
left join dw61.DWD_PRTY_GRP_INFO_&cur_day. b on a.group_id=b.group_id
left join dw61.DIM_GRP_REGION_DTL c on b.M_GRP_AREA_ID=c.GRP_AREA_ID and c.end_date>&date.
left join dw61.DIM_GRP_REGION_DTL d on b.M_GRP_DIST_ID=d.GRP_DIST_ID and d.end_date>&date.;
quit;

 /* complaint user*/

PROC SQL;
create table tousu_detail_info as 
SELECT a.PHONE_NO, a.COMPLAIN_CLASS, 
              coalesce(c.LVL5DESC,c.LVL4DESC) as COMPLAIN_DESC
from DW61.DWD_EVT_WMS_WF_INS_HIS_DM_2020 as a
left join DW61.DIM_EVT_WMS_COMPLAIN_TYPE as c
on a.COMPLAIN_TYPE=c.COMPLAIN_TYPE
where a.op_date>=&bom. and a.op_date<=&eom. and c.start_date<&eom. and c.end_date>=&eom.
;
QUIT;

proc sql;
create table wms as
select a.phone_No,a.complain_type, b.complain_desc, b.lvl3desc
from dw61.dwd_evt_wms_wf_ins_his_dm_2019 a
left join dw61.dim_evt_wms_complain_type b
on a.complain_type=b.complain_type
where a.op_date='30nov2019'd and b.lvl3desc="" and b.complain_desc not like "%%";
quit;

proc sql outobs=100;
select * from shiyang.dim_evt_wms_complain_type
where 
lvl3desc like "%5G%"
or complain_desc like "%5G%"
;
quit;