
-- Create required type
DROP TYPE IF EXISTS geohash CASCADE;
CREATE TYPE geohash AS (
	id  text,
	precision  int4,
	geom geometry
);

-- Usage:
-- SELECT st_geohashfromgeom(geom, 4) FROM siose_2005_castellon
DROP FUNCTION IF EXISTS st_geohashfromgeom;
CREATE OR REPLACE FUNCTION st_geohashfromgeom(geometry, integer) RETURNS SETOF geohash AS $$

WITH roi AS(
	SELECT $1 AS geom
), grid AS (
	SELECT (ST_RegularGrid(geom,0.02,0.02,false)).geom AS geom
	FROM roi
), intersecting_grid AS(
	SELECT grid.geom AS geom
	FROM roi, grid
	WHERE ST_Intersects(roi.geom,grid.geom)
), filtered_grid AS(
	SELECT DISTINCT ST_geohash(st_centroid(geom),$2) AS geohash, ST_geomfromgeohash(ST_geohash(st_centroid(geom)),$2) AS geom
	FROM intersecting_grid
)
SELECT (geohash,$2,geom)::geohash FROM filtered_grid;

$$ LANGUAGE SQL IMMUTABLE STRICT;

/*
DROP TABLE grd;
CREATE TABLE grd AS
WITH src AS(
	SELECT st_geohashfromgeom(geom, 4) AS geohash FROM siose_2005_castellon
)
SELECT (geohash).id, (geohash).precision, (geohash).geom FROM src;
*/
