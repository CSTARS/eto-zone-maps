#! /usr/bin/make -f
SHELL:=/bin/bash

include appKey.mk
# appKey.mk holds your et.water.ca.gov appKey
# appKey:=[Add Here or on command line, make api_key=foobar ]

include targets.mk

empty:=
sp:=${empty} ${empty}
comma:=,
target_ids := $(foreach t,${targets},${$t.id})
target_ids := $(subst ${sp},|,${target_ids})

sed.json:=sed -e "s/^\(.\)/.\u\1/" -e "s/\-\(.\)/\u\1/g"
items.daily:=day-air-tmp-min day-air-tmp-max day-air-tmp-avg day-dew-pnt day-eto day-asce-eto\
	day-precip day-sol-rad-avg day-sol-rad-net day-wind-spd-avg day-vap-pres-max day-vap-pres-min

items.daily.json:=$(shell for i in ${items.daily}; do echo $$i | ${sed.json}; done  )
items.daily.val:=$(subst ${sp},${comma},$(patsubst %,%.Value,${items.daily.json}))
items.daily.qc:=$(subst ${sp},${comma},$(patsubst %,%.Qc,${items.daily.json}))
items.daily.row:=.Station,.Date,${items.daily.val},${items.daily.qc}
items.daily.header:=$(subst .,,${items.daily.row})

INFO:
	@echo ${items.daily.row}
	@echo items.daily.qc: ${items.daily.qc}
	@echo "targets: ${targets}"

.PHONY:json csv

station.json:
	curl http://et.water.ca.gov/api/station > $@

station.csv: station.json
	jq -r '.Stations[] | [.StationNbr, .Name, .City, .County, .ConnectDate, .DisconnectDate, .IsActive, .IsEtoStation, .Elevation, .GroundCover, [.HmsLongitude, .HmsLatitude | split("/ ")[1]][]] | @csv' < $< > $@


targets.mk: station.json
	(echo -n "targets:="; jq -r '.Stations[] | "\(.StationNbr)-\(.Name)" ' < station.json | tr [:upper:] [:lower:]  | tr -s '[:punct:] ' _ | sed -e 's/^\(.\)_/0\1_/' -e 's/^\(..\)_/0\1_/' | tr '\n' ' ') > $@

define get_target
#$(warning-no get_target $1)
json::input/$1.json
csv::input/$1.csv

input/$1.json:
	t='$1';\
	http --timeout=360 GET http://et.water.ca.gov/api/data \
	  appKey==${appKey} targets==$$$${t%%_*} \
		startDate==2003-10-01 endDate==2015-09-30 \
	unitOfMeasure==M dataItems==$(subst ${sp},${comma},${items.daily}) > $$@

input/$1.csv:input/$1.json
	echo ${items.daily.header} > $$@
	jq -r ".Data.Providers[0].Records[] | [${items.daily.row}] | @csv" < $$< >> $$@
endef

$(foreach t,${targets},$(eval $(call get_target,$t)))
