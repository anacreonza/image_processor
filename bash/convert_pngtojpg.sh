#!/bin/bash

# Convert PNGs to JPEG

if [[ $# == 0 ]] ; then
	echo "Usage: Please specify a folder to process."
	echo ""
	exit 1
fi

find $1 -type f -name "*.png" | while read file ; do convert "$file" "${file}.jpg"; done

for file in $1/*.png.jpg
do
	mv "$file" "${file%.png.jpg}.jpg"
done