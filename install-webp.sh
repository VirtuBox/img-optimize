#!/bin/bash

sudo apt-get install build-essential libjpeg-dev libpng-dev libtiff-dev libgif-dev libwebp-dev -y

cd /usr/local/src || exit
rm -rf libwebp*

wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.0.tar.gz -O libwebp.tar.gz
tar xvzf libwebp.tar.gz
cd libwebp-* || exit
./configure
make -j "$(nproc)"
sudo make install