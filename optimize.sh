#!/usr/bin/env bash
#----------------------------------------------------------------------------
#  img-optimize-  Image optimization bash script
#----------------------------------------------------------------------------
# Website:       https://virtubox.net
# GitHub:        https://github.com/VirtuBox/img-optimize
# Author:        VirtuBox
# License:       M.I.T
# ----------------------------------------------------------------------------
# Version 2.0 - 2020-11-10
# ----------------------------------------------------------------------------

CSI='\033['
CEND="${CSI}0m"
CGREEN="${CSI}1;32m"
FIND_ARGS=""
PNG_ARGS=""
JPG_ARGS=""
WEBP_ARGS=""
IMG_PATH="$PWD"

_help() {
    echo "Bash script to optimize your images and convert them in WebP "
    echo "Usage: img-optimize [options] <images path>"
    echo "If images path isn't defined, img-optimize will use the current directory "
    echo "  Options:"
    echo "       --jpg ..... optimize all jpg images"
    echo "       --png ..... optimize all png images"
    echo "       --webp ..... convert all images in webp"
    echo "       --avif ..... convert all images in avif"
    echo "       --std ..... optimize all png & jpg images"
    echo "       --next ..... convert all images in webp & avif"
    echo "       --all ..... optimize all images (png + jpg + webp + avif)"
    echo "       -i, --interactive ..... run img-optimize in interactive mode"
    echo "       -q, --quiet ..... run image optimization quietly"
    echo "       --path <images path> ..... define images path"
    echo " Other options :"
    echo "       -h, --help, help ... displays this help information"
    echo "       --cmin [+|-]<n> ... File's status was last changed n minutes ago."
    echo "         act find cmin argument (+n : greater than n, -n : less than n, n : exactly n)"
    echo "Examples:"
    echo "  optimize all jpg images in /var/www/images"
    echo "    img-optimize --jpg --path /var/www/images"
    echo ""
    return 0
}

##################################
# Parse script arguments
##################################

if [ "${#}" = "0" ]; then
    _help
    exit 1
else

    while [ "$#" -gt 0 ]; do
        case "$1" in
        --jpg)
            JPG_OPTIMIZATION="y"
            ;;
        --png)
            PNG_OPTIMIZATION="y"
            ;;
        --std)
            JPG_OPTIMIZATION="y"
            PNG_OPTIMIZATION="y"
            WEBP_OPTIMIZATION="n"
            AVIF_OPTIMIZATION="n"
            ;;
        --next)
            AVIF_OPTIMIZATION="y"
            WEBP_OPTIMIZATION="y"
            ;;
        --webp)
            WEBP_OPTIMIZATION="y"
            ;;
        --avif)
            AVIF_OPTIMIZATION="y"
            ;;
        --all)
            PNG_OPTIMIZATION="y"
            JPG_OPTIMIZATION="y"
            WEBP_OPTIMIZATION="y"
            AVIF_OPTIMIZATION="y"
            ;;
        -i | --interactive)
            INTERACTIVE_MODE="1"
            ;;
        -q | --quiet)
            PNG_ARGS=" -quiet"
            JPG_ARGS=" --quiet"
            WEBP_ARGS=" -quiet"
            ;;
        --cmin)
            if [ -n "$2" ]; then
                FIND_ARGS="$2"
                shift
            fi
            ;;
        --path)
            if [ -n "$2" ]; then
                IMG_PATH="$2"
                shift
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
# Prevent multi execution on same directory
##################################
lock=$(echo -n "$IMG_PATH" | md5sum| cut -d" " -f1)

if [ -f "/tmp/$lock" ]; then
    echo "$IMG_PATH yet in progress"
    exit 1
else
    touch "/tmp/$lock"
fi

##################################
# Welcome
##################################

echo ""
echo "Welcome to optimize.sh image optimization script."
echo ""

if [ "$INTERACTIVE_MODE" = "1" ]; then
    if [ -z "$IMG_PATH" ]; then
        echo "What is the path of images you want to optimize ?"
        echo "Images path (eg. /var/www/images):"
        read -r IMG_PATH
    fi
    if [ -z "$JPG_OPTIMIZATION" ]; then
        echo ""
        echo "Do you want to optimize all jpg images in $IMG_PATH ? (y/n)"
        while [[ $JPG_OPTIMIZATION != "y" && $JPG_OPTIMIZATION != "n" ]]; do
            echo "Select an option [y/n]: "
            read -r JPG_OPTIMIZATION
        done
    fi
    if [ -z "$PNG_OPTIMIZATION" ]; then
        echo ""
        echo "Do you want to optimize all png images in $IMG_PATH (it may take a while) ? (y/n)"
        while [[ $PNG_OPTIMIZATION != "y" && $PNG_OPTIMIZATION != "n" ]]; do
            echo "Select an option [y/n]: "
            read -r PNG_OPTIMIZATION
        done
    fi
    if [ -z "$WEBP_OPTIMIZATION" ]; then
        echo ""
        echo "Do you want to convert all jpg & png images to WebP in $IMG_PATH ? (y/n)"
        while [[ $WEBP_OPTIMIZATION != "y" && $WEBP_OPTIMIZATION != "n" ]]; do
            echo "Select an option [y/n]: "
            read -r WEBP_OPTIMIZATION
        done
        echo ""
        echo ""
    fi
    if [ -z "$AVIF_OPTIMIZATION" ]; then
        echo ""
        echo "Do you want to convert all jpg & png images to AVIF in $IMG_PATH ? (y/n)"
        while [[ $AVIF_OPTIMIZATION != "y" && $AVIF_OPTIMIZATION != "n" ]]; do
            echo "Select an option [y/n]: "
            read -r AVIF_OPTIMIZATION
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
    [ -z "$(command -v jpegoptim)" ] && {
        echo "Error: jpegoptim isn't installed"
        # Free ressource
        rm "/tmp/$lock"
        exit 1
    }
    echo -ne '       jpg optimization                      [..]\r'
    cd "$IMG_PATH" || exit 1
    if [ -n "$FIND_ARGS" ]; then
        find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -cmin "$FIND_ARGS" -print0 | xargs -r -0 jpegoptim "$JPG_ARGS" -p -s --all-progressive -m82
    else
        find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -r -0 jpegoptim "$JPG_ARGS" -p -s -m82 --all-progressive
    fi

    echo -ne "       jpg optimization                      [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi
