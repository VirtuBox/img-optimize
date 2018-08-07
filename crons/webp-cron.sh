#!/bin/bash

## cronjob to convert PNG/JPG images to WebP
## images path are listed in sites.csv
## written by VirtuBox (https://virtubox.net)

input="sites.csv"
while IFS='|' read -r f1 f2
do
# convert png created in the last 24 hours to webp
{
find "$f2" -ctime 0 -type f -iname "*.png" -print0 | xargs -0 -I {}  \
bash -c 'webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -quiet -z 9 -mt {} -o {}.webp; }
fi'  
# convert jpg created in the last 24 hours to webp
find "$f2" -ctime 0 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -0 -I {} \
bash -c 'webp_version="$0".webp
if [ ! -f "$webp_version" ]; then
{ cwebp -quiet -q 82 -mt {} -o {}.webp; }
fi'
} >> /var/log/webp-cron.log
done < "$input"

