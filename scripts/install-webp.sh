#!/usr/bin/env bash
#----------------------------------------------------------------------------
#  img-optimize-  libwebp compilation script
#----------------------------------------------------------------------------
# Website:       https://virtubox.net
# GitHub:        https://github.com/VirtuBox/img-optimize
# Author:        VirtuBox
# License:       M.I.T
# ----------------------------------------------------------------------------

# install prerequisites
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install --assume-yes build-essential libjpeg-dev libpng-dev libtiff-dev libgif-dev libwebp-dev tar pigz curl

# get the latest release number
LATEST_WEBP=$(curl https://storage.googleapis.com/downloads.webmproject.org/releases/webp/index.html 2>&1 | grep ".tar.gz\"" | awk -F '["]' '{print $2}' | sort -r | head -n 1 2>&1)

# go into /usr/local/src and remove previous libwebp folder/archive
cd /usr/local/src || exit
rm -rf libwebp*

# download and extract latest libwebp sources
curl -sL "https:$LATEST_WEBP" | tar -I pigz -xf -
cd libwebp-* || exit

# configure libwebp and launch compilation
./configure
make -j "$(nproc)"
strip --strip-unneeded /usr/local/src/libwebp-*/examples/.libs/{cwebp,dwebp}
make install
ldconfig