if [ "$PNG_OPTIMIZATION" = "y" ]; then
    [ -z "$(command -v optipng)" ] && {
        echo "Error: optipng isn't installed"
        # Free ressource
        rm "/tmp/$lock"
        exit 1
    }
    # optimize png

    echo -ne '       png optimization                      [..]\r'
    cd "$IMG_PATH" || (rm "/tmp/$lock" && exit 1)
    if [ -n "$FIND_ARGS" ]; then
        find . -type f -iname '*.png' -cmin "$FIND_ARGS" -print0 | xargs -r -0 optipng "$PNG_ARGS" -o5 -strip all
    else
        find . -type f -iname '*.png' -print0 | xargs -r -0 optipng "$PNG_ARGS" -o5 -strip all
    fi
    echo -ne "       png optimization                      [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi
if [ "$WEBP_OPTIMIZATION" = "y" ]; then
    [ -z "$(command -v cwebp)" ] && {
        echo "Error: cwebp isn't installed"
        # Free ressource
        rm "/tmp/$lock"
        exit 1
    }
    # convert png to webp
    echo -ne '       png to webp conversion                [..]\r'
    cd "$IMG_PATH" || (rm "/tmp/$lock" && exit 1)
    if [ -n "$FIND_ARGS" ]; then
        find . -type f -iname "*.png" -cmin "$FIND_ARGS" -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.webp' ] && { cwebp -z 9 -mt $WEBP_ARGS '{}' -o '{}.webp'; }"
    else
        find . -type f -iname "*.png" -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.webp' ] && { cwebp -z 9 -mt $WEBP_ARGS '{}' -o '{}.webp'; }"
    fi
    echo -ne "       png to webp conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'

    # convert jpg to webp
    echo -ne '       jpg to webp conversion                [..]\r'
    cd "$IMG_PATH" || (rm "/tmp/$lock" && exit 1)
    if [ -n "$FIND_ARGS" ]; then
        find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -cmin "$FIND_ARGS" -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.webp' ] && { cwebp $WEBP_ARGS -q 82 -mt '{}' -o '{}.webp || rm -f '{}.webp''; }"
    else
        find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.webp' ] && { cwebp $WEBP_ARGS -q 82 -mt '{}' -o '{}.webp' || rm -f '{}.webp'; }"
    fi

    echo -ne "       jpg to webp conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi
if [ "$AVIF_OPTIMIZATION" = "y" ]; then
    [ -z "$(command -v avif)" ] && {
        echo "Error: avif isn't installed"
        # Free ressource
        rm "/tmp/$lock"
        exit 1
    }
    # convert png to avif
    echo -ne '       png to avif conversion                [..]\r'
    cd "$IMG_PATH" || (rm "/tmp/$lock" && exit 1)
    if [ -n "$FIND_ARGS" ]; then
        find . -type f -iname "*.png" -cmin "$FIND_ARGS" -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.avif' ] && { avif -e '{}' -o '{}.avif' || rm -f '{}.avif'; }"
    else
        find . -type f -iname "*.png" -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.avif' ] && { avif -e '{}' -o '{}.avif' || rm -f '{}.avif'; }"
    fi
    echo -ne "       png to avif conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'

    # convert jpg to avif
    echo -ne '       jpg to avif conversion                [..]\r'
    cd "$IMG_PATH" || (rm "/tmp/$lock" && exit 1)
    if [ -n "$FIND_ARGS" ]; then
        find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -cmin "$FIND_ARGS" -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.avif' ] && { avif -e '{}' -o '{}.avif' || rm -f '{}.avif'; } "
    else
        find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -0 -r -I {} \
            bash -c "[ ! -f '{}.avif' ] && { avif -e '{}' -o '{}.avif' || rm -f '{}.avif'; }"
    fi

    echo -ne "       jpg to avif conversion                [${CGREEN}OK${CEND}]\\r"
    echo -ne '\n'
fi

# We're done !
echo ""
echo -e "       ${CGREEN}Image optimization performed successfully !${CEND}"
echo ""

# Free ressource
rm "/tmp/$lock"
