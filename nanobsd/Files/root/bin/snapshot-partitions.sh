#!/bin/sh

BACKUPDIR="/mnt/Volume_001/Backups_NFS/snapshots"

DATESTAMP=$(date +%F)

HOST=$(hostname -s)

# make sure the $BACKUPDIR exists
if [ ! -d $BACKUPDIR ]
then
	echo $BACKUPDIR NOT FOUND!!!!
	exit 99
fi

# grab useful stuff
tar -czf $BACKUPDIR/nas01_backup_$DATESTAMP.tgz -C / data root/bin conf

fdisk /dev/da26 > $BACKUPDIR/nas01_fdisk_$DATESTAMP.txt

# Now dump the local filesystems
grep FreeNAS /etc/fstab | cut -f1 -d' ' > /tmp/drives.list

{ while read goo ;
do
        drive=$( echo $goo | cut -d'/' -f4)
	/sbin/dump -0Lauf ${BACKUPDIR}/${HOST}_${drive}_${DATESTAMP}.dump ${goo}
done } < /tmp/drives.list


exit 0
