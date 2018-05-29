FROM sioseinnova/siose-2005:base

################################
# Install geohash from sources #
################################

WORKDIR /install-ext

ADD doc doc/
ADD sql sql/
ADD src src/
#ADD test test/
ADD Makefile Makefile
ADD META.json META.json
ADD pg_geohash_extra.control pg_geohash_extra.control

RUN make
RUN make install

WORKDIR /
RUN rm -rf /install-ext



ADD init-db.sh /docker-entrypoint-initdb.d/init-db.sh
