-- The self_rmse table calculates the total amount of RMSE that comes just from the
-- presentation of the eto values as an fft transform.
create temp table self_rmse as
with r as (
 select pid,
 unnest(eto) as eto,
 unnest(ifft(e,d,52)) as ifft,
 unnest(w) as w
 from raster_15avg_ed
 join raster_15avg using (pid)
 cross join weights w where weight_id=3
)
select pid,sqrt(sum(w^2*(eto-ifft)^2))/sum(w) as rmse
from r
group by 1;

--select sum(rmse) from self_rmse ;
--        1978.08673747287
-- Is a lower bound on how good a map can get.

create or replace view intra_zone_rmse as 
with r as (
 select
 z1.zone_id as z1_id,
 z2.zone_id as z2_id,
 unnest(z1.et) as z1e,
 unnest(z2.et) as z2e,
 unnest(w) as w
 from zones z1
 join zones z2 on (z1.zone_id < z2.zone_id)
 cross join (select * from fft.weights where weight_id=3) as w
)
select z1_id,z2_id,
(sqrt(sum(w^2*(z1e-z2e)^2))/sum(w))::decimal(7,4) as rmse
from r
group by 1,2;


create view intra_zone_rmse_ct as
select * from  crosstab(
  'select z1_id,z2_id,rmse from intra_zone_rmse order by 1,2',
  'select distinct z2_id from intra_zone_rmse order by 1')
as ct(
 zone integer,
 z2 decimal(7,3),z3 decimal(7,3),z4 decimal(7,3),z5 decimal(7,3),z6 decimal(7,3),z7 decimal(7,3),z8 decimal(7,3),z9 decimal(7,3),
 z10 decimal(7,3),z11 decimal(7,3),z12 decimal(7,3),z13 decimal(7,3),z14 decimal(7,3),z15 decimal(7,3),
 z16 decimal(7,3),z17 decimal(7,3),z18 decimal(7,3)
);


-- These example queries below save some summary information for
-- the classifications.  They are used to gauge when enough classes
-- have been chosen.

-- When you use the schema avg_0625, which aims to eliminate all errors > 0.0625.  There are
-- only 18 final classes, not 20, so the histogram_ct gets changed

-- --
-- create materialized view fft.histogram as
-- with z as (
--  select distinct zone_id
--  from fft.zone_rmse order by 1
-- ),
-- m as (
--  select pid,z.zone_id,min(rmse) as rmse
--  from zone_rmse r
--  cross join z
--  where r.zone_id<=z.zone_id
--  group by 1,2
-- )
-- select zone_id,
-- (rmse*50)::integer/50.0 as bin,
-- count(*) as count,
-- sum(rmse) as rmse
-- from m group by 1,2 order by 1,2;

-- create view fft.histogram_ct as
-- select * from  crosstab(
--   'select bin,zone_id,count from fft.histogram order by 1,2',
--   'select distinct zone_id from fft.histogram order by 1')
-- as ct(
--  bin decimal(6,2),
--  z1 bigint,z2 bigint,z3 bigint,z4 bigint,z5 bigint,z6 bigint,z7 bigint,z8 bigint,z9 bigint,
--  z10 bigint,z11 bigint,z12 bigint,z13 bigint,z14 bigint,z15 bigint,z16 bigint,z17 bigint,z18 bigint,z19 bigint,z20 bigint
-- )

-- --\COPY (select * from histogram_ct) to ~/Downloads/histogram.csv with csv header
--\COPY (select zone_id,sum(rmse) as rmse from histogram group by 1 order by 1) to ~/Downloads/rmse.csv with csv header

create materialized view avg_0625.histogram as
with z as (
 select distinct zone_id
 from avg_0625.zone_rmse order by 1
),
m as (
 select pid,z.zone_id,min(rmse) as rmse
 from zone_rmse r
 cross join z
 where r.zone_id<=z.zone_id
 group by 1,2
)
select zone_id,
(rmse*50)::integer/50.0 as bin,
count(*) as count,
sum(rmse) as rmse
from m group by 1,2 order by 1,2;

create view avg_0625.histogram_ct as
select * from  crosstab(
  'select bin,zone_id,count from avg_0625.histogram order by 1,2',
  'select distinct zone_id from avg_0625.histogram order by 1')
as ct(
 bin decimal(6,2),
 z1 bigint,z2 bigint,z3 bigint,z4 bigint,z5 bigint,z6 bigint,z7 bigint,z8 bigint,z9 bigint,
 z10 bigint,z11 bigint,z12 bigint,z13 bigint,z14 bigint,z15 bigint,z16 bigint,z17 bigint,z18 bigint
)

--\COPY (select * from avg_0625.histogram_ct) to ~/Downloads/histogram.csv with csv header
--\COPY (select zone_id,sum(rmse) as rmse from avg_0625.histogram group by 1 order by 1) to ~/Downloads/rmse.csv with csv header

-- The zone_populations show how many pixels are assigned to each component.
create materialized view avg_0625.zone_population as
with z as (
 select distinct zone_id
 from avg_0625.zone_rmse order by 1
),
m as (
 select pid,z.zone_id as total_zones,r.zone_id,rmse,min(rmse) OVER (partition by pid,z.zone_id) as min_rmse
 from zone_rmse r
 cross join z
 where r.zone_id<=z.zone_id
)
select total_zones,zone_id,
count(*) as count
from m
where rmse=min_rmse
group by 1,2 order by 1,2;

create view avg_0625.zone_population_ct as
select * from  crosstab(
  'select total_zones,zone_id,count from avg_0625.zone_population order by 1,2',
  'select distinct zone_id from avg_0625.zone_population order by 1')
as ct(
 bin decimal(6,2),
 z1 bigint,z2 bigint,z3 bigint,z4 bigint,z5 bigint,z6 bigint,z7 bigint,z8 bigint,z9 bigint,
 z10 bigint,z11 bigint,z12 bigint,z13 bigint,z14 bigint,z15 bigint,z16 bigint,z17 bigint,z18 bigint
)
