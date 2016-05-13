-- run_zones_0625 extends the
-- our original runs (13), by picking up pixels that are fewer,
-- but have the higher error.  The overall reduction in RMSE
-- is less in this context.

\set schema avg_0625
-- Prepare environment
set search_path=:schema,fft,compare,public;
select require_init();

-- final choice for weights
\set w_id 3
create table zones (
zone_id serial primary key,
zone text,
weight_id integer references weights,
e float[],
d float[],
et float[52],
unique(zone,weight_id)
);
-- start from previous
insert into zones
select * from fft.zones where zone_id<=11;
alter sequence zones_zone_id_seq restart 12;

create or replace view missing_rmse as 
with
d as (
select distinct zone_id
from zone_rmse ),
z as (
select zone_id,weight_id,z.et,w.w
from zones z join weights w using (weight_id)
left join d using (zone_id)
where d.zone_id is null ),
r as (
 select pid,eto
 from raster_15avg
 where type='h' ),
c as (
 select
 pid,zone_id,z.weight_id,
 unnest(r.eto) as r,
 unnest(z.et) as z,
 unnest(z.w) as w
 from r,z )
select
pid,zone_id,
sqrt(sum(w^2*(r-z)^2))/sum(w) as rmse
from c
group by 1,2;


create table zone_rmse as
select * from zone_rmse where zone_id<=11;

\set min 100
\set l 4
-- Continue to add from 0.0625 (lower min) 31 at first
select * from add_new_cluster(1/2^:1,:min);


