#!/bin/bash

# How many JPEG images in the current folder

AMOUNT=$(find . -name "*.jpg" -maxdepth 1 | wc -l | awk {'print $1'})
if [ ! "$AMOUNT" == "0" ]; then
	printf "There are $AMOUNT JPEG images in this folder\n"
else
	printf "No JPEG images found\n"
fi
exit 0