#!/bin/bash

sudo apt-get install build-essential libpng-dev -y

cd /usr/local/src
rm -rf optipng*

OPTIPNGLATEST=$(wget http://optipng.sourceforge.net/ -O - | grep tar.gz | awk -F "[\"]" '{print $4}')
wget $OPTIPNGLATEST -O optipng.tar.gz
tar -xf optipng.tar.gz
cd optipng-*
./configure --prefix=/usr
make -j "$(nproc)"
sudo make install