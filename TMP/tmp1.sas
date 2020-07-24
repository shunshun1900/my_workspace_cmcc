/**********计算每个小区周围最近的本属地渠道**********/
/*  wgs 经纬度   */
data yyt_station;
set shiyang.qudao_info;
lng_yyt=lon;
lat_yyt=lat;
yyt_name=store_name;
run;

data xiaoqu_near_yyt;
length yyt_near $38.;
length yyt_id $8. ;
set xiaoqu_list_&xiaoqu_day(rename=(dept_name=dept_xiaoqu));
pi=constant('pi');
dist_min=1000000;
yyt_near='无对应渠道';
yyt_id='00000000';
do i=1 to total_obs;
   set yyt_station(rename=(dept_name=dept_yyt)) nobs=total_obs point=i;
   if dept_xiaoqu = dept_yyt then do;
      C_ab=sin(90-cent_lat)*sin(90-lat_yyt)*cos(cent_lng-lng_yyt)+cos(90-cent_lat)*cos(90-lat_yyt);
	  if C_ab>=1 then C_ab=1;
	  if C_ab<=-1 then C_ab=-1;
      dist_ab=arcos(C_ab)*6371004*pi/180;
      if dist_ab <= dist_min then do;
         dist_min=dist_ab;
		   yyt_near=yyt_name;
         yyt_id=store_id;

	  end;
   end;
end;
keep COMMUNITY_ID yyt_id yyt_near dist_min ;
run;


/*  */

/**********数据合并**********/

proc sql;
  create table xiaoqu_user as
	select a.COMMUNITY_ID, c.lacci_h, c.msisdn as phone_no, a.distance, b.yyt_id,b.yyt_near,b.dist_min
	from join_table_d a
    inner join xiaoqu_near_yyt b
	on a.COMMUNITY_ID=b.COMMUNITY_ID
	inner join (
      select b.* from share_yy.work_home_&wh_month. b
	  inner join share_yy.kb_&wh_month. c 
      on b.msisdn=c.phone_no 
      where c.lvl1_plan_id in (11010,11020,11030)
     ) c
	on a.lng_h=c.lng_h_wgs and a.lat_h=c.lat_h_wgs;
quit;