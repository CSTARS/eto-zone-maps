\set package fft
\set js `cat fft.js`

drop type fft_t;
create type fft_t as (
 e float[],
 d float[],
 re float[],
 im float[]
);

CREATE OR REPLACE FUNCTION statewide()
RETURNS float[] AS $$
return fft.statewide();
$$ LANGUAGE plv8 IMMUTABLE STRICT;

-- No Anonymous types
--CREATE OR REPLACE FUNCTION fftt
--(in et float[],out e float[],out d float[])
--AS $$
--var f=fft.fft(et);
--return {e:f.E,d:f.D};
--$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION fft
(in et float[])
RETURNS fft_t AS $$
return fft.fft(et);
$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION ifft
(e float[],d float[],n integer)
RETURNS float[] AS $$
return fft.ifft(e,d,n);
$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION et
(e float[],d float[],day float)
RETURNS float AS $$
return fft.et(e,d,day);
$$ LANGUAGE plv8 IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION cum_et
(e float[],d float[],day integer)
RETURNS float AS $$
return fft.cum_et(e,d,day);
$$ LANGUAGE plv8 IMMUTABLE STRICT;


CREATE or replace function init_injector(prefix text,js text)
RETURNS TEXT
LANGUAGE PLPGSQL AS $PL$
begin
EXECUTE FORMAT($FORMAT$
CREATE OR REPLACE FUNCTION require_%1$s() RETURNS VOID AS $INIT_FUNCTION$
%1=%2$s
$INIT_FUNCTION$ LANGUAGE plv8 IMMUTABLE STRICT;
$FORMAT$,prefix,js);
return 'require_'||prefix;
end
$PL$;


select init_injector(:'package',:'js');
drop function init_injector(prefix text,js text);
