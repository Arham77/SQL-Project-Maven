use mavenfuzzyfactory;

SELECT 
	pageview_url,
    count(distinct website_pageview_id)
from website_pageviews
where created_at < '2012-06-09'
group by 1