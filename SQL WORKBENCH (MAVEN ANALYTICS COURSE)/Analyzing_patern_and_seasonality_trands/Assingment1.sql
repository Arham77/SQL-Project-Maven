Select 
	year(website_sessions.created_at) as yr,
	month(website_sessions.created_at) as mo,
    count(website_sessions.website_session_id) as sessions,
    count(distinct order_id) as orders
from website_sessions
left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '2013-01-02'
group by 1,2
;

Select 
	min(date(website_sessions.created_at)) as date,
    count(website_sessions.website_session_id) as sessions,
    count(distinct order_id) as orders
from website_sessions
left join orders on website_sessions.website_session_id = orders.website_session_id
group by yearweek(website_sessions.created_at);