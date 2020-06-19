/* using location stay on Hive */
use mqs;
-- sample location table
drop table if exists tmp_location_sub;
create table virus_1 as
select msisdn, dt, sum(duration)/3600.0 as dur from default.location_stay
where dt>='20200201' and dt<='20200229' and
length(msisdn)=11
group  by msisdn, dt;

-- remove wlk
drop table if exists rm_wlk;
create table rm_wlk as
select a.* from tmp_location_sub a left join mqs.wlk_sh_7 b on substr(a.msisdn,1,7)=b.msisdn
where b.msisdn is null;

drop table if exists tmp_location_people_feb;
create table tmp_location_people as
select a.* from tmp_location_sub a left join mqs.wlk_sh_8 b on substr(a.msisdn,1,8)=b.msisdn
where b.msisdn is null;

drop table rm_wlk;

/* using gprs and call on Hive */

drop table tmp_gprs_call;
create table  tmp_gprs_call as
select phone_no, vplmn1, count(dt) as dt_cnt from default.users_gprs_roam
where dt>='20200501' and dt<='20200531' and roam_type in('4') and length (phone_No)=11
group  by phone_no,vplmn1
union
select  phone_no, vplmn1,count(dt) as dt_cnt  from default.users_call_roam
where dt>='20200501' and dt<='20200531' and roam_type in('4') and length (phone_No)=11
group  by phone_no,vplmn1;

drop table tmp_gprs_call_rank;
create table  tmp_gprs_call_rank as
select phone_no, vplmn1, dt_cnt,row_number() over(partition by phone_no order by dt_cnt desc) as rnt
from (select phone_no, vplmn1, sum(dt_cnt) as dt_cnt from tmp_gprs_call group by phone_no, vplmn1) as a;

create table  tmp_gprs_call_rank_1 as
select * from tmp_gprs_call_rank where rnt = 1;

grant all on table tmp_gprs_call_rank_1 to user sas_B;

