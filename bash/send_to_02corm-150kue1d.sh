#!/bin/bash
# sends scripts to 02corm-150kue1d

rsync -aP "/Users/stuart.kinnear/packages/Archiving/" \
--exclude "~/packages/Archiving/archive_settings.sh" \
"admin@02corm-150kue1d.za.ds.naspers.com:/Users/Admin/Archiving/"
