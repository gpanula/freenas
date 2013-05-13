#!/bin/sh

# dirty hack of a script to ensure the swap partitions get mounted

disk=0
drives=`ls /dev/da* | grep -v p | grep -v s | cat -n | sed 's/ //g' | cut -f1 | tail -n 1`

case "$1" in
start)
while [ $disk -lt $drives ]
do
	part=`gpart show da$disk | grep swap | cut -d'2' -f4 | sed 's/ //g' | cut -d'f' -f1`
	if [ ! -x $part ]
	then
		swapon /dev/da${disk}p$part
	else
		echo no swap found on da$disk
	fi

 disk=`expr ${disk} + 1 `
done
;;

stop)
while [ $disk -lt $drives ]
do
        part=`gpart show da$disk | grep swap | cut -d'2' -f4 | sed 's/ //g' | cut -d'f' -f1`
        if [ ! -x $part ]
        then
                swapoff /dev/da${disk}p$part
        else
                echo no swap found on da$disk
        fi

 disk=`expr ${disk} + 1 `
done
;;

esac

exit 0
