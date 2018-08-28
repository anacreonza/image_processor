#!/bin/bash

# Imports images into image library

# Paths
library_folder="/Users/stuart.kinnear/Sites/images/library"
input_folder="/Users/stuart.kinnear/Sites/images/input"
thumbs_folder="$library_folder/thumbs/"
previews_folder="$library_folder/previews/"
originals_folder="$library_folder/originals/"

# Size settings
previewsize="72x72" # Horizontal DPI x Vertical DPI
thumbsize="20x20" # Horizontal DPI x Vertical DPI

image="$1"

echo "Processing $image."
newname=$(basename "$image")
echo "Building preview..."
/opt/ImageMagick/bin/convert -colorspace RGB -resample "$previewsize" "$image" "$previews_folder/Preview-$newname.jpg" 2> /dev/null
echo "Building thumbnail..."
/opt/ImageMagick/bin/convert -colorspace RGB -resample "$thumbsize" "$previews_folder/Preview-$newname.jpg" "$thumbs_folder/Thumb-$newname.jpg" 2> /dev/null
echo "Moving image to originals folder..."
mv "$image" "$originals_folder"