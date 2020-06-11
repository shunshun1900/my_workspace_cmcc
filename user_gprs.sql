/* gprs current month dm */
data gprs;
set dw61.DWA_BEH_GPRS_DT_&stat_day;
keep 
user_id 
gprs_miss_flow 
local_flow sum_flow 
inner_roam_flow 
intl_roam_flow
inner_roam_onnet_days 
local_onnet_days 
lively_days;
run;

/* gprs day */
/*
#DWA_BEH_GPRS_&stat_day
*/

/* gprs day detail with */
/*
#DWD_EVT_GPRS_USR_YYYYMMDD
#DWD_EVT_GPRS_USR_DT_YYYYMMDD
user_id,
imei,
service_code,
vplmn1,
roam_type
*/


/* gprs roam in   */
/*
DWD_EVT_GPRS_RIN_USR_YYYYMM
DWD_EVT_GPRS_RIN_USR_YYYYMMDD
  -- for province roam in 
DWD_EVT_STTL_GPRS_RIN_YYYYMMDD 
DWD_EVT_STTL_GPRS_RIN_YYYYMM
DWD_EVT_GPRS_RIN_DTL_YYYYMMDD
phone_no,
lac,
cellID
*/

/* gprs_miss_flow history data in Hadoop  */
| user_id                  | varchar(20)           |                       |
| sum_flow                 | double                |                       |
| sum_flow_4g              | double                |                       |
| local_flow               | double                |                       |
| local_flow_4g            | double                |                       |
| dou                      | double                |                       |
| dou_4g                   | double                |                       |
| stat_date                | date                  |                       |
|                          | NULL                  | NULL                  |
| # Partition Information  | NULL                  | NULL                  |
| # col_name               | data_type             | comment               |
|                          | NULL                  | NULL                  |
| stat_date                | date                  |                       |