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

-- create table station_et (
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

alter table raster add column sol_rad_avg float;
alter table raster add column fao_sol_rad_avg float; 
update raster r set sol_rad_avg=rs/24/0.0036, fao_sol_rad_avg=fao_rso*k/24/0.0036;

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

