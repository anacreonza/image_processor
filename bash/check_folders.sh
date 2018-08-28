#!/bin/bash

#Check if folders are in the right format

re='^[0-9][0-9][0-9][0-9][0-9][0-9]'

folder="010117_January"

if ! [[ $folder =~ $re ]] ; then
   echo "error: bad folder name" >&2; exit 1
else
	echo "Folder name is fine"
fi