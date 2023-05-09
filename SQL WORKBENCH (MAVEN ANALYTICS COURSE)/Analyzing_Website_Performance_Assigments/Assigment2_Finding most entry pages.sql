with cte as (
select 
	min(website_pageview_id) as entry_pages,
    website_session_id
from website_pageviews
where created_at < '2012-06-12'
group by 2)

Select 
	pageview_url,
    count(distinct cte.website_session_id) as count_pages
from cte
left join website_pageviews 
	on website_pageviews.website_pageview_id = cte.entry_pages
group by 1
    ;