-- One time
-- create table move_rmse as select * from zone_rmse;
-- create view move_rmse_min as
-- with n as (
--  select
--   pid,weight_id,zone_id,rmse,
--    min(rmse) OVER (partition by pid,weight_id) as min
--    from move_rmse
--    join zones using (zone_id)
--    )
--    select pid,weight_id,zone_id,rmse
--    from n
--    where rmse=min;

-- create table move as 
-- select 0 as iteration,
-- zone_id,null::char as type,
-- et as eto
-- from zones;
-- create table move_rmse_sum as select 0 as iteration,sum(rmse) from move_rmse;
-- create table move_count as select 0 as iteration,zone_id,count(*) from zone_rmse_min(0) group by zone_id order by zone_id;

-- Get newest averages
\set i 4
insert into move
select :i as iteration,
zone_id,type,
array_avg(eto::numeric[]) as eto
from move_rmse_min
join raster_15avg using (pid)
group by zone_id,type
 order by zone_id;
-- Calculate new RMSE
truncate move_rmse;
with c as (
 select
 pid,zone_id,w.weight_id,
 unnest(r.eto) as r,
 unnest(m.eto) as z,
 unnest(w.w) as w
 from raster_15avg r,
 move m,
 weights w
 where w.weight_id=3
 and m.iteration=:i
)
insert into move_rmse select
pid,zone_id,
sqrt(sum(w^2*(r-z)^2))/sum(w) as rmse
from c
group by 1,2;
-- Insert new counts
insert into move_count
select :i,zone_id,count(*)
from move_rmse_min
group by zone_id
order by zone_id;
-- Compare new counts
select
zone_id,array_agg(count order by iteration)
from move_count
group by zone_id;
-- Add new sum
insert into move_rmse_sum select :i,sum(rmse)
from move_rmse;
