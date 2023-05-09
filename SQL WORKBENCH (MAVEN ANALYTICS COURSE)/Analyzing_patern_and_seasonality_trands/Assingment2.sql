select hr,
	round(avg(sessions),1),
    round(avg(case when wkday = 0 then sessions else null end),1) as mon,
    round(avg(case when wkday = 1 then sessions else null end),1) as tues,
    round(avg(case when wkday = 2 then sessions else null end),1) as wed,
    round(avg(case when wkday = 3 then sessions else null end),1) as thur,
    round(avg(case when wkday = 4 then sessions else null end),1) as fri,
    round(avg(case when wkday = 5 then sessions else null end),1) as sun
from (
Select 
	date(created_at) as dt,
	weekday(created_at) as wkday,
	hour(created_at) as hr,
	count(website_session_id) as sessions
from
website_sessions
where created_at between '2012-09-15' and '2012-11-15' 
group by 1,2,3) t
group by 1 
order by 1 
;