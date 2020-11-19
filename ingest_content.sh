#!/bin/bash

if [[ ! $1 ]] ; then
	echo "Usage: Please specify a publication code. For example MV for Move, TL for True Love or FW for Finweek."
	exit 1
fi

case "$1" in
	"MV")
		echo "Retrieving images for Move..."
		SOURCE="/Volumes/SmartMoverTemp/MoveArchive/MOVE/Archived/Print/"
		DESTINATION="/Users/stuart.kinnear/Desktop/SmartMover temp/MoveArchive/MOVE/Archived/Print"
		;;
	
	"TL")
		echo "Retrieving images for True Love..."
		SOURCE="/Volumes/SmartMoverTemp/TrueLoveArchive/TRUELOVE/Archived/Print/"
		DESTINATION="/Users/stuart.kinnear/Desktop/SmartMover temp/TrueLoveArchive/TRUELOVE/Archived/Print"
		;;

	"FW")
		echo "Retrieving images for Finweek..."
		SOURCE="/Volumes/SmartMoverTemp/FinweekArchive/FINWEEK/Archived/Print/"
		DESTINATION="/Users/stuart.kinnear/Desktop/SmartMover temp/FinweekArchive/FINWEEK/Archived/Print"
		;;

	*)
		echo "Invalid publication code"
		exit 1
esac

if [[ ! -d "/Volumes/c$/" ]] ; then
	echo "WoodWing server not mapped. Mapping..."
	./mount_ww.sh
fi

/usr/local/bin/copy_and_delete.sh "${SOURCE}" "${DESTINATION}"
