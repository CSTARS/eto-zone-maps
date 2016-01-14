create materialized view wy_med_a as
select
east,north,
array_agg(et0 order by week) as et0_a
from wy_med
group by east,north;

create materialized view sig_q as
with s as (
 select array_agg(((et0*1)::integer/1.0)::decimal(6,2)
 order by week) as sig
 from wy_med
 group by east,north
 )
 select sig,count(*) from s group by 1;

create or replace function w_rmse(a float[],b float[], w float[],OUT rmse numeric)
LANGUAGE plpgsql AS $$
declare
cnt integer;
i integer;
sum numeric;
begin
rmse=0;
sum=0;
cnt=array_length(a,1);
FOR i IN 1..cnt LOOP
 rmse=rmse + w[i]*(a[i]-b[i])^2;
 sum = sum + w[i];
END LOOP;
rmse=sqrt(rmse)/sum;
END
$$;
