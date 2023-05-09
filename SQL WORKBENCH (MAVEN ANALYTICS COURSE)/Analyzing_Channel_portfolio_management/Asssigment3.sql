Select w.device_type,
	w.utm_source,
    count(w.website_session_id) as sessions,
    count(o.order_id) as orders,
    count(o.order_id)/count(w.website_session_id) as cvr
from website_sessions w
left join orders o on w.website_session_id = o.website_session_id
where w.created_at between '2012-08-22' and '2012-09-18'
	and utm_campaign = 'nonbrand'
group by 1,2
order by 1;
