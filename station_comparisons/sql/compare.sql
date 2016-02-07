\set pwd `pwd`
\set station :pwd /station.csv
\set station_qc :pwd /station_qc.csv
\set station_in :pwd /station_in.csv
\set raster :pwd /raster.csv
\set station_info :pwd /station_info.csv

create table station_info (
  station_id integer primary key,
  name text,
  latitude float,
  longitude float,
  elevation_ft float,
  elevation float,
  start_date date,
  end_date date
);
-- copy station_info from :'station_info' with csv header;

-- create table station (
-- id integer,
-- ymd date,
-- air_tmp_min float,
-- air_tmp_max float,
-- air_tmp_avg float,
-- dew_pnt float,
-- eto float,
-- asce_eto float,
-- precip float,
-- sol_rad_avg float,
-- sol_rad_net float,
-- wind_spd_avg float,
-- vap_pres_max float,
-- vap_pres_min float,
-- primary key (id,ymd)
-- );
-- copy station from :'station' with csv header;

-- create table station_qc (
-- id integer,
-- ymd date,
-- air_tmp_min_qc char,
-- air_tmp_max_qc char,
-- air_tmp_avg_qc char,
-- dew_pnt_qc char,
-- eto_qc char,
-- asce_eto_qc char,
-- precip_qc char,
-- sol_rad_avg_qc char,
-- sol_rad_net_qc char,
-- wind_spd_avg_qc char,
-- vap_pres_max_qc char,
-- vap_pres_min_qc char,
-- primary key (id,ymd)
-- );
-- copy station_qc from :'station_qc' with csv header;

-- create table station_in (
-- x float,
-- y float,
-- z float,
-- id integer,
-- ymd date,
-- air_tmp_min float,
-- air_tmp_min_qc char,
-- air_tmp_max float,
-- air_tmp_max_qc char,
-- wind_spd_avg float,
-- wind_spd_avg_qc char,
-- rel_hum_max float,
-- rel_hum_max_qc char,
-- dew_pnt float,
-- dew_pnt_qc char,
-- primary key(id,ymd)
-- );
-- copy station_in from :'station_in' with csv header;

-- create table raster (
-- x float,
-- y float,
-- id integer,
-- ymd date,
-- ETo float,
-- Tn float,
-- Tx float,
-- Tdew float,
-- Rs float,
-- Rso float,
-- Rnl float,
-- U2 float,
-- K float
-- );
-- copy raster from :'raster' with csv header null '*';

-- Patch the Raster data
--create table fao_raster (
--x float,y float,station_id integer,ymd date,
--ETo float,Rso float,K float);
--copy fao_raster from :'raster' with csv header null '*';
--alter table raster add column fao_rso float;
--alter table raster add column fao_eto float; 
--update raster r set fao_rso=f.rso,fao_eto=f.eto from fao_raster f where r.station_id=f.station_id and r.ymd=f.ymd;

create view seasons as
with s("order",season_id,months) as ( VALUES
   (1,'OND',ARRAY[10,11,12]),
   (2,'JFM',ARRAY[1,2,3]),
   (3,'AMJ',ARRAY[4,5,6]),
   (4,'JAS',ARRAY[7,8,9])
) select * from s;

CREATE OR REPLACE FUNCTION array_median(numeric[])
  RETURNS numeric AS
$$
    SELECT CASE WHEN array_upper($1,1) = 0 THEN null ELSE asorted[ceiling(array_upper(asorted,1)/2.0)] END
    FROM (SELECT ARRAY(SELECT ($1)[n] FROM
generate_series(1, array_upper($1, 1)) AS n
    WHERE ($1)[n] IS NOT NULL
            ORDER BY ($1)[n]
) As asorted) As foo ;
$$
  LANGUAGE 'sql' IMMUTABLE;

CREATE AGGREGATE median(numeric) (
  SFUNC=array_append,
  STYPE=numeric[],
  FINALFUNC=array_median
);

create type use_t as ENUM ('all','include','exclude');

