#!/bin/bash

CGREEN="${CSI}1;32m"

# optimize jpg
find "$1" -iname "*.jp*" -print0 | xargs -0 jpegoptim --strip-all -m76 >> /tmp/image-optimization.log

        echo -ne "       jpg optimization                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"

# optimize png
find "$1" -iname '*.png' -print0 | xargs -0 optipng -o7 -preserve >> /tmp/image-optimization.log

        echo -ne "       png optimization                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"

# convert png to webp
find "$1" -iname "*.png" -print0 | xargs -0 -I {}  \
bash -c '
webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -lossless {} -o {}.webp; }
fi' >> /tmp/image-optimization.log

        echo -ne "       png to webp conversion                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"

# convert jpg to webp
find "$1" -iname "*.jp*" -print0 | xargs -0 -I {} \
bash -c '
webp_version="$0".webp

if [ ! -f "$webp_version" ]; then
{ cwebp -lossless {} -o {}.webp; }
fi' >> /tmp/image-optimization.log

        echo -ne "       jpg to webp conversion                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"

# We're done !
echo ""
echo -e "       ${CGREEN}Image optimization performed successfully !${CEND}"
echo ""
echo "       Conversion log : /tmp/image-optimization.log"