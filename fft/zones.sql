--drop schema zones;
--create schema zones;

set search_path=fft,public;
select require_fft();

create table weights (
weight_id serial primary key,
weighting text unique,
w float[52]
);

insert into weights
select 0,'annual',array_agg(et0*0+1.0)
from statewide ;

insert into weights
select 1,'growing',
array_agg(
CASE WHEN (week > 4*(9) and week <= 4*(12))
THEN 1 ELSE 0 END
order by week)
from statewide ;

insert into weights
select 2,'plus',
array_agg(
CASE WHEN (week > 4*(9) and week <= 4*(12))
THEN 2 ELSE 1 END
order by week)
from statewide ;

insert into weights
select 3,'final',
array_agg(
CASE WHEN (week > 4*(6.5) and week <= 4*(12.5))
THEN
CASE WHEN (week > 4*(9) and week <= 4*(12))
THEN 2 ELSE 1.5 END
ELSE
1
END
order by week)
from statewide ;

create table zones (
zone_id serial primary key,
zone text,
weight_id integer references weights,
e float[],
d float[],
et float[52],
unique(zone,weight_id)
);

insert into zones (zone,weight_id,e,d,et) select 'statewide',0,e,d,ifft(e,d,52) as et from fft(statewide());
insert into zones (zone,weight_id,e,d,et) select 'statewide',1,e,d,ifft(e,d,52) as et from fft(statewide());
insert into zones (zone,weight_id,e,d,et) select 'statewide',2,e,d,ifft(e,d,52) as et from fft(statewide());


create table zone_rmse (
east integer,
north integer,
zone_id integer references zones,
rmse float
);

create or replace view missing_rmse as 
with
d as (
select distinct zone_id
from zone_rmse
),
z as (
select zone_id,weight_id,z.et,w.w
from zones z join weights w using (weight_id)
left join d using (zone_id)
where d.zone_id is null
),
r as (
 select east,north,
 array_agg(et0 order by week) as et
 from wy_med
 group by 1,2
),
c as (
 select
 east,north,zone_id,z.weight_id,
 unnest(r.et) as r,
 unnest(z.et) as z,
 unnest(z.w) as w
 from r,z
)
select
east,north,zone_id,
sqrt(sum(w^2*(r-z)^2))/sum(w) as rmse
from c
group by 1,2,3;

create view zone_rmse_min as
with n as (
 select
 east,north,weight_id,zone_id,rmse,
 min(rmse) OVER (partition by east,north,weight_id) as min
from zone_rmse
join zones using (zone_id)
)
select east,north,weight_id,zone_id,rmse
from n
where rmse=min;

create or replace view cluster as
select
east,
north,
zone_id,
rmse,
CASE when(f.e0<z.e[1]) THEN 'n' ELSE 'x' END as e0,
CASE WHEN (f.e1<z.e[2]) THEN 'n' ELSE 'x' END as e1,
CASE WHEN (f.e2<z.e[3]) THEN 'n' ELSE 'x' END as e2,
CASE WHEN (f.d1<z.d[2]) THEN 'n' ELSE 'x' END as d1,
CASE WHEN (f.d2<z.d[3]) THEN 'n' ELSE 'x' END as d2
from ed f
join zone_rmse_min r using (east,north)
join zones z using (zone_id);

create or replace function
error_clusters (max float,count integer)
RETURNS TABLE (zone_id integer,e0 char,e1 char,e2 char,d1 char,d2 char,count bigint)
LANGUAGE SQL as $$
with c as (
 select zone_id,e0,e1,e2,d1,d2,count(*)
 from cluster
 where rmse>$1
 group by 1,2,3,4,5,6
 ),
 r as (
 select *,
 row_number() OVER (partition by zone_id order by count desc) as row
 from c
 )
 select
 zone_id,e0,e1,e2,d1,d2,count
 from r
 where count > $2;
 $$;


-- OK, now we need to update our signatures....
create or replace function
new_clusters (max float,count integer)
RETURNS TABLE (zone text,weight_id integer,e float[],d float[],et float[])
LANGUAGE SQL as $$
with a as (
 select zone_id,e0,e1,e2,d1,d2,week,
 (whisker(et0::numeric)).median as et0
 from error_clusters($1,$2) as c
 join cluster using (zone_id,e0,e1,e2,d1,d2)
 join wy_med r using (east,north)
 where rmse>$1
 group by zone_id,e0,e1,e2,d1,d2,week
),
b as (
 select zone_id,e0,e1,e2,d1,d2,
 fft(array_agg(et0 order by week))
 from a
 group by zone_id,e0,e1,e2,d1,d2
)
--insert into zones (zone,weight_id,e,d,et)
select
format('%s_%s%s%s-%s%s-%s',zone_id,e0,e1,e2,d1,d2,$1) as zone,
weight_id,(fft).e,(fft).d,
ifft((fft).e,(fft).d,52) as et
from b
join zones using (zone_id);
$$;


