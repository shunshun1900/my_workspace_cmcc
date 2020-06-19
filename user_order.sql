/* main offer  */
share_yy.main_offer_fee_next
#DWD_SVC_OFF_MAIN_INST_YYYYMM

/* main offer next  */
share_yy.main_offer_fee_next_kb

-- zixuan main offer

-- urvas offer 
/* 
Note: zixuan order record from urvas
 */
#DWD_SVC_OFF_URVAS_INS_YYYYMMDD 

-- rvas offer
#DWD_SVC_PROD_RVAS_INS_YYYYMM

proc sql outobs=100;
select * from dw61.DWD_SVC_PROD_RVAS_INS_20200615
where offer_id=
;
quit;

/*  pre pay order
Note: prod_item_type = offer_ploy
  */
#DWD_SVC_OFF_PPAY_INS_YYYYMMDD
proc sql outobs=100;
select * from dw61.DWD_SVC_OFF_PPAY_INS_20200615
where offer_id=
;
quit;

/*
#dwd_svc_off_TEM_BIDINS_&pre_dt

*/
proc sql;
create table user_tmbd_&i as
select distinct a.user_id,state,a.offer_id,prod_id,create_date,eff_date,exp_date,org_id,op_id 
from dw61.dwd_svc_off_TEM_BIDINS_&i a,lhy.xinyong_gouji_id as b 
where a.offer_id=b.offer_id 
;
quit;
