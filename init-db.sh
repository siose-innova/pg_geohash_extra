#!/bin/bash -e

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

echo "Load extensions into $POSTGRES_DB"
for DB in "$POSTGRES_DB"; do

	"${psql[@]}" --dbname="$DB" <<-'EOSQL'

		CREATE EXTENSION IF NOT EXISTS postgis;
		CREATE SCHEMA s2005;
		CREATE SCHEMA s2011;
		CREATE EXTENSION IF NOT EXISTS pg_geohash_extra;

EOSQL
done



#############
# Load data #
#############

# Import sample data
#ogr2ogr -f "PostgreSQL" "PG:dbname=db schemas=public user=postgres password=postgres" "/data/castellon.shp" -lco GEOMETRY_NAME=geom -lco FID=gid -lco PRECISION=no -nlt PROMOTE_TO_MULTI -nln roi -overwrite
shp2pgsql -s 4326 /data/castellon.shp public.roi | psql -d db -U postgres


# Now restore using concurrent import
pg_restore -d db -U postgres -j 3 -O -x /data/dump2005-castellon


################
# Prepare data #
################
# Create a geohashes table from roi
"${psql[@]}" --dbname="$POSTGRES_DB" <<-'EOSQL'

CREATE TABLE gh AS
WITH src AS(
	SELECT st_geohashfromgeom(geom, 2) AS geohash FROM roi
	UNION
	SELECT st_geohashfromgeom(geom, 3) AS geohash FROM roi
	UNION
	SELECT st_geohashfromgeom(geom, 4) AS geohash FROM roi
	UNION
	SELECT st_geohashfromgeom(geom, 5) AS geohash FROM roi
)
SELECT (geohash).id, (geohash).precision, (geohash).geom FROM src;

EOSQL

