create materialized view statewide
as
select
week,
avg(et0) as et0
from wy_med
group by week
order by week;

create materialized view pixel_avg
as
select
east,north,
(avg(et0))::decimal(6,2) as et0
from wy_med
group by 1,2
order by 1,2; 


