#!/usr/bin/env bash
#----------------------------------------------------------------------------
#  img-optimize-  optipng compilation script
#----------------------------------------------------------------------------
# Website:       https://virtubox.net
# GitHub:        https://github.com/VirtuBox/img-optimize
# Author:        VirtuBox
# License:       M.I.T
# ----------------------------------------------------------------------------

# install prerequisites
export DEBIAN_FRONTEND=noninteractive
apt update && apt-get install --assume-yes build-essential libpng-dev zlib1g-dev curl pigz jpegoptim

# get the latest optipng release link
OPTIPNGLATEST=$(curl -sL optipng.sourceforge.net | grep tar.gz | awk -F '["]' '{print $4}')

# go into /usr/local/src and remove previous optipng folder/archive
cd /usr/local/src || exit 1
rm -rf optipng*

# download and extract optipng
curl -sL "$OPTIPNGLATEST" | tar -I pigz -xf -
cd optipng-* || exit 1

# configure and compile optipng
./configure
make -j "$(nproc)"
strip --strip-unneeded /usr/local/src/optipng-*/src/optipng/optipng
make install
ldconfig