序号	模型	表名
1	5g畅玩包促活	dwv_m_5g_user_flag_pn
2	5g流量包	dwv_5g_user_flag_pn
3	5g套餐	dwv_m_5g_user_flag_plan_pn
4	5g终端	dwv_m_cust_5g_user_flag_term_pn 
5	大屏内容	dwv_m_cust_screen_recomm_pn
6	和彩云偏好	dwv_m_cust_hecloud_prefer_pn
7	家宽离网预警	dwv_m_cust_brd_exit_warn_pn
8	家宽潜客识别	dwv_m_cust_brd_latent_discern_simple_pn
9	视频彩铃偏好	dwv_m_cust_vedio_ring_prefer_pn
10	套餐升档	dwv_m_cust_plan_high_lvl_info_pn
11	离网预警	dwv_m_cust_user_base_info_pn
12	携号转网	dwi_m_evnt_trans_net_info_10000_pn
13	易携入用户	dwi_m_evnt_trans_net_info_10000

desc zh1_hw_qwsjuser.dwv_m_5g_user_flag_pn;
desc zh1_hw_qwsjuser.dwv_5g_user_flag_pn;
desc zh1_hw_qwsjuser.dwv_m_5g_user_flag_plan_pn;
desc zh1_hw_qwsjuser.dwv_m_cust_5g_user_flag_term_pn;
desc zh1_hw_qwsjuser.dwv_m_cust_vedio_ring_prefer_pn;
desc zh1_hw_qwsjuser.dwv_m_cust_plan_high_lvl_info_pn;

desc zh1_hw_qwsjuser.dwv_m_5g_user_flag_plan_pn;
desc zh1_hw_qwsjuser.dwv_m_cust_5g_user_flag_term_pn;
desc zh1_hw_qwsjuser.86069_dwv_m_cust_vedio_ring_prefer_pn;
desc zh1_hw_qwsjuser.86075_dwv_m_cust_plan_high_lvl_info_pn;

select * from zh1_hw_qwsjuser.dwv_m_5g_user_flag_plan_pn limit 10;
select * from zh1_hw_qwsjuser.86069_dwv_m_cust_vedio_ring_prefer_pn limit 10;

select user_id,msisdn from zh1_hw_qwsjuser.mc_86074_sh_dwv_m_cust_5g_user_m limit 10;


/* ----------5G套餐------------ */
zh1_hw_qwsjuser.dwv_m_5g_user_flag_plan_pn
zh1_hw_qwsjuser.mc_86074_sh_dwv_m_cust_5g_user_m

/*测试集记录数*/
select count(*),count(distinct phon_num) from zh1_hw_qwsjuser.dwv_m_5g_user_flag_plan_pn
where prvd_id='10200';

| 23866652  | 769892  |

/* 匹配用户宽表 */
select count(distinct b.user_id) from 
(select distinct phon_num from zh1_hw_qwsjuser.dwv_m_5g_user_flag_plan_pn
where prvd_id='10200') as A
inner join
(select user_id,msisdn from zh1_hw_qwsjuser.mc_86074_sh_dwv_m_cust_5g_user_m 
where statis_date='202007') as B on a.phon_num=b.msisdn
;
| 763671  |
select count(distinct b.user_id) from 
(select distinct phon_num from zh1_hw_qwsjuser.dwv_m_5g_user_flag_plan_pn
where prvd_id='10200') as A
inner join
(select user_id,msisdn from zh1_hw_qwsjuser.mc_86075_sh_dwv_m_cust_plan_high_lvl_info_m 
where statis_date='202006') as B on a.phon_num=b.msisdn
;
| 755137  |
