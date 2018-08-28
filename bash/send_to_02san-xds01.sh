#!/bin/bash
# sends scripts to 02san-xds01

rsync -aP "~/packages/Archiving Scripts/" \
--exclude "./archive_settings.sh" \
"srvadmin@02san-xds01.za.ds.naspers.com:/Library/Scripts/Archiving Scripts/"
