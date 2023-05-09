Select utm_content,
	count(website_sessions.website_session_id) as sessions,
    count(orders.order_id) as orders,
    count(orders.order_id)/count(website_sessions.website_session_id) as cv_rt
from website_sessions
	left join orders 
		on orders.website_session_id = website_sessions.website_session_id
group by 1
order by 2;