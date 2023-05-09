use mavenfuzzyfactory;

Select * from website_sessions;

Select
	min(date(created_at)) as weekly,
	count(case when utm_source = 'gsearch' and device_type = 'desktop' then website_session_id else null end) as g_dtop_sessions,
    count(case when utm_source = 'bsearch' and device_type = 'desktop' then website_session_id else null end) as b_dtop_sessions,
	count(case when utm_source = 'bsearch' and device_type = 'desktop' then website_session_id else null end) /
		count(case when utm_source = 'gsearch' and device_type = 'desktop' then website_session_id else null end) as b_ptc_of_g_dtop,
	count(case when utm_source = 'gsearch' and device_type = 'mobile' then website_session_id else null end) as g_mob_sessions,
	count(case when utm_source = 'bsearch' and device_type = 'mobile' then website_session_id else null end) as b_mob_sessions,
    count(case when utm_source = 'bsearch' and device_type = 'mobile' then website_session_id else null end) / 
		count(case when utm_source = 'gsearch' and device_type = 'mobile' then website_session_id else null end) as b_ptc_of_mob
from website_sessions
where created_at between '2012-11-04' and '2012-12-22'
	and utm_campaign = 'nonbrand'
group by yearweek(created_at);