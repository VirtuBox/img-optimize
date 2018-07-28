#!/bin/bash


# optimize jpg
find "$1" -iname "*.jp*" -print0 | xargs -0 jpegoptim --strip-all -m76

# optimize png
find "$1" -iname '*.png' -print0 | xargs -0 optipng -o7 -preserve

# convert png to webp
find "$1" -iname "*.png" -print0 | xargs -0 -I {}  \
bash -c '
webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -lossless {} -o {}.webp; }
fi'

# convert jpg to webp
find "$1" -iname "*.jp*" -print0 | xargs -0 -I {} \
bash -c '
webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -lossless {} -o {}.webp; }
fi'
