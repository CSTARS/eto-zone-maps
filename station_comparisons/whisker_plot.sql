\set js `browserify --standalone=wp whisker_plot.js`

CREATE OR REPLACE FUNCTION whisker_plot
(wa whisker[],xlabel text[],height integer,all_outliers boolean)
RETURNS text AS $$
return wp.whisker_plot(wa,xlabel,height,all_outliers);
$$ LANGUAGE plv8 IMMUTABLE STRICT;


--CREATE OR REPLACE FUNCTION foo(wa whisker[]) RETURNS text AS $$
--return foo(wa);
--$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE or replace function init_injector(prefix text,js text)
RETURNS TEXT
LANGUAGE PLPGSQL AS $PL$
begin
EXECUTE FORMAT($FORMAT$
CREATE OR REPLACE FUNCTION require_%1$s() RETURNS VOID AS $INIT_FUNCTION$
%2$s
$INIT_FUNCTION$ LANGUAGE plv8 IMMUTABLE STRICT;
$FORMAT$,prefix,js);
return 'require_'||prefix;
end
$PL$;


select init_injector('wp',:'js');
drop function init_injector(prefix text,js text);
