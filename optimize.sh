#!/bin/bash
CSI="\\033["
CEND="${CSI}0m"
CGREEN="${CSI}1;32m"

### Set Bins Path ###

FIND=/usr/bin/find

##################################
# Welcome
##################################

imagepath="$1"

echo ""
echo "Welcome to optimize.sh image optimization script."
echo ""

echo ""
echo "Do you want to optimize jpg images ? (y/n)"
while [[ $jpg != "y" && $jpg != "n" ]]; do
    read -p "Select an option [y/n]: " jpg
done
echo ""
echo "Do you want to optimize png images ? (y/n)"
while [[ $png != "y" && $png != "n" ]]; do
    read -p "Select an option [y/n]: " png
done
echo ""
echo "Do you want to convert jpg & png images to WebP ? (y/n)"
while [[ $webp != "y" && $webp != "n" ]]; do
    read -p "Select an option [y/n]: " webp
done

# optimize jpg
jpgoptimize() {
$FIND  $imagepath -iname "*.jp*" -print0 | xargs -0 jpegoptim --quiet --strip-all -m76 

        echo -ne "       jpg optimization                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"
}
# optimize png
pngoptimize() {
$FIND $imagepath -iname '*.png' -print0 | xargs -0 optipng -o7 -quiet -preserve 

        echo -ne "       png optimization                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"
}
# convert png to webp
webpconvert() {
$FIND $imagepath -iname "*.png" -print0 | xargs -0 -I {}  \
bash -c 'webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -quiet -z 6 -mt {} -o {}.webp; }
fi' 

        echo -ne "       png to webp conversion                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"

# convert jpg to webp
$FIND $imagepath -iname "*.jp*" -print0 | xargs -0 -I {} \
bash -c 'webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -quiet -z 6 -mt {} -o {}.webp; }
fi'

        echo -ne "       jpg to webp conversion                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"
}

if [ "$jpg" = "y" ]
then
    jpgoptimize
fi
if [ "$png" = "y" ]
then
    pngoptimize
fi
if [ "$webp" = "y" ]
then
    webpconvert
fi

# We're done !
echo ""
echo -e "       ${CGREEN}Image optimization performed successfully !${CEND}"
echo ""