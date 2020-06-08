-- user behavior statistics

-- gprs day


-- gprs monthly dm [gprs]
data gprs;
set dw61.DWA_BEH_GPRS_DT_&stat_day;
keep user_id gprs_miss_flow local_flow sum_flow inner_roam_flow inner_roam_onnet_days local_onnet_days lively_days;
run;

-- gprs with vplmn and service_code

-- gprs roam in , with vplmn

-- call day

-- call monthly dm [call]
data call;
set dw61.DWA_USR_BEH_CALL_DM_&stat_day;
keep user_id bill_dur call_num local_bill_dur inner_roam_bill_dur lively_days;
run;

-- sms day

-- sms monthly dm