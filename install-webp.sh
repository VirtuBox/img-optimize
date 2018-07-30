#!/bin/bash

# install prerequisites
sudo apt-get install build-essential libjpeg-dev libpng-dev libtiff-dev libgif-dev libwebp-dev -y

# go into /usr/local/src and remove previous libwebp folder/archive
cd /usr/local/src || exit
rm -rf libwebp*

# download and extract latest libwebp sources
wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.0.tar.gz -O libwebp.tar.gz
tar xvzf libwebp.tar.gz
cd libwebp-* || exit

# configure libwebp and launch compilation
./configure
make -j "$(nproc)"
sudo make install