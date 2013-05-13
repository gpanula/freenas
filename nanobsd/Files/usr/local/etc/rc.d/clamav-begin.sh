#!/bin/sh

# need to move the /var/db/clamav because
# the virus db is too big for the /var partition(slice?)

case "$1" in
start)
	if [ ! -h /var/db/clamav ]
	then
		# stop the clam daemons
		/usr/local/etc/rc.d/clamav-clamd stop
		/usr/local/etc/rc.d/clamav-freshclam stop

		# make or move the clamav directory
		if [ -d /var/db/clamav ]
		then
			mv /var/db/clamav /var/tmp/.cache/
		else
			mkdir -p /var/tmp/.cache/clamav
			chown clamav:clamav /var/tmp/.cache/clamav
		fi

		# finally create the symlink
		ln -s /var/tmp/.cache/clamav /var/db/clamav
	fi
	;;
stop)
	cp /var/tmp/.cache/clamav/* /conf/base/var/db/clamav/
	;;
esac


exit 0
