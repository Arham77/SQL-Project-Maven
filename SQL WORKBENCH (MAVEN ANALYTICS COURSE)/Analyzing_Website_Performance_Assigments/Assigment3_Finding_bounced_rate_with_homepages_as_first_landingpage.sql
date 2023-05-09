-- bouch_rate of where user landing first on homepage 

-- Buat table dimana hanya memuat halaman pertama yang diklik oleh setiap user atau session_id 
create temporary table first_pageviews
Select
	website_session_id,
    min(website_pageview_id) as min_pageview_id
from website_pageviews
where created_at < '2012-06-14'
group by website_session_id;

select * from first_pageviews;

-- dari teble diatas, dibuat table baru yang hanya home page sebagai halam awal yang dibuka user
create temporary table sessions_w_home_landing_page
Select 
	first_pageviews.website_session_id,
    website_pageviews.pageview_url as landing_page
from first_pageviews
left join website_pageviews
	on website_pageviews.website_pageview_id = first_pageviews.min_pageview_id
where website_pageviews.pageview_url = '/home';

select * from session_w_home_landing_page;
-- bounched session adalah user atau session_id yang hanya mengelik 1 page setelah itu keluar
create temporary table bounched_sessions
SELECT
    sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews
    ON website_pageviews.website_session_id = sessions_w_home_landing_page.website_session_id
GROUP BY
    sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page
-- having bermaksud untuk mengeluarkan session_id yang masuk ke lebih dari 1 page
HAVING
    COUNT(website_pageviews.website_pageview_id) = 1;
select * from bounched_sessions;

-- bounch_rate artinya terdapat 11048 user, dan sebanyak 6538 hanya sampai pada homepage tidak lanjut ke page lainnya
SELECT
   COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS sessions,
   COUNT(DISTINCT bounched_sessions.website_session_id) AS bounced_sessions,
   COUNT(DISTINCT bounched_sessions.website_session_id)/COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) AS bounce_rate
FROM sessions_w_home_landing_page
    LEFT JOIN bounched_sessions
        ON sessions_w_home_landing_page.website_session_id = bounched_sessions.website_session_id;
