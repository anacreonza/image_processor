#!/bin/bash

# Main archiving script

echo "Archiving script updated: 26 March 2018"

# Include settings file.
source archive_settings.sh

# Main archiving function
do_archive ()
{
	FILES=$(find "$SRC" -type d)
	if [ ! "$FILES" ]; then
		printf "No items found in source folder\n"
	else
		# Process images for Fotostation
		printf "Process $BRAND images for import into FotoStation [y/n]?\n"
		read CONFIRM_FW
		if [ "$CONFIRM_FW" == "y" ]; then
			WRKIN="$WRK/$BRAND/In/"
			WRKOUT="$WRK/$BRAND/Out/"

			if [ ! -d "$WRKIN" ]; then
				mkdir -p "$WRKIN"
			fi
			if [ ! -d "$WRKOUT" ]; then
				mkdir -p "$WRKOUT"
			fi

			find "$SRC" -type f -name ".DS_Store" -delete # Screen garbage
			find "$SRC" -type f -name "Thumbs.db" -delete
			/usr/local/bin/rsync -aP --remove-source-files "$SRC" "$WRKIN"
			find "$SRC" -type d -empty -delete
			BIGFILES=$(find "$WRKIN" -type f -name "*.psd" -size +400M)
			if [[ $BIGFILES ]] ; then
				echo "WARNING - Some very big (over 450MB) PSDs were found in the source!"
				echo "$BIGFILES"
				echo "Proceed anyway?[y/n]"
				read PROCEED
				if [ $PROCEED == "n"] ; then
					exit 1
				fi
			fi
			./prepare_images_for_fw.sh "$WRKIN" "$WRKOUT"
			printf "Upload results to $FWDEST [y/n]?"
			read CONFIRM_UPLOAD
			if [ "$CONFIRM_UPLOAD" == "y" ]; then
				if [ ! -d "$FWDEST" ]; then
					printf "Fotoware server not connected. Mounting...\n"
					./mount_volume.sh "$FOTOWARE_SERVER"
				fi
				/usr/local/bin/rsync -aP --remove-source-files "$WRKOUT" "$FWDEST"
				find "$WRKOUT" -type d -empty -delete
			fi
		fi

		# Send the stuff that came out of SmartMover to the brand's own server
		printf "Move archived data to $DEST [y/n]?"
		read CONFIRM_ARC
		if [ "$CONFIRM_ARC" == "y" ]; then
			/usr/local/bin/rsync -aP --remove-source-files "$WRKIN" "$DEST"
			/usr/local/find "$WRKIN" -type d -empty -delete
		fi
		printf "Archive process complete\n"
		printf "Your Baby (1)\n"
		printf "Your Pregnancy (2)\n"
		printf "Baba En Kleuter (3)\n"
		printf "Move (4)\n"
		printf "True Love (5)\n"
		printf "Finweek (6)\n"
		printf "TV Plus (7)\n"
		printf "Exit (8)\n"
	fi
}

clear
if [ ! -d "/Volumes/SmartMover temp/" ]; then
   	echo "SmartMover source folder $SRC not found. Mounting..."
   	./mount_volume.sh "smb://02auc-wwap04/SmartMover temp/"
fi

printf "================================================================================\n"
printf "Media24 Archiving Script\n"
printf "================================================================================\n"

PS3='Which title do you want to archive?'
options=("Your Baby" "Your Pregnancy" "Baba En Kleuter" "Move" "True Love" "Finweek" "TV Plus" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Your Baby")
			BRAND="YourBaby"
			SRC="$YBSRC"
			DEST="$YBDDEST"
			FWDEST="$YBFWDEST"
			do_archive
            ;;
        "Your Pregnancy")
			BRAND="YourPregnancy"
			SRC="$YPSRC"
			DEST="$YPDDEST"
			FWDEST="$YPFWDEST"
			do_archive
            ;;
        "Baba En Kleuter")
			BRAND="BabaEnKleuter"
			SRC="$BKSRC"
			DEST="$BKDEST"
			FWDEST="$BKFWDEST"
			do_archive
            ;;
        "True Love")
            BRAND="TrueLove"
            SRC="$TLSRC"
            DEST="$TLDEST"
			FWDEST="$TLFWDEST"
       		do_archive
            ;;
        "Move")
            BRAND="Move"
            SRC="$MVSRC"
            DEST="$MVDEST"
			FWDEST="$MVFWDEST"
       		do_archive
            ;;
        "Finweek")
            BRAND="Finweek"
            SRC="$FWSRC"
            DEST="$FWDEST"
			FWDEST="$FWFWDEST"
       		do_archive
            ;;
        "TV Plus")
            BRAND="TVPlus"
            SRC="$TVSRC"
            DEST="$TVDEST"
			FWDEST="$TVFWDEST"
       		do_archive
            ;;

        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done

