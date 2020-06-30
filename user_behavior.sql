-- user behavior statistics

/*  auth log at store through scanning ID card  */

#ODS_SEC_IND_AUTH_LOG_20200607
#DWD_EVT_SECIND_AUTLOG_YYYYMMDD

/*
Note: from 21AUG2015, ext1 is not null
*/
 

 /*  user complaint  */

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
where a.op_date='30nov2019'd and b.lvl3desc="携号转网" and b.complain_desc not like "%携入%";
quit;

proc sql outobs=100;
select * from shiyang.dim_evt_wms_complain_type
where 
lvl3desc like "%5G%"
or complain_desc like "%5G%"
;
quit;

/*  user click the url */
select distinct WT_MOBILE 
from #ODS_UMI_SH_H5_ALL_channel_day_20200629
Where WT_MC_ID = 'YX200616_DXQF_5GZQ_02' and WT_MOBILE != '\N'

select distinct WT_MOBILE 
from #ODS_UMI_SH_H5_ALL_channel_day_20200629
Where WT_MC_ID = '2YB7VVj' and WT_MOBILE != '\N'