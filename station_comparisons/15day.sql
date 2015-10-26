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
ymd,(format('%s-%s-%s',y,m,d))::date as avg 
from dd 
join md 
on (ymd >= (format('%s-%s-%s',y,m,d))::date - '7 days'::interval 
and ymd <= (format('%s-%s-%s',y,m,d))::date + '7 days'::interval);

create index raster_ymd on raster(ymd);                                                                                                                                                               
create index avg_dates_ymd on avg_dates(ymd);

create materialized view avg15 as 
select id as station_id,
"avg" as ymd,
avg(eto)::decimal(6,2) as eto,
avg(tn)::decimal(6,2) as tn,
avg(tx)::decimal(6,2) as tx,
avg(tdew)::decimal(6,2) as tdew,
avg(rs)::decimal(6,2) as rs,
avg(rso)::decimal(6,2) as rso,
avg(rnl)::decimal(6,2) as rnl,
avg(u2)::decimal(6,2) as u2,
avg(k)::decimal(6,2) as k,
max(eto)::decimal(6,2) as eto_x,
max(tn)::decimal(6,2) as tn_x,
max(tx)::decimal(6,2) as tx_x,
max(tdew)::decimal(6,2) as tdew_x,
max(rs)::decimal(6,2) as rs_x,
max(rso)::decimal(6,2) as rso_x,
max(rnl)::decimal(6,2) as rnl_x,
max(u2)::decimal(6,2) as u2_x,
max(k)::decimal(6,2) as k_x,
min(eto)::decimal(6,2) as eto_n,
min(tn)::decimal(6,2) as tn_n,
min(tx)::decimal(6,2) as tx_n,
min(tdew)::decimal(6,2) as tdew_n,
min(rs)::decimal(6,2) as rs_n,
min(rso)::decimal(6,2) as rso_n,
min(rnl)::decimal(6,2) as rnl_n,
min(u2)::decimal(6,2) as u2_n,
min(k)::decimal(6,2) as k_n
from raster join avg_dates using (ymd)
group by id,"avg";

