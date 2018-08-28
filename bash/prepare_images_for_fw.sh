#!/bin/bash
#Prepare images for import to Fotoweb

#mark time
start_time=`date`
#Check if command line options are included
if [ ! $# == 2 ] ; then
    echo "Usage: please specify a source and a destination folder"
    exit
fi

#Make backup of existing archive structure
echo "Making backup copy of data..."
work_folder="/tmp/fotowork/"
if [ ! -d $work_folder ] ; then
    mkdir $work_folder
fi
rsync -aP \
    --exclude "*.indd" \
    --exclude "*.wcml" \
    --exclude "*.doc" \
    --exclude "*.docx" \
    --exclude "*.xlsx" \
    --exclude "*.pdf" \
    --exclude "*.ai" \
    --exclude "*.rtf" \
    --exclude "iStock*" \
    --exclude "Getty*" \
    --exclude "Corbis*" \
    --exclude "*dreamstime*" \
    --min-size='230K' "$1" "$work_folder"

#Main conversion and tagging loop
cd "$work_folder"
#echo "Now in "`pwd`
for issue_folder in * ; do #process each issue individually
    nameregex='^[0-9][0-9][0-9][0-9][0-9][0-9]'
	if ! [[ $issue_folder =~ $nameregex ]]; then
		echo "Input folder $issue_folder must start with 6 digits. Not processed."
		continue
	fi
    day=`echo "$issue_folder" | cut -c 1-2`
    month=`echo "$issue_folder" | cut -c 3-4`
    yr=`echo "$issue_folder" | cut -c 5-6`
    year="20$yr"
    newname=$month$day

    if [ ! -d "$2$year" ] ; then
        mkdir "$2$year"
    fi
    if [ ! -d "$2$year/$newname" ] ; then
        mkdir "$2$year/$newname"
    fi

    cd "$issue_folder"
    #echo "now in "`pwd`
    for dossier_folder in */ ; do #process each dossier individually
               
        #Image conversions
        #num_of_eps=`ls "$dossier_folder"*.eps | wc -l | sed s_\ __g`
        echo "Converting images in $issue_folder/$dossier_folder to JPEG..."
        num_of_psd=$(find "$dossier_folder" -name "*.psd" -maxdepth 1 | wc -l | awk '{print $1}')
        #num_of_psd=`ls "$dossier_folder"*.psd | wc -l | sed s_\ __g`
        if [ $num_of_psd != "0" ] ; then
            echo "Converting $num_of_psd PhotoShop images..."
            find "$dossier_folder" -type f -name "*.psd" | while read file; do convert -flatten "$file" "${file/psd/jpg}"; done
            find "$dossier_folder" -type f -name "*.psd" -delete
        fi
        num_of_tif=$(find "$dossier_folder" -name "*.tif" -maxdepth 1 | wc -l | awk '{print $1}')
        if [ $num_of_tif != "0" ] ; then
            echo "Converting $num_of_tif TIFF images..."
            find "$dossier_folder" -type f -name "*.tif" | while read file; do convert -flatten "$file" "${file/tif/jpg}"; done
            find "$dossier_folder" -type f -name "*.tif" -delete
        fi
        num_of_png=$(find "$dossier_folder" -name "*.png" -maxdepth 1 | wc -l | awk '{print $1}')
        if [ $num_of_png != "0" ] ; then
            echo "Converting $num_of_png PNG images..."
            find "$dossier_folder" -type f -name "*.png" | while read file; do convert -flatten "$file" "${file/png/jpg}"; done
            find "$dossier_folder" -type f -name "*.png" -delete
        fi
        num_of_eps=$(find "$dossier_folder" -name "*.eps" -maxdepth 1 | wc -l | awk '{print $1}')
        if [ $num_of_eps != "0" ] ; then
            find "$dossier_folder" -type f -name "*.eps" | while read file; do convert -density 300 "$file" -resize 1024x1024 "${file/eps/jpg}"; done
            find "$dossier_folder" -type f -name "*.eps" -delete
        fi
        #Entag the jpegs with the folder information
        num_of_jpg=$(find "$dossier_folder" -name "*.jpg" -maxdepth 1 | wc -l | awk '{print $1}')
        echo "Tagging $num_of_jpg JPEGs in $issue_folder/$dossier_folder with folder names as keywords..."
        dossier_name=`echo "$dossier_folder" | sed s_/__`
        issue_name=`echo "$issue_folder" | sed s_/__`
        exiftool -r -overwrite_original "-keywords+=$issue_name" "-keywords+=$dossier_name" "$dossier_folder" -ext jpg
        #Delete images with credit lines from syndication services
        find "$dossier_folder" -type f -name "*.jpg" | while read file; do 
        credit=`exiftool -h "$file" | grep 'Credit</td><td>'`
            if [[ "$credit" == *"Getty"* ]] ; then
                echo "Deleting Getty image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"FilmMagic"* ]] ; then
                echo "Deleting FilmMagic image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"Gallo Images"* ]] ; then
                echo "Deleting Gallo image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"Corbis"* ]] ; then
                echo "Deleting Corbis image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"iStock"* ]] ; then
                echo "Deleting iStock image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"WireImage"* ]] ; then
                echo "Deleting WireImage image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"REX/Snap Stills"* ]] ; then
                echo "Deleting REX image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"VStock"* ]] ; then
                echo "Deleting VStock image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"REUTERS"* ]] ; then
                echo "Deleting REUTERS image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"Everett Collection"* ]] ; then
                echo "Deleting Everett Collection image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"Picture Perfect / Rex Features"* ]] ; then
                echo "Deleting Picture Perfect / Rex Features image - $file"
                rm "$file"
            fi
            if [[ "$credit" == *"dreamstime"* ]] ; then
                echo "Deleting Dreamstime.com image - $file"
                rm "$file"
            fi
        done
        num_of_jpg=$(find "$dossier_folder" -name "*.jpg" -maxdepth 1 | wc -l | awk '{print $1}')
        echo "Moving $num_of_jpg JPEGs to $2$year/$newname"
        rsync -aP --remove-source-files "/$work_folder/$issue_folder/$dossier_folder/" "$2$year/$newname"
 	done
    cd "$work_folder"
done
#Last few steps
echo "Cleaning up..."
find "$work_folder" -type d -empty -delete
end_time=`date`
echo "Job ran from $start_time to $end_time"
exit 0