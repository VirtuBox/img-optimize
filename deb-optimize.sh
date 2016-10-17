#!/bin/bash
echo ""
echo "Welcome to wp-optimize script"
echo ""
apt-get update &>/dev/null
apt-get install optipng jpegoptim -y &>/dev/null
cd /var/www
find . -name *.jp* | xargs jpegoptim --strip-all -m76
find . -iname '*.png' -print0 | xargs -0 optipng -o7 -preserve
echo ""
echo "Optimization Process done :)"
echo ""
