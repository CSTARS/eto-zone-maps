#! /usr/bin/make -f 

#include grass.mk

# Converting to WGS84 is a more accepted GEOJSON format.
geojson/original_zones.geojson: src/original_zones.vrt
	ogr2ogr -f GEOJSON  -t_srs WGS84 $@ $<

# Here's an Example of materializing that VRT file, for example to
# upload to Google Maps.
shp: src/original_zones.vrt
	ogr2ogr $@ $<

original_zones.csv: src/original_zones.vrt
#	ogr2ogr -f PostgreSQL PG:service=eto_zones $< 
	psql service=eto_zones -c '\COPY (with a as (select distinct definition,jan,feb,mar,apr,may,june,july,aug,sept,oct,nov,dec from original_zones), b as (select definition,st_asKML(st_union(st_buffer(wkb_geometry,0.0))) as boundary from original_zones group by definition ) select num,definition,jan,feb,mar,apr,may,june,july,aug,sept,oct,nov,dec,boundary from zone_nums join a using (definition) join b using (definition)) to $@ with csv header'

original_zones_each.csv: src/original_zones.vrt
	psql service=eto_zones -c '\COPY (with b as (select definition,st_asKML(wkb_geometry) as boundary from original_zones) select num,definition,boundary from zone_nums join b using (definition)) to $@ with csv header'
