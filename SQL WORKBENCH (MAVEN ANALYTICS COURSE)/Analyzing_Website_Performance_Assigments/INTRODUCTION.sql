/*
-- TOP PAGE VIEWS
Select 
	pageview_url,
    count(website_pageview_id) as url
FROM website_pageviews
group by 1
order by 2 asc;



*/
-- MOST FIRST PAGE OPENED BY USER 
with CTE as (
Select 
	website_session_id,
    min(website_pageview_id) as first_landing
from website_pageviews
where website_pageview_id < 1000 -- just for example cause too much data 
group by website_session_id
)

Select 
	pageview_url as landing_pages,
    count(CTE.website_session_id) as count_pages
from CTE 
left join website_pageviews 
	on website_pageviews.website_pageview_id = CTE.first_landing
group by pageview_url