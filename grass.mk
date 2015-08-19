#! /usr/bin/make -f

# Are we currently Running Grass?
ifndef GISRC
  $(error Must be running in GRASS)
endif


GISDBASE:=$(shell g.gisenv get=GISDBASE)
LOCATION_NAME:=$(shell g.gisenv get=LOCATION_NAME)
MAPSET:=$(shell g.gisenv get=MAPSET)

# Shortcut Directories
loc:=$(GISDBASE)/$(LOCATION_NAME)
rast:=$(loc)/$(MAPSET)/cellhd

define add_rast
.PHONY:: $1
$1:${rast}/$1
endef

rasts:=MAM JJA JJA_MAM_class month_class jja_class

$(foreach r,${rasts},$(eval $(call add_rast,$r)))

${rast}/JJA:
	r.series input="ETo@xxxx-06,ETo@xxxx-07,ETo@xxxx-08" output=JJA method=average

${rast}/MAM:
	r.series input="ETo@xxxx-03,ETo@xxxx-04,ETo@xxxx-05" output=MAM method=average

${rast}/JJA_MAM_class:
	r.recode input=JJA output=JJAc rules=JJA.recode title="Major Classes";\
	r.mapcalc $(notdir $@)='if(JJAc==8,if(MAM<=4,8,9),if(JJAc==11,if(MAM<=4.25,11,12),if(JJAc==13,if(MAM<=4.5,13,15),JJAc)))';

# Groups and subgroups need to be made by hand.
${rast}/month_class:
	i.cluster group=monthly subgroup=monthly classes=18 sigfile=months
	i.maxlik group=monthly subgroup=monthly sigfile=months class=month_class

${rast}/jja_class:
	i.cluster group=monthly subgroup=jja classes=18 sigfile=jja
	i.maxlik group=monthly subgroup=jja sigfile=jja class=jja_class

${vect}/original_zones:
	v.in.ogr dsn=. layer=original_zones output=original_zones type=boundary snap=1

${rast}/oringinal_zones:
	
 i.group group=pca subgroup=1to5 input=pc.1,pc.2,pc.3,pc.4,pc.55
