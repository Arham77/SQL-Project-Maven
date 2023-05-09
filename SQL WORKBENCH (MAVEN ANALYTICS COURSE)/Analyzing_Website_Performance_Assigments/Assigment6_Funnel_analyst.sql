use mavenfuzzyfactory;

create temporary table table_2
Select website_session_id,
	max(product_page) as clickto_product_page,
    max(mrfuzzy_page) as clickto_mrfuzzy_page,
    max(cart_page) as clickto_cart_page,
    max(shipping_page) as clickto_shipping_page,
    max(billing_page) as billing_page,
    max(thankyou_page) as clickto_thankyou_page
from (
Select website_sessions.website_session_id,
	website_pageviews.pageview_url,
    Case when pageview_url = '/products' then 1 else 0 end product_page,
    Case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end mrfuzzy_page,
    Case when pageview_url = '/cart' then 1 else 0 end cart_page,
    Case when pageview_url = '/shipping' then 1 else 0 end shipping_page,
    Case when pageview_url = '/billing' then 1 else 0 end billing_page,
    Case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end thankyou_page
from website_sessions 
	left join website_pageviews
		on website_sessions.website_session_id = website_pageviews.website_session_id
where website_sessions.utm_source = 'gsearch'
	and website_sessions.utm_campaign = 'nonbrand'
    and website_sessions.created_at > '2012-08-05'
    and website_sessions.created_at < '2012-09-05'
order by website_sessions.website_session_id, website_sessions.created_at
) t
group by website_session_id;

select 
	count(distinct website_session_id) as sessions,
    count(distinct case when clickto_product_page = 1 THEN website_session_id ELSE NULL END) as clickto_product,
    count(distinct case when clickto_mrfuzzy_page = 1 THEN website_session_id ELSE NULL END) as clickto_mrfuzzy,
    count(distinct case when clickto_cart_page = 1 THEN website_session_id ELSE NULL END) as clickto_cart,
    count(distinct case when clickto_shipping_page = 1 THEN website_session_id ELSE NULL END) as clickto_shipping,
    count(distinct case when billing_page = 1 THEN website_session_id ELSE NULL END) as clickto_billing,
    count(distinct case when clickto_thankyou_page = 1 THEN website_session_id ELSE NULL END) as clickto_thankyou
from table_2
;

select 
	count(distinct case when clickto_product_page = 1 THEN website_session_id ELSE NULL END)*1.0/count(distinct website_session_id) as clickto_product_persentage,
    count(distinct case when clickto_mrfuzzy_page = 1 THEN website_session_id ELSE NULL END)*1.0/count(distinct case when clickto_product_page = 1 THEN website_session_id ELSE NULL END) as clickto_mrfuzzy_persentage,
    count(distinct case when clickto_cart_page = 1 THEN website_session_id ELSE NULL END)*1.0/count(distinct case when clickto_mrfuzzy_page = 1 THEN website_session_id ELSE NULL END) as clickto_cart_persentage,
    count(distinct case when clickto_shipping_page = 1 THEN website_session_id ELSE NULL END)*1.0/count(distinct case when clickto_cart_page = 1 THEN website_session_id ELSE NULL END) as clickto_shipping_persentage,
    count(distinct case when billing_page = 1 THEN website_session_id ELSE NULL END)*1.0/count(distinct case when clickto_shipping_page = 1 THEN website_session_id ELSE NULL END) as clickto_billing_persentage,
    count(distinct case when clickto_thankyou_page = 1 THEN website_session_id ELSE NULL END)*1.0/count(distinct case when billing_page = 1 THEN website_session_id ELSE NULL END) as clickto_thankyou_persentage
from table_2; 
