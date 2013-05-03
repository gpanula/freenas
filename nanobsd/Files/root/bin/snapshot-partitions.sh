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

# Now dump the snapshots
dd if=/dev/da26s1 of=$BACKUPDIR/nas01_da26s1_$DATESTAMP.img
#dd if=/dev/da26s2 of=$BACKUPDIR/nas01_da26s2_$DATESTAMP.img
dd if=/dev/da26s3 of=$BACKUPDIR/nas01_da26s3_$DATESTAMP.img
dd if=/dev/da26s4 of=$BACKUPDIR/nas01_da26s4_$DATESTAMP.img

exit 0
