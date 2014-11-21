#! /usr/bin/make -f 

orig:=src/eto_utm10_nad27
orig.epsg:=epsg:26710
epsg:=epsg:3310

colon:=:

data/original_zones.geojson: $(patsubst %,${orig}.%,shp shx dbf)
	ogr2ogr -f GEOJSON -s_srs ${orig.epsg} -t_srs epsg:4326 $@ ${orig}.shp $(notdir ${orig})

data/epsg3310/original_zones.geojson: $(patsubst %,${orig}.%,shp shx dbf)
	ogr2ogr -f GEOJSON -s_srs ${orig.epsg} -t_srs ${epsg} $@ ${orig}.shp $(notdir ${orig})

