#!/bin/bash

# Remove dashes from filenames.

if [[ $# == 0 ]] ; then
	echo "Usage: Please specify a folder to process."
	echo ""
	exit 1
fi

# Use bash parameter expansion search and replace to change filenames.
# ${file//-/ } replaces all occurrences of "-" with " "

find "$1" -type f -name '*-*' | while read file ; do mv "$file" "${file//-/ }" ; done