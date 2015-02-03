#! /usr/bin/make -f 
# Run in grass as owner of the database.

years:=2004 2005 2006 2007 2008 2008 2010 2011 2012 2013 2014
vars:=ETo
months=01 02 03 04 05 06 07 08 09 10 11 12

tifs:=$(foreach m,${months},$(patsubt %,$m/$m-%.tif,${vars}))

INFO:
	echo ${months}
	echo ${tifs}

# for m in `seq -f %02g 1 12`; do mkdir $m; for r in ETo; do r.out.gdal input=${r}@xxxx-${m} output=${m}_${r}.tif; done; don

