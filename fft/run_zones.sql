-- This is the script used to create our original 13 zones.
-- We choose zones such that
-- Prepare environment
set search_path=fft,compare,public;
select require_init();

-- This section reads in our datasets
\set pwd `pwd`
select * from stats_in(:'pwd'||'/'||'ETo_15avg.csv','h','avg15');
refresh materialized view raster_15avg;
refresh materialized view raster_15avg_ed;
refresh materialized view statewide_avg;
-- You can
-- truncate raster_stats;

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

truncate zones restart identity cascade;
insert into zones (zone,weight_id,e,d,et)
select 'statewide',:w_id,e,d,ifft(e,d,52) as et
from (select (fft(eto)).* from statewide_avg where type='h'
) as a;
insert into zone_rmse select * from missing_rmse;


\set min 1000
\set l 2
-- Two in this region 0.25
select * from add_new_cluster(1/2^:1,:min);
select * from add_new_cluster(1/2^:1,:min);
\set l 3 
-- Two here 0.125
select * from add_new_cluster(1/2^:1,:min);
select * from add_new_cluster(1/2^:1,:min);
\set l 4
-- 6 as 0.0625
select * from add_new_cluster(1/2^:1,:min);
select * from add_new_cluster(1/2^:1,:min);
select * from add_new_cluster(1/2^:1,:min);
select * from add_new_cluster(1/2^:1,:min);
select * from add_new_cluster(1/2^:1,:min);
select * from add_new_cluster(1/2^:1,:min);
-- There are many at > 100 at this point

