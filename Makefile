#! /usr/bin/make -f 

# Converting to WGS84 is a more accepted GEOJSON format.
geojson/original_zones.geojson: src/original_zones.vrt
	ogr2ogr -f GEOJSON  -t_srs WGS84 $@ $<

# Here's an Example of materializing that VRT file, for example to
# upload to Google Maps.
shp: src/original_zones.vrt
	ogr2ogr $@ $<
