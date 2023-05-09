Select 
	ws.device_type,
	count(ws.website_session_id) as sessions,
    count(o.order_id) orders,
    count(o.order_id)*100/count(ws.website_session_id) as conv_rt_percentages
FROM website_sessions ws
left join orders o
	on o.website_session_id = ws.website_session_id
where ws.created_at < '2012-05-11'
	and utm_source ='gsearch'
    and utm_campaign = 'nonbrand'
group by 1;