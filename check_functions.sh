#! /bin/bash

# Checks
function loadavg {
load_avg_1=$(cat /proc/loadavg|awk '{print $1}')
load_avg_5=$(cat /proc/loadavg|awk '{print $2}')
load_avg_15=$(cat /proc/loadavg|awk '{print $3}')
warning=3
critical=5
status=ok
if [[ $load_avg_1 -ge $warning ]] && [[ $load_avg_1 -lt $critical ]]
then
$status=warning
fi
if [[ $load_avg_1 -ge $critical ]]
then
$status=critical
fi
echo "$(date +%s);$(hostname);load_avg;$load_avg_1:$load_avg_5:$load_avg_15;load;$status" >> logs/$(hostname)_loadavg.dat
}

function memory {
warning=
critical=
t=$(cat /proc/meminfo|grep MemFree|awk '{print $2}')
mem_free=$((t/1024))
echo "$(date +%s);$(hostname);mem_free;$mem_available;mb;$status" >> logs/$(hostname)_memfree.dat
}

