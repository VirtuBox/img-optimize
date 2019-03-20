#!/bin/bash

# install prerequisites
sudo apt-get install build-essential libpng-dev -y

# go into /usr/local/src and remove previous optipng folder/archive
cd /usr/local/src || exit 1
rm -rf optipng*

# get the latest optipng release link
OPTIPNGLATEST=$(wget http://optipng.sourceforge.net/ -O - | grep tar.gz | awk -F '["]' '{print $4}')

# download and extract optipng
wget $OPTIPNGLATEST -O optipng.tar.gz
tar -xf optipng.tar.gz
cd optipng-* || exit 1

# configure and compile optipng
./configure --prefix=/usr
make -j "$(nproc)"
sudo make install