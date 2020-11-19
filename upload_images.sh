#!/bin/bash

if [[ ! $1 ]] ; then
	echo "Usage: Please specify a publication code. For example MV for Move, TL for True Love or FW for Finweek."
	exit 1
fi

case "$1" in
	"FW")
		echo "Uploading images for Finweek..."
		PROCESSED_IMAGES="/Users/stuart.kinnear/Desktop/SmartMover temp/Images Done/FINWEEK/"
		IMAGE_REPO="/Volumes/Images1/WEEKLIES/FINWEEK/JPG/"
		;;

	*)
		echo "Invalid publication code"
		exit 1
esac

if [[ ! -d "/Volumes/Images1/" ]] ; then
	echo "Fotoware server not mapped. Mapping..."
	./mount_fw.sh
fi

/usr/bin/rsync -aP --remove-source-files "${PROCESSED_IMAGES}" "${IMAGE_REPO}"
find "${PROCESSED_IMAGES}" -type d -empty -delete 
