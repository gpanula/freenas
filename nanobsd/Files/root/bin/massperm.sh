#!/bin/sh

item=$( echo $1 | sed 's/ /\\ /g' )

echo "setfacl -m group@:rwxpDdaARWcCos:fd----:allow $item"
echo "setfacl -m owner@:rwxpDdaARWcCos:fd----:allow $item"

exit 0
