#!/bin/sh

if [ -z $1 ]
then
	echo "Please supply a directory to set permissions on"
	exit 1
fi

echo "ok, setting permissions on $1"
echo "here are the commands I am going to use"

item=$( echo $1 | sed 's/ /\\ /g' )

echo "setfacl -m group@:rwxpDdaARWcCos:fd----:allow $item"
echo "setfacl -m owner@:rwxpDdaARWcCos:fd----:allow $item"

setfacl -m group@:rwxpDdaARWcCos:fd----:allow ${item}
setfacl -m owner@:rwxpDdaARWcCos:fd----:allow ${item}

echo ""

getfacl ${item}

exit 0

