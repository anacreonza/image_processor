#!/bin/bash
# Mount specified volume.

if [ "$1" == '' ] ; then
	echo "Server Mount Utility"
	echo "Usage: Specify the URL of the server you wish to mount. IE smb://myserver/myfolder"
	exit 0
fi

function mount_applescript () {
	mount_script=`/usr/bin/osascript > /dev/null << EOT
	tell application "Finder" 
	activate
	mount volume "$1"
	end tell
EOT`
}

mount_applescript "$1"