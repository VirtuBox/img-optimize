input="sites.csv"
while IFS='|' read -r f1 f2
do
  # optimize jpg images created in the last 24 hours
  find $f2 -iname "*.jpg" -o -iname "*.jpeg" -ctime 0 -print0 | xargs -0 jpegoptim --quiet --strip-all -m76
  # optimize png images created in the last 24 hours
  find $f2 -iname '*.png' -ctime 0 -print0 | xargs -0 optipng -o7 -quiet -preserve
  # convert png to webp
  find $f2 -iname "*.png" -ctime 0 -print0 | xargs -0 -I {}  \
  bash -c 'webp_version="$0".webp
  if [ ! -f "$webp_version" ]; then
     { cwebp -quiet -lossless {} -o {}.webp; }
  fi'
  find $f2 -iname "*.jpg" -o -iname "*.jpeg" -ctime 0 -print0 | xargs -0 -I {} \
  bash -c 'webp_version="$0".webp
  if [ ! -f "$webp_version" ]; then
  { cwebp -quiet -lossless {} -o {}.webp; }
  fi' 
done < "$input"