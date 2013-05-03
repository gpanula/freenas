#!/bin/sh

BACKUPDIR="/mnt/Volume_001/Backups_NFS/snapshots"

DATESTAMP=$(date +%F)

# make sure the $BACKUPDIR exists
if [ ! -d $BACKUPDIR ]
then
	echo $BACKUPDIR NOT FOUND!!!!
	exit 99
fi

# grab useful stuff
tar -czf $BACKUPDIR/nas01_backup_$DATESTAMP.tgz -C / data root/bin conf

fdisk /dev/da26 > $BACKUPDIR/nas01_fdisk_$DATESTAMP.txt

exit 0
