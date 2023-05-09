Select 
	min(date(created_at)) as year_week,
    count(website_session_id) as total_session,
    count(case when utm_source = 'bsearch' then website_session_id else null end) as b_session,
    count(case when utm_source = 'gsearch' then website_session_id else null end) as g_session
from website_sessions
Where created_at between '2012-08-22' and '2012-11-30'
	and device_type = 'mobile'
group by yearweek(created_at);

Select distinct utm_source,
	count(website_session_id) as sessions,
    count(case when device_type = 'mobile' then website_session_id else null end) m_sessions,
    count(case when device_type = 'mobile' then website_session_id else null end) / count(website_session_id) as cvr
from website_sessions
Where created_at between '2012-08-22' and '2012-11-30'
	and utm_source is not null
    and utm_campaign = 'nonbrand'
group by 1;