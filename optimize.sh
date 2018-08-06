#!/bin/bash
CSI="\\033["
CEND="${CSI}0m"
CGREEN="${CSI}1;32m"

##################################
# Welcome
##################################



echo ""
echo "Welcome to optimize.sh image optimization script."
echo ""

echo ""
echo "Do you want to optimize all jpg images in "$1" ? (y/n)"
while [[ $jpg != "y" && $jpg != "n" ]]; do
    read -p "Select an option [y/n]: " jpg
done
echo ""
echo "Do you want to optimize all png images in "$1" (it may take a while) ? (y/n)"
while [[ $png != "y" && $png != "n" ]]; do
    read -p "Select an option [y/n]: " png
done
echo ""
echo "Do you want to convert all jpg & png images to WebP in "$1" ? (y/n)"
while [[ $webp != "y" && $webp != "n" ]]; do
    read -p "Select an option [y/n]: " webp
done

# optimize jpg
jpgoptimize() {
find $1 -iname "*.jpg" -o -iname "*.jpeg" -print0 | xargs -0 jpegoptim --preserve --quiet --strip-all -m82 

        echo -ne "       jpg optimization                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"
}
# optimize png
pngoptimize() {
find $1 -iname '*.png' -print0 | xargs -0 optipng -o7 -strip all -quiet 

        echo -ne "       png optimization                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"
}
# convert png to webp
webpconvert() {
find $1 -iname "*.png" -print0 | xargs -0 -I {}  \
bash -c 'webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -quiet -z 9 -mt {} -o {}.webp; }
fi' 

        echo -ne "       png to webp conversion                      [${CGREEN}OK${CEND}]\\r"
        echo -ne "\\n"

# convert jpg to webp
find $1 -iname "*.jpg" -o -iname "*.jpeg" -print0 | xargs -0 -I {} \
bash -c 'webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -quiet -q 82 -mt {} -o {}.webp; }
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