#!/bin/bash

if [[ ! $# == 1 ]] ; then
	echo "Usage: Please specify a source image file to read."
	exit 0
fi

echo ""
/usr/local/bin/exiftool -FileName -S $1
