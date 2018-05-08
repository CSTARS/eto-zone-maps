v.in.ascii --overwrite input=spatial_station_ratio.csv output=ratio \                                                                                          
format=point separator=, columns='station_id int,x double precision,y double precision,p0_ratio double precision,p1_ratio double precision'        
v.in.ascii --overwrite input=spatial_station_ratio.csv output=ratio format=point separator=, columns='station_id int,x double precision,y double precision,p0_ratio double precision,p1_ratio double precision'
g.region -d b=-100 t=2500 tbres=1000;
g.region -p
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km maskmap=state@2km tension=5 zmult=30 smooth=0.05 cellout=p0_r_t5_z30_s05 

r.info p0_r_t5_s05
r.info p0_r_t5_z30_s05
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km maskmap=state@2km tension=5 zscale=30 smooth=0.05 cellout=p0_r_t5_z30_s05 
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 cellout=p0_r_t5_z30_s05 
r.info p0_r_t5_z30_s05
v.out.ascii --help
v.out.ascii input=ratio columns=p0_ratio
r.stats p0_r_t5_z30_s05
r.stats --help p0_r_t5_z30_s05
r.stats -p p0_r_t5_z30_s05
g.region -p
r.stats Z@2km
r.stats -p Z@2km
r.stats -p Z@2km | less
v.vol.rst --help
v.vol.rst --help | less
v.vol.rst --help | less
v.vol.rst --help 2>&1 | less
v.in.ascii --help
v.in.ascii --overwrite z=3 input=spatial_station_ratio.csv output=ratio format=point separator=, columns='station_id int,x double precision,y double precision,p0_ratio double precision,p1_ratio double precision'
ls -lrt
date
mv ~/spatial_station_ratio.csv .
head spatial_station_ratio.csv 
mv ~/spatial_station_ratio.csv .
head spatial_station_ratio.csv 
v.in.ascii --overwrite z=3 input=spatial_station_ratio.csv output=ratio format=point separator=, columns='station_id int,x double precision,y double precision,p0_ratio double precision,p1_ratio double precision'
v.in.ascii --overwrite z=3 input=spatial_station_ratio.csv output=ratio format=point separator=, columns='station_id int,x double precision,y double precision,z double precision p0_ratio double precision,p1_ratio double precision'
v.in.ascii --overwrite z=3 input=spatial_station_ratio.csv output=ratio format=point separator=, columns='station_id int,x double precision,y double precision,z double precision, p0_ratio double precision,p1_ratio double precision'
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km maskmap=state@2km tension=5 zmult=30 smooth=0.05 cellout=p0_r_t5_z30_s05 
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km maskmap=state@2km tension=5 zscale=30 smooth=0.05 cellout=p0_r_t5_z30_s05 
r.info p0_r_t5_z30_s05
r.stats -p p0_r_t5_z30_s05
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km maskmap=state@2km tension=5 zscale=1 smooth=0.05 cellout=p0_r_t5_z1_s05 
r.stats -p p0_r_t5_z1_s05
v.out.ascii input=ratio columns=p0_ratio
v.out.ascii input=ratio columns=p0_ratio | less
r.info Z@2km
r.stats -p p0_r_t5_z30_s05
r.stats -c p0_r_t5_z30_s05
r.stats  p0_r_t5_z30_s05
r.stats --help
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km maskmap=state@2km tension=5 zscale=0 smooth=0.05 cellout=p0_r_t5_z0_s05 
r.stats  p0_r_t5_z0_s05
r.stats -c  p0_r_t5_z0_s05
r.stats -c  p0_r_t5_z30_s05
r.stats -c  state@2km
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 cellout=p0_r_t5_z30_s05 

v.vol.rst --help
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 elevation=p0_r_t5_z30_s05 dmin=5 
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 elevation=p0_r_t5_z30_s05 dmin=0.001
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 elevation=p0_r_t5_z30_s05 

g.region -p
g.region -d b=-100 t=2500 tbres=1000;
g.region -p
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 cellout=p0_r_t5_z30_s05 
v.out.ascii input=ratio columns=p0_ratio | less
g.list rast
r.mask --help
r.mask -r
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 cellout=p0_r_t5_z30_s05 