create table regression (
id integer,
parm text,
use use_t,
xfrmse decimal(6,4),
slope decimal(6,2),
intercept decimal(6,2),
r2 decimal(6,2),
count bigint,
primary key(id,use,parm)
);

create or replace function add_regression (y text,x text,use use_t)
returns setof regression
language PLPGSQL as
$$
declare
qc text;
begin
qc=x||'_qc';
CASE WHEN (use='all') THEN
RETURN QUERY EXECUTE format($F$select id,'%1$s'::text as parm,
$1 as use,
(sqrt(sum((y.%1$I-x.%2$I)^2))/count(*))::decimal(6,4) as rmse,
regr_slope(y.%1$I,x.%2$I)::decimal(6,2) as slope,
regr_intercept(y.%1$I,x.%2$I)::decimal(6,2) as intercept,
regr_r2(y.%1$I,x.%2$I)::decimal(6,2) as r2,
count(*)
from station x
join station_qc q using (id,ymd)
join raster y
using (id,ymd)
where y.%1$I is not null and
x.%2$I is not null
and q.%4$I in ('','K','Y','H')
group by id$F$,y,x,use,qc) USING use;
WHEN (use='include') THEN
RETURN QUERY EXECUTE format($F$select id,'%1$s'::text as parameter,
$1 as use,
(sqrt(sum((y.%1$I-x.%2$I)^2))/count(*))::decimal(6,4) as rmse,
regr_slope(y.%1$I,x.%2$I)::decimal(6,2) as slope,
regr_intercept(y.%1$I,x.%2$I)::decimal(6,2) as intercept,
regr_r2(y.%1$I,x.%2$I)::decimal(6,2) as r2,
count(*)
from station x
join station_qc q using (id,ymd)
join raster y using (id,ymd)
join station_in i using(id,ymd)
where
y.%1$I is not null and
x.%2$I is not null
and q.%4$I in ('','K','Y','H')
group by id$F$,y,x,use,qc) USING use;
WHEN (use='exclude') THEN
RETURN QUERY EXECUTE format($F$select id,'%1$s'::text as parameter,
$1 as use,
(sqrt(sum((y.%1$I-x.%2$I)^2))/count(*))::decimal(8,6) as rmse,
regr_slope(y.%1$I,x.%2$I)::decimal(6,2) as slope,
regr_intercept(y.%1$I,x.%2$I)::decimal(6,2) as intercept,
regr_r2(y.%1$I,x.%2$I)::decimal(6,2) as r2,
count(*)
from station x
join station_qc q using (id,ymd)
join raster y using (id,ymd)
left join station_in i using(id,ymd)
where i is null and
y.%1$I is not null and
x.%2$I is not null
and q.%4$I in ('','K','Y','H')
group by id$F$,y,x,use,qc) USING use;
END CASE;
end
$$;

create or replace function add_to_regression()
RETURNS bigint
language sql as
$$
with a(y,x)  as (VALUES
('eto','asce_eto'),
('tn','air_tmp_min'),
('tx','air_tmp_max'),
('tdew','dew_pnt'),
('u2','wind_spd_avg'),
('rs','sol_rad_net')
),
b (u) as (
  VALUES
  ('all'::use_t),
  ('include'::use_t),
  ('exclude'::use_t))
insert into regression
select (add_regression(y,x,u)).* from a,b;
select count(*) from regression;
$$;

CREATE view eto_regression_trend as
with s as (
  select id,use,parm,
  CASE WHEN (slope != 1) THEN (intercept/(1-slope))::decimal(6,2) ELSE null END as switch,
  slope,intercept
  from regression
  where parm='eto' and use='include'
)
select id,parm,use,switch,
case WHEN (slope=1 and intercept <=0) THEN 'HH'
      WHEN (slope=1 and intercept>0) THEN 'LL'
      WHEN (slope>1 and switch <= 0) THEN 'HH'
      WHEN (slope >1 and switch>=0) THEN 'LH'
      WHEN (slope < 1 and switch < 0) THEN 'LL'
      WHEN (slope<1 and switch>=0) THEN  'HL'
      ELSE 'XX' END as type
from s;
