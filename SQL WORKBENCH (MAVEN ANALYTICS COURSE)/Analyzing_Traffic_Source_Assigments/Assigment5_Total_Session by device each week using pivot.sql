/*
CARA 1
Select 
	device_type,
    week(created_at) as weeks,
    min(date(created_at)) as dates,
	count(website_session_id) as sessions
From website_sessions
where created_at between '2012-04-15' and '2012-06-09' 
	and utm_source='gsearch'
    and utm_campaign='nonbrand'
group by 1,week(created_at)
order by 1;*/

-- CARA PIVOT
Select 
    min(date(created_at)) as dates,
    count(case when device_type ='desktop' then website_session_id else NULL end) as desk_sessions,
    count(case when device_type ='mobile' then website_session_id else NULL end) as mob_sessions,
	count(website_session_id) as total_sessions
From website_sessions
where created_at between '2012-04-15' and '2012-06-09' 
	and utm_source='gsearch'
    and utm_campaign='nonbrand'
group by week(created_at);