g.region -p
g.region -d b=-100 t=2500 tbres=1000;
g.region -p
g.region --help
g.region -p -3
g.region -d b=-100 t=2500 tbres=10;


g.region -p -3
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 smooth=0.05 cellout=p0_r_t5_z30_s05 
r.info Z@2km
v.info ratio
v.info --help ratio
v.in.ascii --overwrite x=1 y=2 z=3 input=spatial_station_ratio.csv output=ratio format=point separator=, columns='station_id int,x double precision,y double precision,z double precision, p0_ratio double precision,p1_ratio double precision'
v.info --help ratio
v.info ratio
v.in.ascii --overwrite x=2 y=3 z=4 input=spatial_station_ratio.csv output=ratio format=point separator=, columns='station_id int,x double precision,y double precision,z double precision, p0_ratio double precision,p1_ratio double precision'
v.info ratio
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 maskmap=state@2km smooth=0.05 cellout=p0_r_t5_z30_s05 
r.info p0_r_t5_z30_s05
r.stats -c p0_r_t5_z30_s05
g.region -d b=-100 t=2500 tbres=1000;
g.region -p -3
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 maskmap=state@2km smooth=0.05 cellout=foo
r.stats -c foo,
r.stats -c p0_r_t5_z30_s05,foo
v.vol.rst --overwrite cross_input=ratio wcolumn=p0_ratio cellinp=Z@2km tension=5 zscale=30 maskmap=state@2km smooth=0.05 cross_output=foo
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cross_input=Z@2km tension=5 zscale=30 maskmap=state@2km smooth=0.05 cross_output=foo
v.vol.rst --overwrite input=ratio wcolumn=p0_ratio cross_input=Z@2km tension=5 zscale=30 maskmap=state@2km smooth=0.05 cross_output=p0_r_t5_z30_s05 dmin=5
r.stats -c p0_r_t5_z30_s05,foo
d.mon start=x0
d.mon start=wx0
r.info
d.mon start=x0
d.mon --ui
d.mon -l
g.list rast
g.list rast | cat -
d.rast p0_r_t5_z30_s05
r.out.gdal input=p0_r_t5_z30_s05 output=foo.png
file foo.png 
r.out.gdal input=p0_r_t5_z30_s05 --help output=foo.png
r.out.gdal input=p0_r_t5_z30_s05 format=PNG output=foo.png
rm foo.png 
r.out.gdal input=p0_r_t5_z30_s05 format=PNG output=foo.png
r.out.gdal input=p0_r_t5_z30_s05 format=PNG type=UInt16 output=foo.png
r.out.gdal input=p0_r_t5_z30_s05 output=foo.tif
r.out.gdal input=p0_r_t5_z30_s05 format=PNG type=UInt16 output=foo.png
r.out.gdal input=p0_r_t5_z30_s05 format=PNG type=UInt16 output=foo.png -f
r.out.gdal input=p0_r_t5_z30_s05 format=PNG type=UInt16 output=foo.png --overwrite
d.mon start=x0
d.mon start=wx0
g.list vect
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=,\                                             
columns='station_id int,x double precision,y double,z double, \                                                                              
station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,lt_p0_ratio double,s_p0_ratio double' 
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=,columns='station_id int,x double precision,y double,z double,station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,lt_p0_ratio double,s_p0_ratio double'
less ~/lt_s_ratio.csv 
less ~/lt_s_ratio.csv 
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=,columns='station_id int,x double precision,y double,z double,station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,lt_p0_ratio double,s_p0_ratio double'
head ~/lt_s_ratio.csv 
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=,columns='station_id int,x double precision,y double,z double,station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,lt_p0_ratio double,s_p0_ratio double'
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=, columns='station_id int,x double precision,y double,z double,station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,lt_p0_ratio double,s_p0_ratio double'
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=, columns='station_id int,x double precision,y double,z double,station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,lt_p0_ratio double,s_p0_ratio double'
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=, columns='station_id int,x double precision,y double,z double,station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,r_p0 double,lt_p0_ratio double,s_p0_ratio double'
v.in.ascii --overwrite input=~/lt_s_ratio.csv x=2 y=3 z=4 output=ratio format=point separator=, columns='station_id int,x double precision,y double,z double,station_overlap_yrs double,s_p0 double,s_r_p0 double,lt_p0 double,r_p0 double,lt_p0_ratio double,s_p0_ratio double'
g.list type=rast
g.list type=rast
g.remove type=rast pattern=*z*
g.remove -f type=rast pattern=*z*
cd splines/
ls
rm *
export GRASS_RENDER_WIDTH=510;                                                                                                               
export GRASS_RENDER_HEIGHT=560;                                                                                                              
g.region -d b=-100 t=2500 tbres=1000;                                                                                                        
for r in s lt; do                                                                                                                             for s in 0 0.02; do                                                                                                                           for z in 0.1 ; do                                                                                                                             for t in 3 5 7 10; do                                                                                                                          p0=${r}_s${s}_z${z}_t${t}_p0                                                                                                                ;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5;                                                                                                                    r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)";                                                                                              r.colors map=r${p0} color=gyr;                                                                                                                export GRASS_RENDER_FILE="${p0}.png"                                                                                                        ;  d.mon --overwrite start=png                                                                                                                 ;  d.erase; #sleep 2;                                                                                                                            d.rast r${p0};                                                                                                                                d.legend title="${p0}" raster=r${p0}                                                                                                        ;  d.mon stop=png                                                                                                                              ; done;done;done;done 2>&1 | tee vol.rst.txt  
ls
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr;                                                                                                                export GRASS_RENDER_FILE="${p0}.png"                                                                                                        ;  d.mon --overwrite start=png                                                                                                                 ;  d.erase; #sleep 2;                                                                                                                            d.rast r${p0};                                                                                                                                d.legend title="${p0}" raster=r${p0}                                                                                                        ;  d.mon stop=png                                                                                                                              ; done;done;done;done 2>&1 | tee vol.rst.txt  
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; #sleep 2; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt   done; "
ls
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; #sleep 2; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt   done; "
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; #sleep 2; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt   done;
ls
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; #sleep 2; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt 
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; #sleep 2; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt 
v.out.ascii input=ratio columns=p0_ratio | less
v.out.ascii input=ratio columns=s_p0_ratio,lt_p0_ratio | less
v.out.ascii input=ratio columns=s_p0_ratio,lt_p0_ratio | wc -l
v.out.ascii input=ratio columns=s_p0_ratio,lt_p0_ratio where="s_p0_ratio is not null" 
v.out.ascii input=ratio columns=s_p0_ratio,lt_p0_ratio where="s_p0_ratio is not null"  | wc -l
v.out.ascii input=ratio columns=s_p0_ratio where="s_p0_ratio is not null"  | v.in.ascii seperator='|' columns="x double,y double,z double,s_p0_ratio double" output=s_ratio
v.out.ascii input=ratio columns=s_p0_ratio where="s_p0_ratio is not null"  | v.in.ascii input=- seperator='|' columns="x double,y double,z double,s_p0_ratio double" output=s_ratio
v.out.ascii input=ratio columns=s_p0_ratio where="s_p0_ratio is not null"  | v.in.ascii input=- separator='|' columns="x double,y double,z double,s_p0_ratio double" output=s_ratio
v.out.ascii input=ratio columns=station_id,s_p0_ratio where="s_p0_ratio is not null"  | v.in.ascii input=- separator='|' columns="x double,y double,z double,station_id int,s_p0_ratio double" output=s_ratio
v.out.ascii input=ratio columns=station_id,s_p0_ratio where="s_p0_ratio is not null"  
v.out.ascii input=ratio columns=s_p0_ratio where="s_p0_ratio is not null"  
v.out.ascii --hrelp
v.out.ascii --help
v.out.ascii input=ratio where="s_p0_ratio is not null"  
v.out.ascii input=ratio columns=station_id where="s_p0_ratio is not null"  
v.out.ascii input=ratio columns=station_id,s_p0_ratio where="s_p0_ratio is not null"  | v.in.ascii input=- separator='|' columns="x double,y double,z double,foo int,station_id int,s_p0_ratio double" output=s_ratio
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null"  | v.in.ascii input=- separator='|' columns="x double,y double,z double,foo int,station_id int,lt_p0_ratio double" output=lt_ratio
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=${r}_ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt 
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null" 
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null"  | v.in.ascii --overlap x=1 y=2 z=3 input=- separator='|' columns="x double,y double,z double,foo int,station_id int,lt_p0_ratio double" output=lt_ratio
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null"  | v.in.ascii --overlap x=1 y=2 z=3 input=- separator='|' columns="x double,y double,z double,foo int,station_id int,lt_p0_ratio double" output=lt_ratio
v.in.ascii --help
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null"  | v.in.ascii --overwrite x=1 y=2 z=3 input=- separator='|' columns="x double,y double,z double,foo int,station_id int,lt_p0_ratio double" output=lt_ratio
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="s_p0_ratio is not null"  | v.in.ascii --overwrite x=1 y=2 z=3 input=- separator='|' columns="x double,y double,z double,foo int,station_id int,s_p0_ratio double" output=s_ratio
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="s_p0_ratio is not null"  | less
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="s_p0_ratio is not null"  | less
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null"  | less
v.out.ascii input=ratio columns=station_id,s_p0_ratio where="s_p0_ratio is not null"  | v.in.ascii --overwrite x=1 y=2 z=3 input=- separator='|' columns="x double,y double,z double,foo int,station_id int,s_p0_ratio double" output=s_ratio
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null"  | v.in.ascii --overwrite x=1 y=2 z=3 input=- separator='|' columns="x double,y double,z double,foo int,station_id int,s_p0_ratio double" output=lt_ratio
v.out.ascii input=ratio columns=station_id,lt_p0_ratio where="lt_p0_ratio is not null"  | v.in.ascii --overwrite x=1 y=2 z=3 input=- separator='|' columns="x double,y double,z double,foo int,station_id int,s_p0_ratio double" output=lt_ratio

