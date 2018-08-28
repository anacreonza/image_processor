#!/bin/bash

# Process images for TV Plus

# Script to clean up TV Plus images for import into Fotoware.
# 1. Convert all images to .jpg using ImageMagick
# 2. Delete originals.
# 3. Stamp images with file system metadata using exiftool. Both folder as well as filename without extension.
# 4. Strip folder info and sync the db into the FW server.

if [[ "$#" -ne 1 ]] ; then
	echo ""
	echo "Usage: Please specify source folder."
	exit 0
fi


# 1. Clean up and convert images to jpg.

# Delete Thumbs.db files (Windows previews)
find "$1" -type f -name "Thumbs.db" -delete

# Delete .DS_Store files (Mac filesystem metadata)
find "$1" -type f -name ".DS_Store" -delete

# Replace dashes in filenames with spaces to allow easier indexing.
find "$1" -type f -name '*-*' | while read file ; do mv "$file" "${file//-/ }" ; done

# Image conversion
find "$1" -type f -iname "*.tif" | while read file; do convert -flatten "$file" "${file/tif/jpg}"; done
find "$1" -type f -iname "*.gif" | while read file; do convert -flatten "$file" "${file/gif/jpg}"; done
find "$1" -type f -iname "*.png" | while read file; do convert -flatten "$file" "${file/png/jpg}"; done
find "$1" -type f -iname "*.psd" | while read file; do convert -flatten "$file" "${file/psd/jpg}"; done
find "$1" -type f -iname "*.bmp" | while read file; do convert -flatten "$file" "${file/bmp/jpg}"; done


# 2. Delete original images and standardise all extensions.

find "$1" -type f -iname "*.tif" -delete
find "$1" -type f -iname "*.gif" -delete
find "$1" -type f -iname "*.png" -delete
find "$1" -type f -iname "*.psd" -delete
find "$1" -type f -iname "*.bmp" -delete

# Fix non-standard JPEG filenames
find "$1" -type f -iname "*.jpeg" | while read file; do mv "$file" "${file/jpeg/jpg}"; done
find "$1" -type f -name "*.JPG" | while read file; do mv "$file" "${file/JPG/jpg}"; done
find "$1" -type f -name "*.jpg.jpg" | while read file; do mv "$file" "${file/.jpg.jpg/.jpg}"; done

