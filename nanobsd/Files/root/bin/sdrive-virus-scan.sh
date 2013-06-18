#!/bin/sh

DATE=$( date +%F )
LOG="/mnt/Volume_001/opt/sdrive-scan-${DATE}.log"

# make sure we have a virus def db
if [ ! -e /var/db/clamav/main.cvd ]
then
	/usr/local/etc/rc.d/clamav-freshclam start
	sleep 60
fi

/usr/bin/nice -n 15 clamscan --tempdir=/mnt/Volume_001/opt --move=/mnt/Volume_001/Quarantine --detect-pua=no --detect-structured=no --exclude=^/\.recycle/ --recursive=yes --infected --log=${LOG}  /mnt/Volume_001/SDrive

exit 0
