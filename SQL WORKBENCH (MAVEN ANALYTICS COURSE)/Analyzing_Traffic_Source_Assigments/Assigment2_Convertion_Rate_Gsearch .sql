SELECT 
	COUNT(distinct website_sessions.website_session_id) as sessions,
    COUNT(distinct orders.order_id) as orders,
    COUNT(distinct orders.order_id)/COUNT(distinct website_sessions.website_session_id) as Gsearch_Conv_tr
FROM website_sessions
left join orders 
	on orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-04-14'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'