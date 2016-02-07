set search_path=fft,public;

create table raster_stats (
ymd date,
east integer,
north integer,
type char,
stat text,
value float);

create function stats_in(file text,type char,stat text)
returns integer language SQL AS $$
drop temp tablde rstmp if exists;
create temp table rstmp (
ymd date,
east integer,
north integer,
value float);
copy rstmp(ymd,east,north,value) from $1 with csv;
with i as (
 insert into raster_stats
 select ymd,east,north,$2,$3,value
 from rstmp returning type,stat
)
select count(*) from i;
$$;

\set pwd `pwd`
select * from stats_in(:'pwd'||'/'||'ETo_avg15','h','avg15');

