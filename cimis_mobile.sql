-- This SQL creates the required json for calculating the daily summaries by
-- dau and eto_zone

create view keys as 
with g as (
 select
 510 as ncols,
 560 as nrows,
 -410000 as xllcorner,
 -660000 as yllcorner,
 2000 as cellsize
)
select
pid,north,east,
nrows-floor((north - yllcorner) / cellsize) ||'-'||
floor((east-xllcorner) / cellsize ) as key
from g,cimis_boundary order by north desc,east asc;


-- CIMIS pixels retrieved from website.
create table cimis_boundary as
select
pid,east,north,
st_setsrid(st_makebox2d(
 st_makepoint(east-1000,north-1000),
 st_makepoint(east+1000,north+1000)),3310) as boundary
from raster_15avg
join cimis_pixels using (pid);

-- Areas for each pixel in each DAU
create temp table dau_pixel_area as
select pid,dau_code,
st_area(st_intersection(p.boundary,d.wkb_geometry)) as area
from cimis_boundary p
join dauco d on st_intersects(p.boundary,d.wkb_geometry);

create view json_index as with a as (
select pid,
'DAU'||dau_code as code,
(100*area/4000000.0)::integer as area
from dau_pixel_area
union
select pid,'Z'||zone_id as code,
 100 as area
 from avg_0625.total_move_rmse_min where zones=17
),
k as (
select
--east,north,
key,
json_object(
 array_agg(code order by code),
 array_agg(area::text order by code)
) as v
from a join cimis_boundary using (pid)
join keys using (pid)
where area > 5
group by key
order by key)
select ('{'||string_agg('"'||key||'":'||v,',')||'}')::jsonb as index from k;
