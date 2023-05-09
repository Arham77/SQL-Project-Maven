USE mavenfuzzyfactory;

SELECT 
	year(created_at) as years,
	week(created_at) as weeks,
    min(date(created_at)) as date,
    Count(distinct website_session_id) as Sessions
FROM website_sessions
where created_at < '2012-05-10'
	and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by 1,2
;