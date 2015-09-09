#! /bin/bash

if [[ ! -d logs/ ]]
then
mkdir logs
fi

# Start checks
function loadavg {
status=ok
warning=3
critical=5
load_avg_1=$(cat /proc/loadavg|awk '{print $1}')
load_avg_5=$(cat /proc/loadavg|awk '{print $2}')
load_avg_15=$(cat /proc/loadavg|awk '{print $3}')
value=$(echo $load_avg_1|sed s/[.]/,/)

if (( $(echo "$value $warning" | awk '{print ($1 > $2)}') )) && (( $(echo "$value $critical" | awk '{print ($1 < $2)}') ))
then $status=warning
fi

if (( $(echo "$value $critical" | awk '{print ($1 > $2)}') ))
then $status=critical
fi

echo "$(date +%s);$(hostname);load_avg;$load_avg_1:$load_avg_5:$load_avg_15;load;$status" >> logs/$(hostname)_loadavg.dat
}

function memory {
status=ok
warning=
critical=
t=$(cat /proc/meminfo|grep MemFree|awk '{print $2}')
mem_free=$((t/1024))
echo "$(date +%s);$(hostname);mem_free;$mem_free;mb;$status" >> logs/$(hostname)_memfree.dat
}