for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null"; r.mapcalc --overwrite expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt 
ls -lrt
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} dmin=5 where="${r}_p0_ratio is not null and station_overlap_yrs > 5"; r.mapcalc --overwrite expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt 
ls 
less vol.rst.txt 
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} where="${r}_p0_ratio is not null and station_overlap_yrs > 5"; r.mapcalc --overwrite expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt 
less vol.rst.txt 
for r in s lt; do for s in 0 0.02; do for z in 0.1 ; do for t in 3 5 7 10; do p0=${r}_s${s}_z${z}_t${t}_p0;  v.vol.rst --overwrite input=ratio wcolumn=${r}_p0_ratio  cross_input=Z@2km maskmap=state@2km tension=${t} zscale=${z} smooth=${s}  cross_output=${p0} where="${r}_p0_ratio is not null and station_overlap_yrs > 4"; r.mapcalc --overwrite expression="r${p0}=if($p0>0.8,$p0,1)"; r.colors map=r${p0} color=gyr; export GRASS_RENDER_FILE="${p0}.png"; d.mon --overwrite start=png;  d.erase; d.rast r${p0}; d.legend title="${p0}" raster=r${p0};d.mon stop=png; done;done;done;done 2>&1 | tee vol.rst.txt 
g.gisenv
d.mon select=wx0
d.mon stop=wx0
d.mon start=wx0
g.list type=rast
g.list type=rast
d.rast rlt_s0_z0.1_t10_p0
d.mon stop=wx0
d.mon start=wx0
d.rast rlt_s0_z0.1_t10_p0
d.vect ratio
d.what.vect
d.what.vect map=ratio
d.rast
d.erase
d.rast rlt_s0.02_z0.1_t3_p0
g.mapsets
g.mapsets -l
g.list type=rast mapset=quinn
cd ~/eto-zone-maps
ls
cd fft
ls
grep raster_stats *
less yearly_zones.sql 
less raster.sql 
d.vect ratio
d.erase
d.rast rlt_s0_z0.1_t10_p0
d.vect ratio
r.in.ascii --help
r.in.ascii input=~/p0.csv output=p0 type=FCELL
g.region pd
g.region -d
g.region -p
pwd
pwd
cd ../station_comparisons/
ls
less station_average_15day.csv 
cd ..
ls
less zone_style.qml 
less zone_each.json 
ls geojson
find . -name \*.sql | xargs grep eto_zones
cd tif
ls
less Makefile
cd ..
ls
find . -name zones.tif
find . -name \*.sql | xargs grep eto_zones
less fft/raster.sql 
find . -name \*.org | xargs grep eto_zones
find . -name \*.org | xargs grep eto_zones.geojson
find . -name \*.org | xargs grep eto_zones.json
find . -name \*.org
find . -name \*.md
cd fft
less classification.md 
ls
cd ..
ls
cat zone_style.qml 
ls
rm zone_style.qml 
cd earthengine/
ls
cd ..
ls
less eto_zones.csv 
wc -l eto_zones.csv
wc -l eto_zones.err
less eto_zones.err 
less final_zones.sql 
find . -name \*.sql
find . -name \*.sql | grep zones_map
find . -name \*.sql | xargs grep zones_map
find . -name \*.org | xargs grep zones_map
find . -type f | xargs grep zones_map
find . -type f | xargs grep final_zones
cat src/final_zones.vrt
ls src
find . -type f | xargs grep no_sliver
find . -type f | xargs grep final_zones
find . -type f | xargs grep final_zone_parameters
find . -type f | xargs grep VALUES
less station_comparisons/sql/regression.sql 
ls -lrt
head -100 zone_map_color.csv > foo.csv
head -1 zone_map_color.csv > bar.csv
tail --help
head +101 zone_map_color.csv >> bar.csv
head -n +101 zone_map_color.csv >> bar.csv
wc -l bar.csv 
head -2 bar.csv 
head -3 bar.csv 
wc -l bar.csv 
less bar.csv 
wc bar.csv
wc -l bar.csv 
wc -l zone_map_color.csv 
wc -l foo.csv
tail --help
head -1 zone_map_color.csv 
head -1 zone_map_color.csv  > bar.csv 
cat bar.csv 
head -n+101 zone_map_color.csv  >> bar.csv 
head -1 zone_map_color.csv  > bar.csv 
tail -n+101 zone_map_color.csv  >> bar.csv 
head -35 bar.csv >> b1.csv
head -1 bar.csv > b2.csv
tail -n+36  bar.csv >> b2.csv
ls
ls -lrt
rm foo.csv bar.csv b1.csv b2.csv 
ls
ls -lrt
head zone_map_color.csv 
head -2 zone_map_color.csv | sed -e 's/\.(....)[\d]+[ ,]/.\1/g'
head -2 zone_map_color.csv | sed -e 's/\.\(....\)[\d]+[ ,]/.\1/g'
head -2 zone_map_color.csv | sed -e 's/\.\(....\)[0123456789]+[ ,]/.\1/g'
head -2 zone_map_color.csv | perl -p 's/\.\(....\)[0123456789]+[ ,]/.\1/g'
head -2 zone_map_color.csv | perl -p -e 's/\.\(....\)[0123456789]+[ ,]/.\1/g'
head -2 zone_map_color.csv | perl -p -e 's/\.(\d\d\d\d)[\d]+[ ,]/.\1/g'
head -2 zone_map_color.csv | perl -p -e 's/\.(\d\d\d\d)[\d]+( ,)/.\1\2/g'
head -2 zone_map_color.csv | perl -p -e 's/\.(\d\d\d\d)[\d]+([ ,])/.\1\2/g'
perl -p -e 's/\.(\d\d\d\d)[\d]+([ ,])/.\1\2/g' < zone_map_color.csv > zmc.csv
C
r.in.xyz --help
r.in.xyz --help | less
r.in.xyz --help 2>&1 | less
g.gisenv
g.list type=rast
psql -At -d eto_zones -e 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10;'
psql -At -d eto_zones -f 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10;'
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10;'
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10;'
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10' | r.in.xyz --help
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10' | r.in.xyz separator='|' input=- output=foo 
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10' | r.in.xyz --help 2>&1 | less
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10' | r.in.xyz separator='|' input=- method=min output=foo 
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east limit 10' | r.in.xyz separator='|' input=- method=min output=foo --overwrite
r.stats foo
r.stats foo -c
r.stats foo -1
r.stats foo -1 -n
r.info foo
psql -At -d eto_zones -c 'select east,north,e[1] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east' | r.in.xyz separator='|' input=- method=min output=eto_p0 --overwrite
psql -At -d eto_zones -c 'select east,north,e[2] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east' | r.in.xyz separator='|' input=- method=min output=eto_p1 --overwrite
psql -At -d eto_zones -c 'select east,north,d[2] from fft.raster_15avg_ed join cimis_boundary using (pid) order by north,east' | r.in.xyz separator='|' input=- method=min output=eto_d1 --overwrite
r.info eto_d1
r.info eto_p0
g.region -d                                                                                                                                                    
for r in s lt; do                                                                                                                                               for s in 0 0.02; do                                                                                                                                             for z in 0.1 ; do                                                                                                                                               for t in 3 5 7 10; do                                                                                                                                            p0=${r}_s${s}_z${z}_t${t}_p0;                                                                                                                                   echo r.mapcalc p0_${p0}=${p0}*et0_p0;                                                                                                                          done;done;done;done            
g.region -d                                                                                                                                                    
for r in s lt; do                                                                                                                                               for s in 0 0.02; do                                                                                                                                             for z in 0.1 ; do                                                                                                                                               for t in 3 5 7 10; do                                                                                                                                            p0=${r}_s${s}_z${z}_t${t}_p0;                                                                                                                                   r.mapcalc p0_${p0}=${p0}*et0_p0;                                                                                                                               done;done;done;done       
g.list type=rast
g.region -d                                                                                                                                                    
for r in s lt; do                                                                                                                                               for s in 0 0.02; do                                                                                                                                             for z in 0.1 ; do                                                                                                                                               for t in 3 5 7 10; do                                                                                                                                            p0=${r}_s${s}_z${z}_t${t}_p0;                                                                                                                                   r.mapcalc p0_${p0}=${p0}*eto_p0;                                                                                                                               done;done;done;done         
d.mon start=x0
d.mon start wx0
d.mon start=wx0
d.rast eto_p0
r.colors map=eto_p0 color=grey
d.rast eto_p0
d.erase
d.rast eto_p0
r.colors --help
r.colors --help | less
r.colors --help 2>&1 | less
pwd
cd eto-zone-maps/gdb/cimis/quinn/colr
cat eto_p0
ls
cd ..
ls
ls colr2
fidn . -name p0_et0
find . -name eto+_p0
find . -name eto_p0
cd ../ratio/
cd colr
cat eto_p0 
emacs eto_p0 
vi eto_p0 
d.erase
for r in s lt; do                                                                                                                                               for s in 0 0.02; do                                                                                                                                             for z in 0.1 ; do                                                                                                                                               for t in 3 5 7 10; do                                                                                                                                            p0=${r}_s${s}_z${z}_t${t}_p0; r.colors map=${p0} rast=eto_p0;                                                                                                                               done;done;done;done         
d.rast eto_p0
d.mon start=wx1
d.rast p0_s0_z0.1_t7_p0
for r in s lt; do                                                                                                                                               for s in 0 0.02; do                                                                                                                                             for z in 0.1 ; do                                                                                                                                               for t in 3 5 7 10; do                                                                                                                                            p0=${r}_s${s}_z${z}_t${t}_p0; r.colors map=p0_${p0} rast=eto_p0;                                                                                                                               done;done;done;done         
for r in s lt; do                                                                                                                                               for s in 0 0.02; do                                                                                                                                             for z in 0.1 ; do                                                                                                                                               for t in 3 5 7 10; do                                                                                                                                            p0=${r}_s${s}_z${z}_t${t}_p0; r.colors map=${p0} color=grey; done;done;done;done         
d.rast p0_s_s0_z0.1_t7_p0
d.rast p0_s_s0_z0.1_t5_p0
d.mon start=wx2
d.rast p0_s_s0.02_z0.1_t5_p0
d.rast stop=wx2
d.mon stop=wx2
d.mon startwx0
d.mon start wx0
d.mon start=wx0
d.mon stop=wx2
d.mon stop=wx1
d.mon stop=wx0
d.mon start=wx0
d.mon start=wx1
d.mon start=wx2
d.mon select=wx0
g.list rast
d.rsat eto_p0
d.rast eto_p0
g.list rast
d.rast p0_lt_s0_z0.1_t7_p0
d.mon select=wx1
d.rast p0_lt_s0_z0.1_t7_p0
d.mon select=wx0
d.rast eto_p0
r.out.gdal --help
r.out.gdal input=eto_p0 output=eto_p0.png
d.rast p0_s_s0_z0.1_t7_p0
d.rast eto_p0
d.mon select=wx1
d.rast p0_s_s0_z0.1_t7_p0
r.out.gdal input=p0_s_s0_z0.1_t7_p0 output=eto_s_s0_z0.1_t7_p0.png
pwd
ls
pwd
find . -name eto\*.png
g.list rast
r.out.xyz 
r.out.xyz input=s_s0_z0.1_t7
g.list rast
r.out.xyz input=s_s0_z0.1_t7_p0
ls -lrt
cd eto-zone-maps
ls
cd splines/
ls
cd ../station_comparisons/
ls
ls -lrt
ls -lrt
r.out.xyz input=s_s0_z0.1_t7_p0,s_0.02_z0.1_t5
r.out.xyz input=s_s0_z0.1_t7_p0,s_0.02_z0.1_t5_p0
r.out.xyz input=s_s0_z0.1_t7_p0,s_0.02_z0.1_t5_p0
g.list rast
r.out.xyz input=s_s0_z0.1_t7_p0,s_s0.02_z0.1_t5_p0
r.out.xyz separtor=',' input=s_s0_z0.1_t7_p0,s_s0.02_z0.1_t5_p0
r.out.xyz separator=',' input=s_s0_z0.1_t7_p0,s_s0.02_z0.1_t5_p0
r.out.xyz separator=',' input=s_s0_z0.1_t7_p0,s_s0.02_z0.1_t5_p0 --help
r.out.xyz separator=',' input=s_s0_z0.1_t7_p0,s_s0.02_z0.1_t5_p0 output=spline_ratios.csv
head spline_ratios.csv 
g.gisenv
ls gdb
ls gdb/cimis
g.list type=rast mapset=quinn
g.gisenv
psql -At -d eto_zones -c 'select east,north,v from cimis_boundary join compare.station_adjusted_pixel_zones using (pid) join avg_0625.final_zone_parameters using (zone,zones) where zones=16 and spline='s0_z0.1_t7' |\
 r.in.xyz separator='|' input=- method=min output=adjusted_zone --overwrite
