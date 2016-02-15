# Station Comparisons

In order to investigate whether any systematic bias exists in the Spatial CIMIS product, we compare the station data to that as calculated by the the Spatial CIMIS program.  During these  calculations, we will look primarily at four different seasons.

season_id | Description
--- | ---
OND | OCT, NOV, DEC
JFM | JAN, FEB, MAR
AMJ | APR, MAY, JUN
JAS | JUL, AUG, SEP

## Station Data

I haven't created a makefile to retrieve the data.  For to get the data, I've used this quick set of commands:
```{bash}
# in GRASSDB/cimis/quinn
if (true); then
  vars=ETo,Tn,Tx,Tdew,Rs,Rso,Rnl,U2,K
  file=~/station_raster_data.csv
else # FAO_data
  vars=vars=FAO_ETo,FAO_Rso,K # for FAO data
  file=~/station_raster_fao_data.csv
fi
rm ${file}
echo x,y,station,date,$vars > ${file}
for m in 20??-??-??; do
  echo $m;
  v.out.ascii fs=' ' input=stations | cut -d' ' -f 1,2,4 |  sed -e "s/$/,$m/" |\
    r.what input=$(echo $vars | sed -e "s/,/@$m,/g" -e "s/$/@$m/") fs=',' >> ${file};
done
```

## Statewide ETo Statistics

The following table shows the average seasonal ETo for California.  
<!---
with t as (
  select extract(year from ymd) as year,s.season_id,
  (avg(eto))::decimal(6,2),min(eto),max(eto),
  (stddev(eto))::decimal(6,2),median(eto::numeric),
  count(*)
  from station join station_qc using (id,ymd)
  join seasons s on (extract(month from ymd) = ANY(months))
  where eto_qc=''
  group by extract(year from ymd),season_id
)
select
 season_id,min,median,avg-stddev as "-1std",
 avg,avg+stddev as "+1std",max,stddev
from t join seasons using (season_id) order by year,"order";
--->

season_id | min | median | -1std | avg  | +1std |  max  | stddev
--- | --- | --- | --- | --- | --- | --- | ---
OND       |   0 |    1.9 |  0.87 | 2.07 |  3.27 |  9.97 |   1.20
JFM       |   0 |   2.14 |  0.99 | 2.28 |  3.57 | 16.22 |   1.29
AMJ       |   0 |   5.46 |  3.61 | 5.38 |  7.15 |  16.2 |   1.77
JAS       |   0 |   5.48 |  3.96 | 5.46 |  6.96 | 20.22 |   1.50

Yearly variation of the seaonal averages from the California stations can be pretty significant.  Remember, this is representative of the CIMIS stations, which are not an accurate representation of California in general.

<!---
create temp view yearly_avg as with t as (select extract(year from ymd) as  year,s.season_id,(avg(eto))::decimal(6,2),min(eto),max(eto),(stddev(eto))::decimal(6,2),median(eto::numeric),count(*) from station join station_qc using (id,ymd) join seasons s on (extract(month from ymd) = ANY(months)) where eto_qc='' group by extract(year from ymd),season_id) select season_id,year,(avg||'+-'||stddev)::text as avg from t join seasons using (season_id) order by "order",year;

select * from crosstab(
'select * from yearly_avg',
'select distinct extract(year from ymd) from station order by 1'
)
as ct(
season_id text,
y2003 text,y2004 text,y2005 text,y2006 text,y2007 text,y2008 text,y2009 text,y2010 text,y2011 text,y2012 text,y2013 text,y2014 text);
--->

season_id |   2003    |   2004    |   2005    |   2006    |   2007    |   2008    |   2009    |   2010    |   2011    |   2012    |   2013    |   2014
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
OND       | 2.08+-1.28 | 1.86+-1.21 | 2.02+-1.22 | 2.04+-1.09 | 2.11+-1.16 | 2.15+-1.33 | 2.09+-1.18 | 1.86+-1.19 | 2.13+-1.10 | 2.03+-1.21 | 2.34+-1.13 |
JFM       |            | 2.24+-1.41 | 1.89+-1.28 | 2.05+-1.05 | 2.44+-1.28 | 2.32+-1.35 | 2.34+-1.35 | 2.09+-1.36 | 2.15+-1.21 | 2.43+-1.17 | 2.52+-1.22 | 2.53+-1.28
AMJ       |            | 5.61+-1.58 | 5.06+-1.73 | 4.85+-1.98 | 5.48+-1.72 | 5.58+-1.72 | 5.27+-1.71 | 5.16+-1.84 | 5.17+-1.78 | 5.53+-1.81 | 5.67+-1.71 | 5.77+-1.65
JAS       |            | 5.54+-1.41 | 5.42+-1.54 | 5.35+-1.47 | 5.39+-1.48 | 5.48+-1.41 | 5.64+-1.47 | 5.45+-1.50 | 5.42+-1.57 | 5.49+-1.52 | 5.45+-1.49 | 5.42+-1.58


