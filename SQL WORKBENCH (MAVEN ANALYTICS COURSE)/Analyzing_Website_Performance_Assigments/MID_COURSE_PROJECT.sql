use mavenfuzzyfactory;

-- 1. Mounthly trands in order for gsearch source ( in 2012 for example )
Select 
	year(website_sessions.created_at) as years,
    month(website_sessions.created_at) as mon,
    count(website_sessions.website_session_id) as sessions,
	count(orders.order_id) as total_orders,
    count(orders.order_id)/count(website_sessions.website_session_id) as conv_rate
from website_sessions
	left join orders 
		on website_sessions.website_session_id = orders.website_session_id
where year(website_sessions.created_at) = 2012
	and website_sessions.utm_source = 'gsearch'
group by 1,2
;

-- 2. Mounthly trands in order for gsearch source ( in 2012 for example ) but we needto seperatly nonbrand and brand product

Select 
	year(website_sessions.created_at) as years,
    month(website_sessions.created_at) as mon,
    count(case when website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) as nonbrand_session,
    count(case when website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) as nonbrand_order,
    count(case when website_sessions.utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) as brand_session,
    count(case when website_sessions.utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) as brand_orders
            from website_sessions
	left join orders 
		on website_sessions.website_session_id = orders.website_session_id
where year(website_sessions.created_at) = 2012
	and website_sessions.utm_source = 'gsearch'
group by 1,2
;

-- 3. monthly session and orders, nonbrand item and diffrent device type
Select 
	year(website_sessions.created_at) as years,
    month(website_sessions.created_at) as mon,
    website_sessions.device_type,
    count(case when website_sessions.utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) as total_sessions,
    count(case when website_sessions.utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) as total_orders
            from website_sessions
	left join orders 
		on website_sessions.website_session_id = orders.website_session_id
where year(website_sessions.created_at) = 2012
	and website_sessions.utm_source = 'gsearch'
    and website_sessions.utm_campaign = 'nonbrand'
group by 1,2,3
order by 2,3
;

-- atau bisa dengan

Select 
	year(website_sessions.created_at) as years,
    month(website_sessions.created_at) as mon,
    count(case when website_sessions.device_type = 'desktop' THEN website_sessions.website_session_id ELSE NULL END) as desktop_session,
    count(case when website_sessions.device_type = 'desktop' THEN orders.order_id ELSE NULL END) as desktop_order,
    count(case when website_sessions.device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) as mobile_session,
    count(case when website_sessions.device_type = 'mobile' THEN orders.order_id ELSE NULL END) as mobile_orders
            from website_sessions
	left join orders 
		on website_sessions.website_session_id = orders.website_session_id
where year(website_sessions.created_at) = 2012
	and website_sessions.utm_source = 'gsearch'
    and website_sessions.utm_campaign = 'nonbrand'
group by 1,2
;

-- 4. skip



-- 5. convertion_rate for the first 8 month

Select year(website_sessions.created_at) yr,
	month(website_sessions.created_at) mon,
    count(website_sessions.website_session_id) total_sessions,
    count(orders.order_id) as total_orders,
    count(orders.order_id)/count(website_sessions.website_session_id) as conv_rate
from website_sessions
	left join orders
		on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '2012-09-01'
	and year(website_sessions.created_at) = 2012
group by 1,2
;

-- 6. 
-- pertama cari mulai kapan dan id keberapa lender-1 di mulai
Select min(website_pageview_id) first_test_pv from website_pageviews where pageview_url = '/lander-1';
	
create temporary table first_test_pageviews
Select
	website_pageviews.website_session_id,
    min(website_pageviews.website_pageview_id) as min_pageview_id
from website_pageviews
	inner join website_sessions
		on website_pageviews.website_session_id = website_sessions.website_session_id
where website_sessions.created_at < '2012-07-28' -- tugas diminta
	and website_pageviews.website_pageview_id >= 23504
    and utm_source = 'gsearch'
    and utm_campaign = 'nonbrand'
group by website_pageviews.website_session_id;
	
Select * from first_test_pageviews;

Create temporary Table nonbrand_test_sessions_w_landing_page
Select
	first_test_pageviews.website_session_id,
	website_pageviews.pageview_url as landing_page
from first_test_pageviews
	left join website_pageviews 
		on first_test_pageviews.min_pageview_id = website_pageviews.website_pageview_id
where website_pageviews.pageview_url in ('/home','/lander-1');

Select * from nonbrand_test_sessions_w_landing_page;

Create Temporary Table nonbrand_test_w_orders
Select
	nonbrand_test_sessions_w_landing_page.website_session_id,
	nonbrand_test_sessions_w_landing_page.landing_page,
    orders.order_id as order_id
from nonbrand_test_sessions_w_landing_page
	left join orders
		on nonbrand_test_sessions_w_landing_page.website_session_id = orders.website_session_id;

Select * from nonbrand_test_w_orders;

select
	landing_page,
	count(website_session_id) as total_sessions,
    count(order_id) as total_order,
    count(order_id)/count(website_session_id) as conv_rt
from nonbrand_test_w_orders
group by 1;

-- 7. cnver funnel



