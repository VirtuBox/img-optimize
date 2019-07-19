#!/bin/bash

# install prerequisites
apt-get install build-essential libpng-dev zlib1g-dev curl pigz -y

# go into /usr/local/src and remove previous optipng folder/archive
cd /usr/local/src || exit 1
rm -rf optipng*

# get the latest optipng release link
OPTIPNGLATEST=$(curl -sL optipng.sourceforge.net | grep tar.gz | awk -F '["]' '{print $4}')

# download and extract optipng
wget $OPTIPNGLATEST -O optipng.tar.gz
tar -I pigz -xf optipng.tar.gz
cd optipng-* || exit 1

# configure and compile optipng
./configure --prefix=/usr
make -j "$(nproc)"
strip --strip-unneeded /usr/local/src/optipng-*/src/optipng/optipng
make install