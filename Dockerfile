FROM ubuntu:xenial

RUN apt-get update
RUN apt install --yes apt-utils
ADD https://github.com/percona/percona-server/archive/Percona-Server-5.6.40-84.0.tar.gz /opt/Percona-Server-5.6.40-84.0.tar.gz
RUN tar xvzf /opt/Percona-Server-5.6.40-84.0.tar.gz -C /opt
RUN apt-get install --yes build-essential flex bison automake autoconf libtool cmake libaio-dev mysql-client libncurses-dev zlib1g-dev libgcrypt11-dev libev-dev libcurl4-gnutls-dev vim-common libreadline-dev
RUN cd /opt/percona-server-Percona-Server-5.6.40-84.0 && cmake . -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_CONFIG=mysql_release -DFEATURE_SET=community -DWITH_EMBEDDED_SERVER=OFF -DWITHOUT_TOKUDB=ON \
    && make \
    && make install
RUN sed -i.bak "s/version='5.6.40-84.0'/version='5.6.40'/g" /usr/local/mysql/bin/mysql_config
ADD . /opt/handler-socket
WORKDIR /opt/handler-socket
RUN mkdir -p -v /usr/lib/mysql/plugin
RUN ./autogen.sh
RUN ./configure --with-mysql-source=/opt/percona-server-Percona-Server-5.6.40-84.0 --with-mysql-bindir=/usr/local/mysql/bin/  --with-mysql-plugindir=/usr/lib/mysql/plugin/
RUN make
RUN make install