## Station Differences

For each of these stations, we can compare the station measurements to those measurments as calculated by the Spatial CIMIS program.  We can do this if the following ways.  First, for each station, and for each season, we can calculate what the average difference in the Spatial CIMIS data as compared to the Station calculated data.  This will show us any overall bias in the maps.  When we do this we only include the station data used in the calculation of the ETo maps in the Spatial CIMIS dataset.

The average station error per season, as well as the minimum and maximum average differences are shown below.  On average, biases are small, with that greatest average bias being -0.25 mm/day for the AMJ season.  While the largest under prediction is almost consistently station Piru, the largest over prediction changes every season.  

season_id |  under prediction   |  Average Bias |  Overprediction
--- | --- | --- | ---
OND       | -0.98 (Piru) | -0.07 | 0.36 (La Quinta)
JFM       | -0.91 (Coalinga)  | -0.10 | 0.24 (Glendale)
AMJ       | -1.63 (Piru) | -0.23 | 0.68 (Calipatria)
JAS       | -1.54 (Piru) |  0.05 | 1.02 (Big Bear Lake)

<!--
-- To Add stations to the spreadsheet

\COPY (select station_id,ymd,air_tmp_min,air_tmp_max,air_tmp_avg,dew_pnt,eto,asce_eto,precip,sol_rad_avg,sol_rad_net,wind_spd_avg,vap_pres_max,vap_pres_min,sol_rad_avg_qc from station join station_qc using (station_id,ymd) where '2004-10-01'::date <= ymd and ymd <= '2014-09-30'::date and station_id in (200) order by 1,2) to ~/Downloads/s200.csv with csv header^
\COPY (select station_id,ymd,tn as air_tmp_min,tx as air_tmp_max,tdew as dew_pnt,rnl,u2 as wind_spd_avg,k as clear_sky_frac,sol_rad_avg,eto,fao_sol_rad_avg,fao_eto from raster where '2004-10-01'::date <= ymd and ymd <= '2014-09-30'::date and station_id in (200) order by 1,2) to ~/Downloads/r200.csv with csv header
-->

## Differences in Solar Radiation Calculations

We have two different incoming solar radiation estimates, the heliosat
method, and the FAO method, which is more simple, and does not include
a turbidity estimate.  Turbidity is a problem in our calculations
because we use a global estimate of turbidity for California. This dataset has not been updated for many years,
and a potentially large source of error for our ETo estimates.   The FAO Evapotranspiration guidelines offer a more simple
Radiation claculation, with a fixed turbidity factor.  We have compared the two estimates, and the table below shows
that generally, the Heliosat (H) model outperforms the FAO (F) version for most stations.  However, about 10% of the stations 
do fit better with the FAO method.   However, the AMJ season shows a slightly higher number of stations favoring the 
FAO method as compared to the yearly summary.  Also, the nubmer of stations closer to the FAO in the later years of 
the record  goes up slightly as well. 

season |  ALL(H/F)  | 2014 (H/F)
---- | --- | ---
YR     | 152 / 14 | 136 / 8
OND    | 159 /  5 | 130 / 15
JFM    | 156 /  8 | 98 / 45
AMJ    | 143 / 21 | 128 / 18
JAS    | 153 / 13 | 132 / 11

Investigation of the Linke Turbidity factor, the largeest factor affecting the difference in the two methods, seems to
indicate that the larger the deviation from the mean turbidity factor the more likely the stations are to have a higher 
error when compared to the measurements. This is the case for the lower values for turbidity, where the Heliosat method 
predicts higher radiation, then measured by the station.  The trend is not so consistant with the higher turbidities, where 
the Heliosat method is less likely to underpredict the station measurments.

The overall takeaway message is probably that the Heliosat methods does a better job in predicting downwelling solar
radiation, but the current turbiidty estimations are too coarse to properly model California's aerosols and water vapor, 
and need to be updated with a newer method for calculating Linke turbidity.

<!-- 
```{sql}
-- use=all or 2014
\set use all 
create or replace view b as
with h as (
 select * from regression
 where parm='sol_rad_avg' and use=:'use'
),f as (
 select * from regression
 where parm='fao_sol_rad_avg' and use=:'use'
)
select station_id,season,
case when (h.rmse < f.rmse) THEN 'H' else 'F' end as best
from h join f using (station_id,season);

-- create CSV of best solar radiation match
select * from
crosstab('select * from b order by 1,2','select distinct season from b order by 1')
as (station_id integer,yr char,ond char,jfm char,amj char,jas char);

-- Overall count of best solar estimate.
with a as (
 select season,best,count(*) 
 from b group by 1,2
)
select season,h.count as h,f.count as f 
from a as h join a as f using (season)
where h.best='H' and f.best='F';
order by season
```
-->
