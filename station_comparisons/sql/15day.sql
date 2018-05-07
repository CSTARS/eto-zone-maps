create view md as
with md(m,d) as (VALUES
(01,04), (01,11), (01,18), (01,25),
(02,01), (02,08), (02,15), (02,22),
(03,01), (03,08), (03,15), (03,22), (03,29),
(04,05), (04,12), (04,19), (04,26),
(05,03), (05,10), (05,17), (05,24), (05,31),
(06,07), (06,14), (06,21), (06,28),
(07,05), (07,12), (07,19), (07,26),
(08,02), (08,09), (08,16), (08,23), (08,30),
(09,06), (09,13), (09,20), (09,27),
(10,04), (10,11), (10,18), (10,25),
(11,01), (11,08), (11,15), (11,22), (11,29),
(12,06), (12,13), (12,20), (12,27)
)
select * from md;

create materialized view avg_dates as
with d as (
 select distinct ymd from raster
),
dd as (
select extract(year from ymd) as y,ymd from d
)
select
ymd,
(format('%s-%s-%s',y,m,d))::date as ymd15,
m,d
from dd
join md
on (ymd >= (format('%s-%s-%s',y,m,d))::date - '7 days'::interval
and ymd <= (format('%s-%s-%s',y,m,d))::date + '7 days'::interval);

create index raster_ymd on raster(ymd);
create index avg_dates_ymd on avg_dates(ymd);

-- One 2017-11-26, I altered this command, and renamed ymd back to ymd15, do avoid confusion.
create materialized view ymd15 as
select station_id,
ymd15 as ymd15,
count(*) as count,
avg(s.eto)::decimal(6,2) as s_eto,
avg(r.eto)::decimal(6,2) as r_eto,
avg(s.eto-r.eto)::decimal(6,2) as sdiffr_eto
from station s join
raster r using (station_id,ymd)
join avg_dates using (ymd)
where s.eto is not null
and r.eto is not null
group by station_id,ymd15;


create materialized view ymd15_station_raster as
select station_id, ymd15, count(*) as count,
avg(eto) as eto_r,whisker(eto::numeric) as eto_rw,
avg(tn) as tn_r,whisker(tn::numeric) as tn_rw,
avg(tx) as tx_r,whisker(tx::numeric) as tx_rw,
avg(tdew) as tdew_r,whisker(tdew::numeric) as tdew_rw,
avg(rs) as rs_r,whisker(rs::numeric) as rs_rw,
avg(rso) as rso_r,whisker(rso::numeric) as rso_rw,
avg(rnl) as rnl_r,whisker(rnl::numeric) as rnl_rw,
avg(u2) as u2_r,whisker(u2::numeric) as u2_rw,
avg(k) as k_r,(whisker(k::numeric) as k_rw
from raster join avg_dates using (ymd)
group by station_id,m,d;
full outer join
select station_id, ymd15, count(*) as count,
avg(asce_eto) as eto_r,whisker(asce_eto::numeric) as eto_rw,
avg(air_tmp_min) as tn_r,whisker(air_tmp_min::numeric) as tn_rw,
avg(air_tmp_max) as tx_r,whisker(air_tmp_max::numeric) as tx_rw,
avg(dew_tmp) as tdew_r,whisker(dew_tmp::numeric) as tdew_rw,
avg(solrad_net) as rs_r,whisker(solrad_net::numeric) as rs_rw,
--avg(rso) as rso_r,hisker(rso::numeric) as rso_rw,
--avg(rnl) as rnl_r,whisker(rnl::numeric) as rnl_rw,
avg(wind_speed_avg) as u2_r,whisker(wind_speed_avg::numeric) as u2_rw,
avg(k) as k_r,(whisker(k::numeric) as kr_w
from station join avg_dates using (ymd)
group by station_id,m,d;


create materialized view md15 as
select station_id,
m,d,
count(*) as count,
whisker(eto::numeric) as eto_w,
whisker(tn::numeric) as tn_w,
whisker(tx::numeric) as tx_w,
whisker(tdew::numeric) as tdew_w,
whisker(rs::numeric) as rs_w,
whisker(rso::numeric) as rso_w,
whisker(rnl::numeric) as rnl_w,
whisker(u2::numeric) as u2_w,
whisker(k::numeric) as k_w
from raster join avg_dates using (ymd)
group by station_id,m,d;

-- create view compare15_avg as
-- select station_id,
-- m,d,
-- count(*) as count,
-- whisker(r_eto::numeric) as r_eto_w,
-- whisker(s_eto::numeric) as s_eto_w,
-- whisker(sdiffr_eto::numeric) as sdiffr_eto_w
-- from ymd15
-- join avg_dates using (ymd)
-- group by station_id,m,d;

create materialized view compare15 as
select station_id,
m,d,
count(*) as count,
whisker(r.eto::numeric) as r_eto_w,
whisker(s.eto::numeric) as s_eto_w,
whisker((s.eto-r.eto)::numeric) as sdiffr_eto_w
from station s
join raster r using (station_id,ymd)
join avg_dates using (ymd)
where r.eto is not null and
s.eto is not null
group by station_id,m,d;



-- Good Example
--with r as (select row_number() over(order by (m+2)%12,d) as r,m,d,lpad(m::text,2,0::text)||'-'||lpad(d::text,2,0::text) as md from md order by 1) select whisker_plot(array_agg(eto_w order by r),array_agg(md order by r),300) from md15 join r using (m,d) where r%3=1 and station_id=90;
