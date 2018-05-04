

CREATE FUNCTION geohash_neighbours(IN text, OUT cstring) RETURNS SETOF cstring
AS 'MODULE_PATHNAME', 'geohash_neighbours' LANGUAGE C IMMUTABLE STRICT;
