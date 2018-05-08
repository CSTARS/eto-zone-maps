create table compare.lt_15day (
station_id integer,
station_name text,
latitude float,
longitude float,
doy integer,
eto float
);

\COPY compare.lt_15day from station_average_15day.csv with csv header
