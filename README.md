California ETo Zone Maps (eto-zone-maps)
========================================

This project is intended to document the methodology used to create a new set of Reference Evapotranspiration (ETo) Zone Maps for California.

# DSI Un-seminar
Here are some data diversions that you can try.  These are collected for the
[DSI Un-seminar](https://drive.google.com/drive/folders/1HigsM4hkpL418MV39eAeY2NQ-2QImYQm?usp=sharing).

## [Graphs](https://drive.google.com/open?id=1Fz2jvDLQVHKh-zkSd0PGE6LQL_4G3VqoSKu-ePlKSJc)

Most of the graphs that are shown in this presentation where taken from one
spreadsheet or another in the directory above.  In addition, there are many more
station/raster comparisons.  **NOTE**, I'm not sure what happens when multiple
people try to make display modifications on the same sheet, so you may want to
copy these.

1. These use Davis station to shown data and to explain the FFT transform.
2. These sheets show parameters for a number of stations around California.
     They include some statewide outliers, the LA area, and the Delta.  The
     sheets allow some modification of the parameters to view.
3. Shows some comparisons of predicted zones for the station and raster data.

## QGIS

You should be able to clone this repository, and get some of the QGIS examples
at least limping along.  The raster processing is done in grass, and the
examples are included in this repo.  The postgis vectors however, will not be
available to you.

## Cimis-Mobile

Try out the Soon-To-Be-Released (We hope) [CIMIS
Mobile](https://cimis-mobile.casil.ucdavis.edu) web app.  You can see today's
parameters that we are discussing.  One major hold-up for this, is that we don't
have the ETo Zone Maps completed.

# Other information

## Data Sets

The following datasets are available for use in the determination of the ETo Zone Maps.

* *Spatial CIMIS* - This is a daily set of ETo estimates for California at a 2km grid, starting in 2003.
* *CalSIMETAW* - This is an estimated daily set of Tn,Tx, and PPT for Californiat at a 4km grid starting in 1921.
* *CIMIS Station Data* - This is a 30 year record of California Weather stations used for calculation of ETo.  Currently, we only have the subset of data from 2003 onwards.

## References

Online references are found in the [California ETo Zone Maps](http://www.mendeley.com/groups/5047311/california-eto-zone-maps/) Mendeley Group.
