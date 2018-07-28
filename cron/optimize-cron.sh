input="sites.csv"
while IFS='|' read -r f1 f2
do
  imagepath="$f2"
  # optimize jpg images created in the last 24 hours
  find $imagepath -iname "*.jp*" -ctime 0 -print0 | xargs -0 jpegoptim --quiet --strip-all -m76
  # optimize png images created in the last 24 hours
  find $imagepath -iname '*.png' -ctime 0 -print0 | xargs -0 optipng -o7 -quiet -preserve
  # convert png to webp
  find $imagepath -iname "*.png" -ctime 0 -print0 | xargs -0 -I {}  \
  bash -c 'webp_version="$0".webp
  if [ ! -f "$webp_version" ]; then
     { cwebp -quiet -lossless {} -o {}.webp; }
  fi'
  find $imagepath -iname "*.jp*" -ctime 0 -print0 | xargs -0 -I {} \
  bash -c 'webp_version="$0".webp
  if [ ! -f "$webp_version" ]; then
  { cwebp -quiet -lossless {} -o {}.webp; }
  fi' 
done < "$input"