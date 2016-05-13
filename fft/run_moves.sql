-- One time
create or replace function move_setup()
returns boolean LANGUAGE plpgsql volatile as $$
begin
execute 'create table move_rmse (
pid integer,
zone_id integer references zones,
rmse float
);';
execute 'create index zone_rmse_pid on move_rmse(pid);';
execute 'create index zone_rmse_rmse on move_rmse(rmse);';
execute 'create view move_rmse_min as
with n as (
 select
  pid,weight_id,zone_id,rmse,
   min(rmse) OVER (partition by pid,weight_id) as min
   from move_rmse
   join zones using (zone_id)
   )
   select pid,weight_id,zone_id,rmse
   from n
   where rmse=min;';

execute 'create table move as 
select 0 as iteration,
zone_id,null::char as type,
et as eto
from zones;
create table move_rmse_sum as select 0 as iteration,sum(rmse) from move_rmse;
create table move_count as select 0 as iteration,zone_id,count(*) from fft.zone_rmse_min(0) group by zone_id order by zone_id;';
return true;
end;
$$;

create function new_rmse(iteration integer)
RETURNS boolean LANGUAGE SQL VOLaTILE AS $$
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
 and m.iteration=$1
)
insert into move_rmse select
pid,zone_id,
sqrt(sum(w^2*(r-z)^2))/sum(w) as rmse
from c
group by 1,2;
select true;
$$;

create function new_move(iteration integer)
RETURNS boolean LANGUAGE SQL AS $$
insert into move
select $1 as iteration,
zone_id,type,
array_avg(eto::numeric[]) as eto
from move_rmse_min
join raster_15avg using (pid)
group by zone_id,type
 order by zone_id;
select true;
$$;

create function one_move(iteration integer)
RETURNS boolean LANGUAGE SQL AS $$
select * from new_move($1);
select * from new_rmse($1);
insert into move_rmse_sum select $1,sum(rmse) from move_rmse_min;
insert into move_count select $1,zone_id,count(*)
from move_rmse_min
group by zone_id
order by zone_id;
select true;
$$;

-- Add real savings into
create or replace function add_total_move_rmse_sum_fft(zones integer)
RETURNS boolean LANGUAGE SQL AS $$
with f as (
 select zone_id,(fft(eto)).*
 from total_move
 where zones=$1 and iteration=5
),
z as (
 select zone_id,ifft(e,d,52) as r
 from f
),
d as (
 select pid,zone_id,
 unnest(r) as r,unnest(eto) as x,unnest(w) as w
 from z cross join fft.raster_15avg
 cross join (select w from weights where weight_id=3) as w
),
r as (
 select pid,zone_id,sqrt(sum(w^2*(r-x)^2))/sum(w) as rmse
from d
group by pid,zone_id
),
n as (
 select pid,zone_id,rmse,
 min(rmse) OVER (partition by pid) as min
 from r
)
insert into total_move_rmse_min
select $1 as zones,pid,zone_id,rmse
from n where rmse=min;
insert into total_move_rmse_sum_fft
select $1,5,sum(rmse) from total_move_rmse
where zones=$1;
select true;
$$;

create or replace function move_zones(zones integer)
RETURNS boolean LANGUAGE SQL AS $$
truncate move;
truncate move_rmse_sum;
insert into move
select 0 as iteration,
zone_id,null::char as type,
et as eto
from zones
where zone_id<=$1;
select * from new_rmse(0);
insert into move_rmse_sum select 0,sum(rmse) from move_rmse_min;
select * from one_move(1);
select * from one_move(2);
select * from one_move(3);
select * from one_move(4);
select * from one_move(5);
insert into total_move_count select $1 as zones,iteration,zone_id,count from move_count;
insert into total_move select $1 as zones,iteration,zone_id,type,eto from move;
insert into total_move_rmse_sum select $1 as zones,iteration,sum from move_rmse_sum;
select * from add_total_move_rmse_sum_fft($1);
select true;
$$;

-- \set z 5
-- select * from move_zones(:z);
-- \set z 6
-- select * from move_zones(:z);
-- \set z 7
-- select * from move_zones(:z);
-- \set z 8
-- select * from move_zones(:z);
-- \set z 9
-- select * from move_zones(:z);
-- \set z 10
-- select * from move_zones(:z);
-- \set z 11
-- select * from move_zones(:z);
-- \set z 12
-- select * from move_zones(:z);
-- \set z 16
-- select * from move_zones(:z);
-- \set z 17
-- select * from move_zones(:z);

-- Create all the new images.
create or replace function create_total_move_rmse(zones integer)
RETURNS boolean LANGUAGE SQL AS $$
create table total_move_rmse as 
with f as (
 select zones,zone_id,(fft(eto)).*
 from total_move
 where iteration=5
),
z as (
 select zones,zone_id,ifft(e,d,52) as r
 from f
),
d as (
 select zones,pid,zone_id,
 unnest(r) as r,unnest(eto) as x,unnest(w) as w
 from z cross join fft.raster_15avg
 cross join (select w from weights where weight_id=3) as w
),
r as (
 select zones,pid,zone_id,sqrt(sum(w^2*(r-x)^2))/sum(w) as rmse
from d
group by zones,pid,zone_id
),
n as (
 select zones,pid,zone_id,rmse,
 min(rmse) OVER (partition by pid) as min
 from r
),
nn as (
 select zones,pid,zone_id,rmse
 from n where rmse=min
)
select * from nn;
$$;
