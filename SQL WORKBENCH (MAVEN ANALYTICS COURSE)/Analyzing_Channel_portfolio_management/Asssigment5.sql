with cte as (
Select
    website_session_id,
    created_at,
    case 
		when utm_source is null and http_referer is not null then 'organic_search'
		when utm_campaign = 'nonbrand' then 'paid_nonbrand'
        when utm_campaign = 'brand' then 'paid_brand'
	else 'direct_type_in'
end as channel_group
from website_sessions
where created_at < '2012-12-23')

SELECT 
	YEAR(created_at) As ye, 
    MONTH(created_at) AS mo,
    sum(case when channel_group = 'paid_nonbrand' then 1 else null end) as nonbrand,
    sum(case when channel_group = 'paid_brand' then 1 else null end ) as brand,
    sum(case when channel_group = 'paid_brand' then 1 else null end ) / 
		sum(case when channel_group = 'paid_nonbrand' then 1 else null end) as brand_ptc_of_nonbrand,
	sum(case when channel_group = 'direct_type_in' then 1 else null end) as direct,
    sum(case when channel_group = 'direct_type_in' then 1 else null end) / 
		sum(case when channel_group = 'paid_nonbrand' then 1 else null end) as direct_ptc_of_nonbrand,
	sum(case when channel_group = 'organic_search' then 1 else null end) as organic,
    sum(case when channel_group = 'organic_search' then 1 else null end) /
		sum(case when channel_group = 'paid_nonbrand' then 1 else null end) as organic_ptc_of_nonbrand
from cte
group by 1,2;
        
	
