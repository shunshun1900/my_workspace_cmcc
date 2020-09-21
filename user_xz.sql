/*  high risk chrone user  */
select * from #st_mkt_grp_carry_out_202007 where RISK_LVL <>'低风险用户' 

select distinct a.*, b.cust_name, c.GRP_AREA_NAME, d.GRP_DIST_NAME ,
case when c.grp_area_name='集团客户部' and d.grp_dist_name^='合作管理部' then d.grp_dist_name
when c.grp_area_name in ('','代理','集客行业','集客重要','其他') or (c.grp_area_name='集团客户部' and d.grp_dist_name='合作管理部') 
then '集团客户部-其他' else c.grp_area_name end as grp_area_name2  from
(
select  user_id, group_id, open_date from #ST_MKT_XZ_USER_XC_20200911 where group_id is not null and open_date>='2020-09-01' and open_date<='2020-09-11'
) a
left join #DWD_PRTY_GRP_INFO_20200911 b on a.group_id=b.group_id
left join #DIM_GRP_REGION_DTL c on b.M_GRP_AREA_ID=c.GRP_AREA_ID and c.end_date>'2020-09-11'
left join #DIM_GRP_REGION_DTL d on b.M_GRP_DIST_ID=d.GRP_DIST_ID and d.end_date>'2020-09-11'