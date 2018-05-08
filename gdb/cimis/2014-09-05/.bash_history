r.info U2
r.stats U2
g.region -d
r.info U2
v.vol.rst input="et" cellinp="Z@2km" wcolumn="day_wind_spd_avg" tension=5 smooth=0.05 where="day_wind_spd_avg_qc in ('K','Y','')" maskmap="state@2km" segmax=50 npmin=200 npmax=700 dmin=1000.000000 wmult=1.0 zmult=30 cellout="foo"
g.list rast
g.region -d b=-100 t=2500 tbres=1000;
for s in 0 0.02 0.05; do for z in 30; do for t in 3 5 7 10; do  ws=ws_s${s}_z${z}_t${t};  v.vol.rst --overwrite input=et wcolumn=day_wind_spd_avg   cross_input=Z@2km maskmap=state@2km  tension=${t} zscale=${z} smooth=${s}  cross_output=${ws}  where="day_wind_spd_avg_qc in ('K','Y','')";  r.colors map=${ws} color=gyr;  export GRASS_RENDER_FILE="${ws}.png";  d.mon --overwrite start=png;  d.erase;  d.rast ${ws};  d.legend title="${ws}";  raster=${ws};  d.mon stop=png; done;done;done 2>&1 | tee vol.rst.txt
g.remove --help
g.remove type=rast pattern=ws_*
g.remove -f type=rast pattern=ws_*
rm ws_s0*
export GRASS_RENDER_WIDTH=510;
export GRASS_RENDER_HEIGHT=560;
g.region -d b=-100 t=2500 tbres=1000;
for s in 0 0.02 0.05; do for z in 1 30; do for t in 3 5 10 20; do  ws=ws_s${s}_z${z}_t${t};  v.vol.rst --overwrite input=et wcolumn=day_wind_spd_avg   cross_input=Z@2km maskmap=state@2km  tension=${t} zscale=${z} smooth=${s}  cross_output=${ws}  where="day_wind_spd_avg_qc in ('K','Y','')";  r.colors map=${ws} color=gyr;  export GRASS_RENDER_FILE="${ws}.png";  d.mon --overwrite start=png;  d.erase;  d.rast ${ws};  d.legend title="${ws}";  raster=${ws};  d.mon stop=png; done;done;done 2>&1 | tee vol.rst.txt
g.list type=rast mapset=default_colors
ls
rm ws_s0*.png
r.mask state@2km
r.info Rs
r.mapcalc Rs=G*0.0036
r.mapcalc --overwrite Rs=G*0.0036
export GRASS_RENDER_WIDTH=510;
export GRASS_RENDER_HEIGHT=560;
g.region -d b=-100 t=2500 tbres=1000;
for s in 0 0.02 0.05; do for z in 1 30; do for t in 3 5 10 20; do  ws=ws_s${s}_z${z}_t${t};  v.vol.rst --overwrite input=et wcolumn=day_wind_spd_avg   cross_input=Z@2km maskmap=state@2km  tension=${t} zscale=${z} smooth=${s}  cross_output=${ws}  where="day_wind_spd_avg_qc in ('K','Y','')";  r.colors map=${ws} rast=U2@default_colors;  export GRASS_RENDER_FILE="${ws}.png";  d.mon --overwrite start=png;  d.erase;  d.rast ${ws};  d.legend title="${ws}";  raster=${ws};  d.mon stop=png; done;done;done 2>&1 | tee vol.rst.txt
rm ws_s0*.png
for s in 0 0.02 0.05; do for z in 1 30; do for t in 3 5 10 20; do  ws=ws_s${s}_z${z}_t${t};  v.vol.rst --overwrite input=et wcolumn=day_wind_spd_avg   cross_input=Z@2km maskmap=state@2km  tension=${t} zscale=${z} smooth=${s}  cross_output=${ws}  where="day_wind_spd_avg_qc in ('K','Y','')";  r.colors map=${ws} rast=U2; done;done;done
r.info Tx
r.mapcalc z_Tx=z_day_air_tmp_max_lr5_t10_s0.03
r.colors map=z_Tx rast=Tx
g.gisenv
g.remove type=rast pattern=*00
g.remove -f type=rast pattern=*00
g.list rast
g.remove -f type=rast pattern=*00_9
g.mapset 2017-08-01
g.remove -f type=rast pattern=*00_9
g.remove -f type=rast pattern=*00
g.mapset 2018-02-01
g.remove -f type=rast pattern=*00
g.remove -f type=rast pattern=*00_9
