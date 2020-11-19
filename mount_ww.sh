#!/bin/bash

# Applescript function to mount destination server

function mount_applescript () {
	mount_script=`/usr/bin/osascript > /dev/null << EOT
	tell application "Finder" 
	activate
	mount volume "$1"
	end tell
EOT`
}

mount_applescript "smb://02rnb-wwap01/SmartMoverTemp"