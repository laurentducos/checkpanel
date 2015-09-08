#! /bin/bash

source check_functions.sh
source headers.sh


# Triggering for local checks
for i in $(cat config.sh|grep check)
do
t=$(echo $i | sed 's/check_//')
$t
done

headers $lang > webdatas/index.html
for i in $(ls logs); do tail -n1 logs/$i |awk -F ";" '{print "Hostname="$2 " check="$3":"$4}'; done
footer >> webdatas/index.html
