#!/bin/bash

# Sort files by mdate

for i in {2004..2019}
do
	if [[ ! -d "$1/$i" ]] ; then
		mkdir -p "$1/$i"
	fi
	nextyear=$(($i + 1))
	find "$1" -type f -maxdepth 1 -newermt "$i"-01-01 ! -newermt "$nextyear"-01-01 -exec mv {} "$1/$i/" \;
done