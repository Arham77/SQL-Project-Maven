select 
	min(date(created_at)) as start_week,  
    count(case when utm_source = 'gsearch' then website_session_id else null end) as gsearch_session,
	count(case when utm_source = 'bsearch' then website_session_id else null end) as bsearch_session
from website_sessions
where created_at between '2012-08-22' and '2012-11-29'
	and utm_campaign = 'nonbrand'
group by yearweek(created_at)
order by 1; 
