#!/bin/bash

# process multiple image files

# Paths
library_folder="/Users/stuart.kinnear/Sites/images/library"
input_folder="/Users/stuart.kinnear/Sites/images/input"
thumbs_folder="$library_folder/thumbs/"
previews_folder="$library_folder/previews/"
originals_folder="$library_folder/originals/"

find "$input_folder" -type f \( -name "*.jpg" -or -name "*.tif" \) -exec ./build_preview.sh {} \;