create table public.station (
			 station_id integer primary key,
			 name text,
			 city text,
			 county text,
			 connect_date date,
			 disconnect_date date,
			 is_active boolean,
			 is_eto_station boolean,
			 elevation float,
			 groundcover text,
			 longitude float,
			 latitude float
			 );

\COPY public.station from station.csv with csv header