psql -At -d eto_zones -c "select east,north,v from cimis_boundary join compare.station_adjusted_pixel_zones using (pid) join avg_0625.final_zone_parameters using (zone,zones) where zones=16 and spline='s0_z0.1_t7'" | r.in.xyz separator='|' input=- method=min output=adjusted_zone --overwrite
psql -At -d eto_zones -c "select fft.require_fft(); select east,north,v from cimis_boundary join compare.station_adjusted_pixel_zones using (pid) join avg_0625.final_zone_parameters using (zone,zones) where zones=16 and spline='s0_z0.1_t7'" | r.in.xyz separator='|' input=- method=min output=adjusted_zone --overwrite
r.colors map=adjusted_zone color=random
r.info adjusted_zone
psql -At -d eto_zones -c "select fft.require_fft(); select east,north,v from cimis_boundary join compare.station_adjusted_pixel_zones using (pid) join avg_0625.final_zone_parameters using (zone,zones) where zones=16 and spline='s0_z0.1_t7'" | r.in.xyz separator='|' input=- method=min output=adjusted_zone --overwrite
r.in.xyz --help
psql -At -d eto_zones -c "select fft.require_fft(); select east,north,v from cimis_boundary join compare.station_adjusted_pixel_zones using (pid) join avg_0625.final_zone_parameters using (zone,zones) where zones=16 and spline='s0_z0.1_t7'" | r.in.xyz separator='|' type=CELL input=- method=min output=adjusted_zone --overwrite
r.info adjusted_zone
r.colors map=adjusted_zone color=random
d.rast adjusted_zone
d.mon start=wx0
d.mon start=wx1
d.rast adjusted_zone
d.erase
d.rast adjusted_zone
d.mon select=wx0
d.mon start=wx0
d.rast final_zones
psql -At -d eto_zones -c 'select east,north,v from final_zones_pixels using (pid)' | r.in.xyz separator='|' input=- method=min output=final_zones --overwrite
psql -At -d eto_zones -c 'select east,north,v from final_zones_pixels' | r.in.xyz separator='|' input=- method=min output=final_zones --overwrite
psql -At -d eto_zones -c 'select east,north,val from final_zones_pixels' | r.in.xyz separator='|' input=- method=min output=final_zones --overwrite
r.colors rast=adjusted_zone map=final_zones
d.rast final_zones
d.mon select=wx1
d.mon select=wx0
d.rast final_zones
d.erase
d.mon stop=wx0
d.mon start=wx0
d.rast final_zones
d.what.rast
d.what.rast final_zones
d.what.rast final_zones
d.what final_zones
d.where 
d.erase
d.rast final_zones
d.erase
d.rast final_zones
d.mon select=wx1
d.rast adjusted_zones
d.rast final_zones
r.stats final_zones
r.stats -c final_zones
r.info final_zones
g.remove final_zones;
g.remove rast=final_zones;
g.remove name=final_zones
g.remove name=final_zones type=rast
g.remove f name=final_zones type=rast
g.remove -f name=final_zones type=rast
r.in.xyz --help
psql -At -d eto_zones -c 'select east,north,val from final_zones_pixels' | r.in.xyz separator='|' input=- method=min output=final_zones type=CELL --overwrite
r.colors rast=adjusted_zone map=final_zones
d.rast final_zones
d.erase
d.rast final_zones
d.mon select=wx0
d.erase
d.rast adjusted_zones
d.rast adjusted_zone
psql -At -d eto_zones -c 'select east,north,v from cimis_boundary join avg_0625.total_move_rmse_min using (pid) join avg_0625.final_zone_parameters using (zone,zones) where zones=16 |\
 r.in.xyz separator='|' input=- method=min output=computed_zones type=CELL --overwrite

