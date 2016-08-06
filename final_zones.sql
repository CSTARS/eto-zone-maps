-- From the import of Mui's final zones table.....
-- The 1 byte id is p0*25.  Or p0 ~ zone_number/25 
alter table final_zones add column zone_number integer;
update final_zones set zone_number = (p0*25)::integer;

create table final_zones_rast as
with t as (
 select rast
 from avg_0625.zones_map
 limit 1
),
v(t,b,e) as (
 values (ARRAY['8BUI','32BF','32BF','32BF','32BF','32BF'],
 ARRAY[
  ROW(null,'8BUI',0,0),
  ROW(null,'32BF',0,0),
  ROW(null,'32BF',0,0),
  ROW(null,'32BF',0,0),
  ROW(null,'32BF',0,0),
  ROW(null,'32BF',0,0)]::addbandarg[],
         ARRAY[0.0,0,0,0,0,0])
),
r as (
 select
 st_union(st_asRaster(geom,rast,t,
  ARRAY[(p0*25)::integer::float,p0,p1,p2,h1,h2],e)) as rast
 from final_zones,t,v
),
tot as (
select st_addBand(rast,b) as rast from t,v
union
select rast from r
)
select st_union(rast) as rast
from tot;

create table final_zones_pixels as
with f as (
 select (st_pixelascentroids(rast,1)).*
 from final_zones_rast
),
p as (
 select st_x(geom) as east,st_y(geom) as north,val
 from f
)
select
pid,east,north,val
from p
left join cimis_boundary
using (east,north);

