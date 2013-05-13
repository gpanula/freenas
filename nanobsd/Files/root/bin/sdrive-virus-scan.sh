#!/bin/sh

DATE=$( date +%F )
LOG="/mnt/Volume_001/opt/sdrive-scan-${DATE}.log"

/usr/bin/nice -n 15 clamscan --tempdir=/mnt/Volume_001/opt --move=/mnt/Volume_001/Backups_NFS/quarantine --detect-pua=no --detect-structured=no --exclude=^/\.recycle/ --recursive=yes --infected --log=${LOG}  /mnt/Volume_001/SDrive

exit 0
