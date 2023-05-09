use mavenfuzzyfactory;
CREATE TEMPORARY TABLE sessions_w_min_pv_id_and_view_count1
Select 
	website_sessions.website_session_id,
	MIN(website_pageviews.website_pageview_id) as first_pageview_id,
    count(website_pageviews.website_pageview_id) as count_pageviews

from website_sessions
	left join website_pageviews
		on website_pageviews.website_session_id = website_sessions.website_session_id

WHERE website_sessions.created_at > '2012-06-01'
	AND website_sessions.created_at < '2012-08-31'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY website_sessions.website_session_id;

select * from sessions_w_min_pv_id_and_view_count1;

CREATE temporary table sessions_w_counts_lender_and_created_at
Select 
	sessions_w_min_pv_id_and_view_count1.website_session_id,
	sessions_w_min_pv_id_and_view_count1.first_pageview_id,
    sessions_w_min_pv_id_and_view_count1.count_pageviews,
    website_pageviews.created_at as session_created_at,
    website_pageviews.pageview_url as landing_page
from sessions_w_min_pv_id_and_view_count1
	left join website_pageviews
		on sessions_w_min_pv_id_and_view_count1.first_pageview_id = website_pageviews.website_pageview_id;

select * from sessions_w_counts_lender_and_created_at;

-- FINAL RESULT
select 
	yearweek(session_created_at) as Year_Week,
	min(Date(session_created_at)) as start_Week,
    count(distinct website_session_id) as total_sessions,
    count(distinct case when count_pageviews = 1 then website_session_id else null end) as bounced_session,
    count(distinct case when count_pageviews = 1 then website_session_id else null end)*1.0/count(distinct website_session_id) as Bounced_Rate,
    Count(distinct case when landing_page = '/home' Then website_session_id else Null end) as Home_session,
    Count(distinct case when landing_page = '/lander-1' Then website_session_id else Null end) as Lender_session
from sessions_w_counts_lender_and_created_at
group by yearweek(session_created_at);





