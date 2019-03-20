#!/bin/bash
#----------------------------------------------------------------------------
#  img-optimize-  Image optimization bash script
#----------------------------------------------------------------------------
# Website:       https://virtubox.net
# GitHub:        https://github.com/VirtuBox/img-optimize
# Author:        VirtuBox
# License:       M.I.T
# ----------------------------------------------------------------------------
# Version 1.0 - 2019-03-20
# ----------------------------------------------------------------------------

#!/bin/bash
CSI='\033['
CEND="${CSI}0m"
CGREEN="${CSI}1;32m"


_help() {
    echo "Bash script to optimize your images and convert them in WebP "
    echo "Usage: img-optimize [options] <images path>"
    echo "If images path isn't defined, img-optimize will use the current directory "
    echo "  Options:"
    echo "       --jpg <images path> ..... optimize all jpg images"
    echo "       --png <images path> ..... optimize all png images"
    echo "       --webp <images path> ..... convert all images in webp"
    echo "       --nowebp <images path> ..... optimize all png & jpg images"
    echo "       --all <images path> ..... optimize all images (png + jpg + webp)"
    echo " Other options :"
    echo "       -h, --help, help ... displays this help information"
    echo "Examples:"
    echo "  optimize all jpg images in /var/www/images"
    echo "    img-optimize --jpg /var/www/images"
    echo ""
    return 0
}

##################################
# Parse script arguments
##################################

if [ "${#}" = "0"  ]; then
    _help
    exit 1
else
    
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --jpg)
                JPG_OPTIMIZATION="y"
                if [ "$2" ]; then
                    IMG_PATH=$2
                    shift
                else
                    IMG_PATH="./*"
                fi
            ;;
            --png)
                PNG_OPTIMIZATION="y"
                if [ "$2" ]; then
                    IMG_PATH=$2
                    shift
                else
                    IMG_PATH="./*"
                fi
            ;;
            --nowebp)
                JPG_OPTIMIZATION="y"
                PNG_OPTIMIZATION="y"
                WEBP_OPTIMIZATION="n"
                if [ "$2" ]; then
                    IMG_PATH=$2
                    shift
                else
                    IMG_PATH="./*"
                fi
            ;;
            --webp)
                WEBP_OPTIMIZATION="y"
                if [ "$2" ]; then
                    IMG_PATH=$2
                    shift
                else
                    IMG_PATH="./*"
                fi
            ;;
            --all)
                PNG_OPTIMIZATION="y"
                JPG_OPTIMIZATION="y"
                WEBP_OPTIMIZATION="y"
                if [ "$2" ]; then
                    IMG_PATH=$2
                    shift
                else
                    IMG_PATH="./*"
                fi
            ;;
            -h | --help | help)
                _help
                exit 1
            ;;
            *) ;;
        esac
        shift
    done
fi

##################################
# Welcome
##################################

echo ""
echo "Welcome to optimize.sh image optimization script."
echo ""

if [ -z "$JPG_OPTIMIZATION" ] && [ -z "$PNG_OPTIMIZATION" ] &&  [ -z "$WEBP_OPTIMIZATION" ]; then
    if [ -z "$JPG_OPTIMIZATION" ]; then
        echo ""
        echo "Do you want to optimize all jpg images in $1 ? (y/n)"
        while [[ $JPG_OPTIMIZATION != "y" && $JPG_OPTIMIZATION != "n" ]]; do
            read -p "Select an option [y/n]: " JPG_OPTIMIZATION
        done
    fi
    if [ -z "$PNG_OPTIMIZATION" ]; then
        echo ""
        echo "Do you want to optimize all png images in $1 (it may take a while) ? (y/n)"
        while [[ $PNG_OPTIMIZATION != "y" && $PNG_OPTIMIZATION != "n" ]]; do
            read -p "Select an option [y/n]: " PNG_OPTIMIZATION
        done
    fi
    if [ -z "$WEBP_OPTIMIZATION" ]; then
        echo ""
        echo "Do you want to convert all jpg & png images to WebP in $1 ? (y/n)"
        while [[ $WEBP_OPTIMIZATION != "y" && $WEBP_OPTIMIZATION != "n" ]]; do
            read -p "Select an option [y/n]: " WEBP_OPTIMIZATION
        done
        echo ""
        echo ""
    fi
fi

##################################
# image optimization
##################################

# optimize jpg
if [ "$JPG_OPTIMIZATION" = "y" ]; then
    echo -ne '       jpg optimization                      [..]\r'
    cd $IMG_PATH || exit 1
    find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -0 jpegoptim --preserve --strip-all -m82
    
    echo -ne "       jpg optimization                      [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi
if [ "$PNG_OPTIMIZATION" = "y" ]; then
    # optimize png
    
    echo -ne '       png optimization                      [..]\r'
    cd $IMG_PATH || exit 1
    find . -type f -iname '*.png' -print0 | xargs -0 optipng -o7 -strip all
    echo -ne "       png optimization                      [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi
if [ "$WEBP_OPTIMIZATION" = "y" ]; then
    # convert png to webp
    echo -ne '       png to webp conversion                [..]\r'
    cd $IMG_PATH || exit 1
    find . -type f -iname "*.png" -print0 | xargs -0 -I {} \
    bash -c '[ ! -f "{}.webp" ] && { cwebp -z 9 -mt {} -o {}.webp; }'
    
    echo -ne "       png to webp conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
    
    # convert jpg to webp
    echo -ne '       jpg to webp conversion                [..]\r'
    cd $IMG_PATH || exit 1
    find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -0 -I {} \
    bash -c '[ ! -f "{}.webp" ] && { cwebp -q 82 -mt {} -o {}.webp; }'
    
    echo -ne "       jpg to webp conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi


# We're done !
echo ""
echo -e "       ${CGREEN}Image optimization performed successfully !${CEND}"
echo ""
