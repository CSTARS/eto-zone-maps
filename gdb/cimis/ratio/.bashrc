test -r ~/.alias && . ~/.alias
PS1='GRASS 7.4.0 (cimis):\w > '
grass_prompt() {
	LOCATION="`g.gisenv get=GISDBASE,LOCATION_NAME,MAPSET separator='/'`"
	if test -d "$LOCATION/grid3/G3D_MASK" && test -f "$LOCATION/cell/MASK" ; then
		echo [2D and 3D raster MASKs present]
	elif test -f "$LOCATION/cell/MASK" ; then
		echo [Raster MASK present]
	elif test -d "$LOCATION/grid3/G3D_MASK" ; then
		echo [3D raster MASK present]
	fi
}
PROMPT_COMMAND=grass_prompt
export PATH="/usr/lib/grass74/bin:/usr/lib/grass74/scripts:/home/quinn/.grass7/addons/bin:/home/quinn/.grass7/addons/scripts:/home/quinn/.rbenv/shims:/home/quinn/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
export HOME="/home/quinn"
