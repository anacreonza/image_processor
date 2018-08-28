#!/bin/bash

# 3. Stamp images with filesystem metadata

if [[ ! $# == 1 ]] ; then
	printf "Usage: Please specify a source folder for images to tag\n"
fi

echo "Run in test mode only? [y/n]"
read modeselect

if [[ "$modeselect" == "y" ]] ; then
	testmode = "test"
fi

find "$1" -type f -name "*.jpg" | while read file; do
	filename=$(basename "$file") 
	tag="${filename%.jpg}"
	printf "\n\nProcessing file ${filename}...\n"
	printf "Adding filename \"${tag}\" as a keyword\n"
	if [[ ! "$testmode" ]] ; then
		/usr/local/bin/exiftool -r -overwrite_original "-keywords+=${tag}" "${file}"
	fi
	fileinfolder="${file#$1}"
	subfolder="${fileinfolder%$filename}"
	subfolder="${subfolder#/}"
	subfolder="${subfolder%/}"
	if [[ $subfolder ]] ; then
		echo "Folder keywords to be added:"
		IFS='/' read -r -a keyword_array <<< "$subfolder"
		for keyword in "${keyword_array[@]}"
		do
			printf "\t$keyword\n"
			if [[ ! "$testmode" ]] ;then
				/usr/local/bin/exiftool -r -overwrite_original "-keywords+=${keyword}" "${file}"
			fi
		done
	fi
done

printf "\n"

