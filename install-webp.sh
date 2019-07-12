#!/bin/bash

# install prerequisites
apt-get install build-essential libjpeg-dev libpng-dev libtiff-dev libgif-dev libwebp-dev tar gzip wget -y

# go into /usr/local/src and remove previous libwebp folder/archive
cd /usr/local/src || exit
rm -rf libwebp*

# download and extract latest libwebp sources
wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.2.tar.gz -O libwebp.tar.gz
tar xzf libwebp.tar.gz
cd libwebp-* || exit

# configure libwebp and launch compilation
./configure --prefix=/usr
make -j "$(nproc)"
strip --strip-unneeded /usr/local/src/libwebp-*/examples/.libs/{cwebp,dwebp}
make install
