USE mavenfuzzyfactory;

Select utm_source,
	utm_campaign,
    http_referer,
    count(website_session_id) as sessions
from website_sessions
where created_at < '2012-04-12'
group by 1,2,3
order by sessions;