'
psql -At -d eto_zones -c 'select east,north,v from cimis_boundary join avg_0625.total_move_rmse_min using (pid) join avg_0625.final_zone_parameters using (zone,zones) where zones=16' | r.in.xyz separator='|' input=- method=min output=computed_zones type=CELL --overwrite
psql -At -d eto_zones -c 'select east,north,v from cimis_boundary join avg_0625.total_move_rmse_min using c (pid) join avg_0625.final_zone_parameters z on  (c.zone_id=z.zone and c.zones=z.zones) where zones=16' | r.in.xyz separator='|' input=- method=min output=computed_zones type=CELL --overwrite
psql -At -d eto_zones -c 'select east,north,v from cimis_boundary join avg_0625.total_move_rmse_min c using (pid) join avg_0625.final_zone_parameters z on  (c.zone_id=z.zone and c.zones=z.zones) where zones=16' | r.in.xyz separator='|' input=- method=min output=computed_zones type=CELL --overwrite
psql -At -d eto_zones -c 'select east,north,v from cimis_boundary join avg_0625.total_move_rmse_min c using (pid) join avg_0625.final_zone_parameters z using  (zone_id,zones) where zones=16' | r.in.xyz separator='|' input=- method=min output=computed_zones type=CELL --overwrite
psql -At -d eto_zones -c 'select fft.require_fft(); select east,north,v from cimis_boundary join avg_0625.total_move_rmse_min c using (pid) join avg_0625.final_zone_parameters z using  (zone_id,zones) where zones=16' | r.in.xyz separator='|' input=- method=min output=computed_zones type=CELL --overwrite
d.mon select=wx1
r.colors map=computed_zones rast=final_zones
d.rast computed_zones
r.out.png rast=final_zones output=final_zones.png
r.out.png --help
file /usr/lib/grass72/bin/r.out.png 
ls -l /usr/lib/grass72/bin/r.out.png 
ls -l /usr/lib/grass72/bin/r.out.*
r.out.gdal rast=final_zones output=final_zones.png
r.out.gdal rast=final_zones format=PNG output=final_zones.png
r.out.gdal input=final_zones format=PNG output=final_zones.png
r.out.gdal input=computed_zones format=PNG output=computed_zones.png
r.out.gdal input=adjusted_zones format=PNG output=adjusted_zones.png
r.out.gdal input=adjusted_zones format=PNG output=adjusted_zones.png
g.list rast
g.rename adjusted_zone,adjusted_zones
r.out.gdal input=adjusted_zones format=PNG output=adjusted_zones.png
g.mapset PERMANENT
v.build.all 
g.mapset quinn
v.build.all 
g.mapset ratio
v.build.all 
g.mapset 2018-02-01
g.list rast
r.info U2
g.region -d
r.info U2
g.info
r.info info=proj
cd ..
g.gisenv
