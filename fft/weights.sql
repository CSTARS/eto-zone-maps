-- Weights is kinda janked now that statewide_avg is an array.
create table weights (
weight_id serial primary key,
weighting text unique,
w float[52]
);

insert into weights
select 0,'annual',array_agg(ETo*0+1.0)
from statewide;

insert into weights
select 1,'growing',
array_agg(
CASE WHEN (week > 4*(9) and week <= 4*(12))
THEN 1 ELSE 0 END
order by week)
from statewide;

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
