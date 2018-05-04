FROM sioseinnova/postgis-ext

###################
# Install geohash #
###################
#github version
#WORKDIR /install-ext
#ENV GEOHASH https://github.com/siose-innova/pg_geohash_extra.git
#RUN git clone $GEOHASH
#WORKDIR /install-ext/pg_geohash_extra
#RUN make
#RUN make install

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

#################
# Download data #
#################
WORKDIR /data

RUN wget https://www.dropbox.com/s/d1rukoz1qv6ldu7/castellon.tar.gz \
&& tar zxvpf castellon.tar.gz && rm castellon.tar.gz

WORKDIR /


ADD init-db.sh /docker-entrypoint-initdb.d/init-db.sh
