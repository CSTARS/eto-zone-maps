CREATE OR REPLACE FUNCTION array_add(res numeric[],y numeric[])
RETURNS numeric[] AS
$$
DECLARE
b int;
i int;
BEGIN
b := array_upper (y, 1);

res[0] := coalesce(res[0]+1,0);

IF b IS NOT NULL THEN
  FOR i IN 1 .. b LOOP
    res[i] := coalesce(res[i],0) + y[i];
  END LOOP;
END IF;
RETURN res;
END;
$$
LANGUAGE plpgsql STRICT IMMUTABLE;

CREATE OR REPLACE FUNCTION array_div_0(res numeric[])
RETURNS numeric[] AS
$$
DECLARE
b int;
i int;
av numeric[];
BEGIN
b := array_upper (res, 1);

res[0] := coalesce(res[0]+1,0);

IF b IS NOT NULL THEN
  FOR i IN 1 .. b LOOP
    av[i] := coalesce(res[i],0)/res[0];
  END LOOP;
END IF;
RETURN av;
END;
$$
LANGUAGE plpgsql STRICT IMMUTABLE;


--- then this aggregate lets me sum integer arrays...

CREATE AGGREGATE array_avg (
sfunc = array_add,
finalfunc = array_div_0,
basetype = numeric[],
stype = numeric[],
initcond = '{}'
);
		
