#!/bin/bash

## cronjob to optimize PNG/JPG images
## images path are listed in sites.csv
## written by VirtuBox (https://virtubox.net)

input="sites.csv"
while IFS='|' read -r f1 f2
do
  # optimize jpg images created in the last 24 hours
  find "$f2" -ctime 0 -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -print0 | xargs -0 jpegoptim --preserve --quiet --strip-all -m82 >> /var/log/jpg-png-cron.log
  # optimize png images created in the last 24 hours
  find "$f2" -ctime 0 -type f  -iname '*.png' -print0 | xargs -0 optipng -o7 -strip all -quiet  >> /var/log/jpg-png-cron.log
done < "$input"