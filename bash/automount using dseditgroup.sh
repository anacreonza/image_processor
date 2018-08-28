#!/bin/bash
######################################
#
# Share mounting script					  
#
# Usage: shareConnect afp|smb|cifs server share group 	  
# E.g. shareConnect afp my.server my.share my.group   	  
#
# Exit codes:
#
# 0 - Script completed successfully			  
# 1 - User isn't a member of the specified group     	  
#
# Created by David Acland - Amsys
#
# Use at your own risk.  Amsys will accept
# no responsibility for loss or damage
# caused by this script.
#
######################################
protocol="$1"	# This is the protocol to connect with (afp | smb)
serverName="$2"	# This is the address of the server, e.g. my.fileserver.com
shareName="$3"	# This is the name of the share to mount
group="$4"		# This is the name of the group the user needs to be a member of to mount the share
# Check that the user is in the necessary group
	groupCheck=`dseditgroup -o checkmember -m $USER "$group" | grep -c "yes"`
if [ "${groupCheck}" -ne 1 ]; then
exit 1
fi
# Mount the drive
	mount_script=`/usr/bin/osascript > /dev/null << EOT
	tell application "Finder" 
	activate
	mount volume "$protocol://${serverName}/${shareName}"
	end tell
EOT`
exit 0