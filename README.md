# pg_geohash_extra

An extension for PostgreSQL that expands on the existing geohash functions. Generating the neighbours of a geohash and reverting a geometry back into geohashes are both simple functions that are not included in PostGIS.

## Installation

Installing the extension requires superuser access to the database. Additionaly PostGIS is required for wrapping the functions on the SQL side. To build the source run:

> make clean && make && sudo make install

Next up is installing the extension in Postgres.

CREATE EXTENSION pg_geohash_extra

## Use

Some additional functions will be added to PostgreSQL/PostGIS.

1. Exploding a geometry in geohashes
2. Finding all neighbours of a geohash
3. ...

Commands:
> geohashfromgeom(geometry, precision)

> geohash_neighbours(geohash)


## TODO

- geohash_it(geom,[precison_range]) function which accepts a range of precisions.
- Add some spatial statistics (such as representativeness, overlapping, etc).
- A geohash_it(geom,criteria,single/multiple precision) function. Meaning a list of geohashes, of a same or different precision, which better fit the input geometry.
- Operators, aggregates and geohash algebra (e.g. union, intersection, buffer, etc)
