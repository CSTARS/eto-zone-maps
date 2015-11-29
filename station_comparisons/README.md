# Station Comparisons

In order to investigate whether any systematic bias exists in the Spatial CIMIS product, we compare the station data to that as calculated by the the Spatial CIMIS program.  During these  calculations, we will look primarily at four different seasons.

season_id | Description
--- | ---
OND | OCT, NOV, DEC
JFM | JAN, FEB, MAR
AMJ | APR, MAY, JUN
JAS | JUL, AUG, SEP

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
--- | ---
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
--- | ---
OND       | 2.08+-1.28 | 1.86+-1.21 | 2.02+-1.22 | 2.04+-1.09 | 2.11+-1.16 | 2.15+-1.33 | 2.09+-1.18 | 1.86+-1.19 | 2.13+-1.10 | 2.03+-1.21 | 2.34+-1.13 |
JFM       |            | 2.24+-1.41 | 1.89+-1.28 | 2.05+-1.05 | 2.44+-1.28 | 2.32+-1.35 | 2.34+-1.35 | 2.09+-1.36 | 2.15+-1.21 | 2.43+-1.17 | 2.52+-1.22 | 2.53+-1.28
AMJ       |            | 5.61+-1.58 | 5.06+-1.73 | 4.85+-1.98 | 5.48+-1.72 | 5.58+-1.72 | 5.27+-1.71 | 5.16+-1.84 | 5.17+-1.78 | 5.53+-1.81 | 5.67+-1.71 | 5.77+-1.65
JAS       |            | 5.54+-1.41 | 5.42+-1.54 | 5.35+-1.47 | 5.39+-1.48 | 5.48+-1.41 | 5.64+-1.47 | 5.45+-1.50 | 5.42+-1.57 | 5.49+-1.52 | 5.45+-1.49 | 5.42+-1.58


## Station Differences

For each of these stations, we can compare the station measurements to those measurments as calculated by the Spatial CIMIS program.  We can do this if the following ways.  First, for each station, and for each season, we can calculate what the average difference in the Spatial CIMIS data as compared to the Station calculated data.  This will show us any overall bias in the maps.  When we do this we only include the station data used in the calculation of the ETo maps in the Spatial CIMIS dataset.

The average station error per season, as well as the minimum and maximum average differences are shown below.  On average, biases are small, with that greatest average bias being -0.25 mm/day for the AMJ season.  While the largest under prediction is almost consistently station Piru, the largest over prediction changes every season.  

season_id |  under prediction   |  Average Bias |  Overprediction
--- | ---
OND       | -0.98 (Piru) | -0.07 | 0.36 (La Quinta)
JFM       | -0.91 (Coalinga)  | -0.10 | 0.24 (Glendale)
AMJ       | -1.63 (Piru) | -0.23 | 0.68 (Calipatria)
JAS       | -1.54 (Piru) |  0.05 | 1.02 (Big Bear Lake)
