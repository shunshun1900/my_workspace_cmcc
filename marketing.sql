/*  user list of MARKETING contacted by SMS*/
#DWA_TI_O_SMS_ALL_DM_202010

proc sql;
create table sent as
select distinct phone_no from dw61.DWA_TI_O_SMS_ALL_DM_202009
where ct_ext_id='2080848'
;
quit;