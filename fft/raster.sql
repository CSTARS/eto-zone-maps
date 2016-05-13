set search_path=fft,public;

create table raster_stats (
ymd date,
east integer,
north integer,
type char,
stat text,
value float);

create or replace function stats_in(fn text,type_in char,stat_in text)
returns integer language PLPGSQL VOLATILE AS $$
declare
cnt integer;
begin
drop table if exists rstmp;
create temp table rstmp (
ymd date,
east integer,
north integer,
value float);
EXECUTE format('copy rstmp(ymd,east,north,value) from ''%1$s'' with csv;',fn);
with i as (
 insert into raster_stats
 select ymd,east,north,type_in,stat_in,value
 from rstmp returning type,stat
)
select into cnt count(*) from i;
return cnt;
end;
$$;

create materialized view raster_15avg as
with a as (select
 (extract(month from ymd))::integer as month,
 (extract(day from ymd))::integer as day,
 east,north,type,
 avg(value) as ETo
from raster_stats
where stat='avg15'
group by 1,2,3,4,5)
select pid,type,
array_agg(ETo order by CASE WHEN (month<10) THEN month+12 ELSE month END,day) as ETo
from a join cimis_pixels using (east,north)
group by pid,type;

create materialized view raster_15avg_ed as
select pid,type,(fft(ETo)).*
from raster_15avg;

create materialized view statewide_avg as
with a as (
 select type,e.n,
 avg(e.v)
 from raster_15avg,
 unnest(eto) WITH ORDINALITY as e(v,n)
 group by 1,2
)
select type,
array_agg(avg order by n) as ETo
from a group by 1;

create view statewide as
select row_number() OVER () as week,et0
from statewide_avg,unnest(ETo) as et0;

-- This is a test function to see if we can import a raster from a table of data.
create or replace function raster_template ()
returns public.raster as $$
select ST_setsrid(ST_MakeEmptyRaster( 510, 560, -410000,460000, 2000),3310);
--select ST_AddBand(ST_setsrid(ST_MakeEmptyRaster( 510, 560, -410000,460000, 2000),3310),1, '8BUI', 0, 0);
$$ LANGUAGE SQL IMMUTABLE;

create table cimis_pixels (pid serial primary key,x integer,y integer,east integer,north integer);
insert into cimis_pixels(x,y,east,north)
SELECT x, y, ST_X(st_centroid(geom)) as east,st_y(st_centroid(geom)) as north
from  raster_template() as r,ST_PixelAsPolygons(r,1);

create type pixel_t as (pid integer,class integer);
CREATE or replace FUNCTION fill_raster(r_in public.raster,band_in integer,pixels_in pixel_t[])
RETURNS public.raster
AS $$
DECLARE
inv RECORD;
rast public.raster;
BEGIN
  rast := r_in;
  FOR inv IN SELECT x,y,class FROM (select (unnest(pixels_in)).*) as p join cimis_pixels using (pid) LOOP
  rast := st_setvalue(rast,band_in,inv.x,inv.y,inv.class);
END LOOP;
return rast;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION zones_to_raster()
RETURNS public.raster
AS $$
DECLARE
rast public.raster;
pixels pixel_t[];
i integer;
BEGIN
rast := raster_template();
FOR i in select zone_id from zones order by zone_id LOOP
 rast:= CASE WHEN (i=1) THEN ST_AddBand(rast,1, '8BUI', 0, 0) ELSE ST_addBand(rast,rast,i-1,i) END;
 select into pixels array_agg((pid,zone_id)::pixel_t) from zone_rmse_min(i) where zone_id=i;
 rast:= fill_raster(rast,i,pixels);
END LOOP;
return rast;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION move_zones_to_raster()
RETURNS public.raster
AS $$
DECLARE
rast public.raster;
pixels pixel_t[];
i integer;
BEGIN
rast := raster_template();
FOR i in select zone_id from zones order by zone_id LOOP
 rast:= ST_AddBand(rast,i, '8BUI', 0, 0);
 select into pixels array_agg((pid,zone_id)::pixel_t) from total_move_rmse_min where zones=i;
 rast:= fill_raster(rast,i,pixels);
END LOOP;
return rast;
END;
$$ LANGUAGE plpgsql;

-- gdal_translate -of GTiff "PG:dbname=eto_zones schema=avg_0625 table=raster" zones.tif
