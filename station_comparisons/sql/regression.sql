create type use_t as ENUM ('all','include','exclude','2014');
create type seasons_t as ENUM ('YR','OND','JFM','AMJ','JAS');

create or replace view seasons as
with s(season_num,season,months) as ( VALUES
   (0,'YR'::seasons_t,ARRAY[10,11,12,1,2,3,4,5,6,7,8,9]),
   (1,'OND'::seasons_t,ARRAY[10,11,12]),
   (2,'JFM'::seasons_t,ARRAY[1,2,3]),
   (3,'AMJ'::seasons_t,ARRAY[4,5,6]),
   (4,'JAS'::seasons_t,ARRAY[7,8,9])
) select * from s;

create type use_t as ENUM ('all','include','exclude');

create table regression (
station_id integer,
parm text,
season seasons_t,
use use_t,
rmse decimal(6,4),
slope decimal(6,2),
intercept decimal(6,2),
r2 decimal(6,2),
count bigint,
primary key(station_id,use,parm,season)
);

create or replace function add_regression (y text,x text,use use_t)
returns setof regression
language PLPGSQL as
$$
declare
qc text;
begin
qc=x||'_qc';
CASE WHEN (use='all') THEN
RETURN QUERY EXECUTE format($F$select station_id,'%1$s'::text as parm,
s.season as season,
$1 as use,
(sqrt(sum((y.%1$I-x.%2$I)^2))/count(*))::decimal(6,4) as rmse,
regr_slope(y.%1$I,x.%2$I)::decimal(6,2) as slope,
regr_intercept(y.%1$I,x.%2$I)::decimal(6,2) as intercept,
regr_r2(y.%1$I,x.%2$I)::decimal(6,2) as r2,
count(*)
from station x
join station_qc q using (station_id,ymd)
join raster y
using (station_id,ymd)
join seasons s
on (extract(month from ymd)=ANY(s.months))
where y.%1$I is not null and
x.%2$I is not null
and q.%4$I in ('','K','Y','H')
group by station_id,s.season$F$,y,x,use,qc) USING use;
WHEN (use='2014') THEN
RETURN QUERY EXECUTE format($F$select station_id,'%1$s'::text as parm,
s.season as season,
$1 as use,
(sqrt(sum((y.%1$I-x.%2$I)^2))/count(*))::decimal(6,4) as rmse,
regr_slope(y.%1$I,x.%2$I)::decimal(6,2) as slope,
regr_intercept(y.%1$I,x.%2$I)::decimal(6,2) as intercept,
regr_r2(y.%1$I,x.%2$I)::decimal(6,2) as r2,
count(*)
from station x
join station_qc q using (station_id,ymd)
join raster y
using (station_id,ymd)
join seasons s
on (extract(month from ymd)=ANY(s.months))
where y.%1$I is not null and
x.%2$I is not null
and q.%4$I in ('','K','Y','H')
and '2013-09-30'::date < ymd and ymd < '2014-10-01'::date 
group by station_id,s.season$F$,y,x,use,qc) USING use;
WHEN (use='include') THEN
RETURN QUERY EXECUTE format($F$select station_id,'%1$s'::text as parameter,
s.season as season,
$1 as use,
(sqrt(sum((y.%1$I-x.%2$I)^2))/count(*))::decimal(6,4) as rmse,
regr_slope(y.%1$I,x.%2$I)::decimal(6,2) as slope,
regr_intercept(y.%1$I,x.%2$I)::decimal(6,2) as intercept,
regr_r2(y.%1$I,x.%2$I)::decimal(6,2) as r2,
count(*)
from station x
join station_qc q using (station_id,ymd)
join raster y using (station_id,ymd)
join station_in i using(station_id,ymd)
join seasons s
on (extract(month from ymd)=ANY(s.months))
where
y.%1$I is not null and
x.%2$I is not null
and q.%4$I in ('','K','Y','H')
group by station_id,s.season$F$,y,x,use,qc) USING use;
WHEN (use='exclude') THEN
RETURN QUERY EXECUTE format($F$select station_id,'%1$s'::text as parameter,
s.season as season,
$1 as use,
(sqrt(sum((y.%1$I-x.%2$I)^2))/count(*))::decimal(8,6) as rmse,
regr_slope(y.%1$I,x.%2$I)::decimal(6,2) as slope,
regr_intercept(y.%1$I,x.%2$I)::decimal(6,2) as intercept,
regr_r2(y.%1$I,x.%2$I)::decimal(6,2) as r2,
count(*)
from station x
join station_qc q using (station_id,ymd)
join raster y using (station_id,ymd)
left join station_in i using(station_id,ymd)
join seasons s
on (extract(month from ymd)=ANY(s.months))
where i is null and
y.%1$I is not null and
x.%2$I is not null
and q.%4$I in ('','K','Y','H')
group by station_id,season$F$,y,x,use,qc) USING use;
END CASE;
end
$$;

create or replace function add_to_regression()
RETURNS bigint
language sql as
$$
with a(y,x,u)  as (VALUES
('eto','asce_eto','2014'),
('sol_rad_avg','sol_rad_avg','2014'),
('fao_eto','asce_eto','2014'),
('fao_sol_rad_avg','sol_rad_avg','2014')
)
insert into regression
select (add_regression(y,x,u::use_t)).* from a;
select count(*) from regression;
$$;

CREATE or replace view eto_whiskers as
with r as (
 select row_number() over(order by (m+2)%12,d) as r,
 m,d,
 lpad(m::text,2,0::text)||'-'||lpad(d::text,2,0::text) as md 
from md 
order by 1
)
select 
station_id,season,
whisker_plot(array_agg(s_eto_w order by r),
array_agg(md order by r),'{"outliers":true,"min":-3,"max":12}'::json) as station,
whisker_plot(array_agg(sdiffr_eto_w order by r),
array_agg(md order by r),'{"outliers":true,"min":-3,"max":3}'::json) as diff
from compare15_avg
join r using (m,d) join seasons on m=ANY(months) 
where season='YR' and r%4=1
group by station_id,season
union
select
station_id,season,
whisker_plot(array_agg(s_eto_w order by r),
array_agg(md order by r),'{"outliers":true,"min":-3,"max":12}'::json) as station,
whisker_plot(array_agg(sdiffr_eto_w order by r),
array_agg(md order by r),'{"outliers":true,"min":-3,"max":3}'::json) as diff
from compare15_avg
join r using (m,d) join seasons on m=ANY(months)
where season != 'YR' and r%2=1
group by station_id,season;

CREATE or replace view eto_summary as
with s as (
  select station_id,parm,season,use,
  CASE WHEN (slope != 1) THEN (intercept/(1-slope))::decimal(6,2) ELSE null END as switch,
  slope,intercept,r2,rmse
  from regression
  where parm='eto' and use='include'
)
select station_id,season,rmse,slope,intercept,r2,switch,
case WHEN (slope=1 and intercept <=0) THEN 'HH'
      WHEN (slope=1 and intercept>0) THEN 'LL'
      WHEN (slope>1 and switch <= 0) THEN 'HH'
      WHEN (slope >1 and switch>=0) THEN 'LH'
      WHEN (slope < 1 and switch < 0) THEN 'LL'
      WHEN (slope<1 and switch>=0) THEN  'HL'
      ELSE 'XX' END as type,
      station as station_plot,
      diff as difference_plot
from s join eto_whiskers using (station_id,season);

