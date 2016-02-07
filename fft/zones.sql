set search_path=fft,public;
select require_fft();

create table zones (
zone_id serial primary key,
zone text,
weight_id integer references weights,
e float[],
d float[],
et float[52],
unique(zone,weight_id)
);

-- How does this get filled in? 
create table zone_rmse (
pid integer,
zone_id integer references zones,
rmse float
);
create index zone_rmse_pid on zone_rmse(pid);
create index zone_rmse_rmse on zone_rmse(rmse);


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
 select pid,eto
 from raster_15avg
 where type='h'
),
c as (
 select
 pid,zone_id,z.weight_id,
 unnest(r.eto) as r,
 unnest(z.et) as z,
 unnest(z.w) as w
 from r,z
)
select
pid,zone_id,
sqrt(sum(w^2*(r-z)^2))/sum(w) as rmse
from c
group by 1,2;

create or replace function zone_rmse_min ( max integer )
returns table (pid integer,weight_id integer,zone_id integer, rmse float)
as $$
with n as (
 select
 pid,weight_id,zone_id,rmse,
 min(rmse) OVER (partition by pid,weight_id) as min
from zone_rmse
join zones using (zone_id)
where $1=0 or zone_id <= $1
)
select pid,weight_id,zone_id,rmse
from n
where rmse=min;
$$ LANGUAGE SQL IMMUTABLE;

create or replace function cluster (max integer )
returns table (pid integer,zone_id integer, rmse float,e0 char,e1 char,e2 char,d1 char,d2 char)
as $$
select
pid,
zone_id,
rmse,
CASE when(f.e[1]<z.e[1]) THEN 'n' ELSE 'x' END as e0,
CASE WHEN (f.e[2]<z.e[2]) THEN 'n' ELSE 'x' END as e1,
CASE WHEN (f.e[3]<z.e[3]) THEN 'n' ELSE 'x' END as e2,
CASE WHEN (f.d[2]<z.d[2]) THEN 'n' ELSE 'x' END as d1,
CASE WHEN (f.d[3]<z.d[3]) THEN 'n' ELSE 'x' END as d2
from raster_15avg_ed f
join zone_rmse_min($1) r using (pid)
join zones z using (zone_id);
$$ LANGUAGE SQL IMMUTABLE;

create or replace function
error_clusters (max float,count integer,lim integer = 100)
RETURNS TABLE (zone_id integer,e0 char,e1 char,e2 char,d1 char,d2 char,rmse float,count bigint)
LANGUAGE SQL as $$
with c as (
 select zone_id,e0,e1,e2,d1,d2,
 count(*),sum(rmse) as total_rmse
 from cluster(0) c
 where c.rmse>$1
 group by 1,2,3,4,5,6
 ),
 r as (
 select *,
 row_number() OVER (partition by zone_id order by count desc) as row
 from c
 )
 select
 zone_id,e0,e1,e2,d1,d2,total_rmse,count
 from r
 where count > $2
 order by total_rmse desc
 limit $3;
 $$;


-- OK, now we need to update our signatures....
create or replace function
new_cluster (max float,count integer)
RETURNS TABLE (zone text,weight_id integer,e float[],d float[],et float[])
LANGUAGE SQL as $$
with
a as (
 select zone_id,e0,e1,e2,d1,d2,
 array_avg(ETo::numeric[])::float[] as ETo
 from error_clusters($1,$2,1) e
 join cluster c  using (zone_id,e0,e1,e2,d1,d2)
 join raster_15avg r using (pid)
 where c.rmse>$1
 and type='h'
 group by zone_id,e0,e1,e2,d1,d2
),
b as (
 select zone_id,e0,e1,e2,d1,d2,
 fft(ETo)
 from a
)
--insert into zones (zone,weight_id,e,d,et)
select
format('%s_%s%s%s-%s%s-%s',zone_id,e0,e1,e2,d1,d2,$1) as zone,
weight_id,(fft).e,(fft).d,
ifft((fft).e,(fft).d,52) as et
from b
join zones using (zone_id);
$$;

create or replace function
add_new_cluster(max float,count integer,lim integer = 100)
RETURNS TABLE (zone_id integer,e0 char,e1 char,e2 char,d1 char,d2 char,rmse float,count bigint)
LANGUAGE SQL VOLATILE as $$
insert into zones (zone,weight_id,e,d,et) select * from new_cluster($1,$2);
insert into zone_rmse select * from missing_rmse;
select * from error_clusters($1,$2,$3);
$$;

