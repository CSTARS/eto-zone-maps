create materialized view wy_raster_stats as
with a as (select
 CASE WHEN ((extract(month from ymd))::integer <10) THEN (extract(year from ymd))::integer ELSE
      (extract(year from ymd))::integer - 1 END as wy,
 (extract(month from ymd))::integer as month,
 (extract(day from ymd))::integer as day,
   east,north,
   value as ETo
    from raster_stats
    where stat='avg15'
 )
 select wy,pid,
 array_agg(ETo order by CASE WHEN (month<10) THEN month+12 ELSE month END,day) as ETo
 from a join cimis_pixels using (east,north)
 group by wy,pid;

create table  wy_zones as
with c as (
 select
 wy,pid,zone_id,
 unnest(r.eto) as r,
 unnest(m.eto) as z,
 unnest(w.w) as w
 from wy_raster_stats r,
 move m,
 weights w
 where w.weight_id=3 
 and m.iteration=5
),
r as (
select
wy,pid,zone_id,
sqrt(sum(w^2*(r-z)^2))/sum(w) as rmse
from c
group by 1,2,3
),
m as (
select wy,pid,zone_id,min(rmse) OVER (partition by wy,pid) as min,rmse
from r
)
select wy,pid,zone_id,rmse from m where min=rmse;


