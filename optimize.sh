#!/bin/bash
CSI='\033['
CEND="${CSI}0m"
CGREEN="${CSI}1;32m"


_help() {
    echo "Bash script to optimize your images and convert them in WebP "
    echo "Usage: img-optimize [options] <image path>"
    echo "  Options:"
    echo "       --jpg <image path> ..... optimize all jpg images"
    echo "       --png <image path> ..... optimize all png images"
    echo "       --webp <image path> ..... convert all images in webp"
    echo "       --nowebp <image path> ..... optimize all png & jpg images"
    echo "       --all <image path> ..... optimize all images (png + jpg + webp)"
    echo " Other options :"
    echo "       -h, --help, help ... displays this help information"
    echo "Examples:"
    echo ""
    echo "optimize all jpg images in /var/www/images"
    echo "    img-optimize --jpg /var/www/images"
    echo ""
    return 0
}

##################################
# Parse script arguments
##################################

while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
        --jpg)
            JPG_OPTIMIZATION="y"
            IMG_PATH=$2
            shift
        ;;
        --png)
            PNG_OPTIMIZATION="y"
            IMG_PATH=$2
            shift
        ;;
        --nowebp)
            JPG_OPTIMIZATION="y"
            PNG_OPTIMIZATION="y"
            WEBP_OPTIMIZATION="n"
            IMG_PATH=$2
            shift
        ;;
        --webp)
            WEBP_OPTIMIZATION="y"
            IMG_PATH=$2
            shift
        ;;
        --all)
            PNG_OPTIMIZATION="y"
            JPG_OPTIMIZATION="y"
            WEBP_OPTIMIZATION="y"
            IMG_PATH=$2
            shift
        ;;
        -h | --help | help)
            _help
            exit 1
        ;;
        *) ;;
    esac
    shift
done

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
    bash -c 'webp_version="$0".webp
    if [ ! -f "$webp_version" ]; then
    { cwebp -z 9 -mt {} -o {}.webp; }
    fi'

    echo -ne "       png to webp conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'

    # convert jpg to webp
    echo -ne '       jpg to webp conversion                [..]\r'
    cd $IMG_PATH || exit 1
    find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -0 -I {} \
    bash -c 'webp_version="$0".webp
        if [ ! -f "$webp_version" ]; then
        { cwebp -q 82 -mt {} -o {}.webp; }
    fi'

    echo -ne "       jpg to webp conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi


# We're done !
echo ""
echo -e "       ${CGREEN}Image optimization performed successfully !${CEND}"
echo ""
