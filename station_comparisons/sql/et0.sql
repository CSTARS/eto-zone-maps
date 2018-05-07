\set package et0
\set js `browserify --standalone=et0 et0.js`

drop type weather_t cascade;
create type weather_t as (
z float,
Tn float,
Tx float,
Tdew float,
U2 float,
Rs float,
Rnl float);

CREATE OR REPLACE FUNCTION Tm
("Tn" float,"Tx" float)
RETURNS float AS $$
return et0.Tm(Tn,Tx);
$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION P
(z float)
RETURNS float AS $$
return et0.P(z);
$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION et0
(w weather_t)
RETURNS float AS $$
return et0.et0(w.z,w.tn,w.tn,w.tdew,w.u2,w.rs,w.rnl);
$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION et0
(z float,"Tn" float,"Tx" float,"Tdew" float,"U2" float,"Rs" float,"Rnl" float)
RETURNS float AS $$
return et0.et0(z,Tn,Tx,Tdew,U2,Rs,Rnl);
$$ LANGUAGE plv8 IMMUTABLE STRICT;

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

select init_injector(:'package',:'js');
drop function init_injector(prefix text,js text);
