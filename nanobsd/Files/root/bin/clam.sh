#!/bin/sh

# create the directory and links needed for clamav
# first rest for a bit to let the system get setup
sleep 90

# create directory for clamav to use
mkdir -p /var/run/clamav
chown clamav:clamav /var/run/clamav
mkdir -p /var/tmp/.cache/clamav
chown clamav:clamav /var/tmp/.cache/clamav

ln -s /var/tmp/.cache/clamav /var/db/clamav

/usr/local/bin/freshclam --quiet -a 172.17.0.42

#/usr/local/bin/clamdscan --reload

/usr/local/sbin/clamd

exit 0
