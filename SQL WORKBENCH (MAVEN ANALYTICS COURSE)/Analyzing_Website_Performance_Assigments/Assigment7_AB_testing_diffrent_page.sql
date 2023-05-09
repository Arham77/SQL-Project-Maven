use mavenfuzzyfactory;

-- pertama cari tanggal atau session_id ke berapa billing 2 dimulai
select * from website_pageviews where website_pageviews.pageview_url = '/billing-2';


SELECT billing_version_seen,
	count(distinct website_session_id),
    count(distinct order_id),
    count(distinct order_id)/count(distinct website_session_id) as order_rt
from ( Select
   website_pageviews.website_session_id ,
   website_pageviews.pageview_url AS billing_version_seen, 
   orders.order_id
FROM website_pageviews
    LEFT JOIN orders
       ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550
	AND website_pageviews.created_at < '2012-11-10'
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')
    )t
group by billing_version_seen
;
    