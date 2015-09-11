#! /bin/bash

# Start checks

function tester {
echo "$(date +%s);$(hostname);test;42;test;critical" >> $kppath/logs/$(hostname)_test.dat
}

function loadavg {
status=ok
warning=3
critical=5
load_avg_1=$(cat /proc/loadavg|awk '{print $1}')
load_avg_5=$(cat /proc/loadavg|awk '{print $2}')
load_avg_15=$(cat /proc/loadavg|awk '{print $3}')
value=$(echo $load_avg_1|sed s/[.]/,/)

if (( $(echo "$value $warning" | awk '{print ($1 > $2)}') )) && (( $(echo "$value $critical" | awk '{print ($1 < $2)}') ))
then status=warning
fi

if (( $(echo "$value $critical" | awk '{print ($1 > $2)}') ))
then status=critical
fi

echo "$(date +%s);$(hostname);load_avg;$load_avg_1:$load_avg_5:$load_avg_15;load;$status" >> $kppath/logs/$(hostname)_loadavg.dat
}

function memory {
status=ok
warning=800
critical=200
mem_free=$(cat /proc/meminfo|grep MemFree|awk '{print $2/1024}')

if (( $(echo "$mem_free $warning" | awk '{print ($1 < $2)}') )) && (( $(echo "$mem_free $critical" | awk '{print ($1 > $2)}') ))
then status=warning
fi

if (( $(echo "$mem_free $critical" | awk '{print ($1 < $2)}') ))
then status=critical
fi

echo "$(date +%s);$(hostname);mem_free;$mem_free;mb;$status" >> $kppath/logs/$(hostname)_memfree.dat
}

function bandwith {
status=ok
warning=
critical=

x=$(cat /sys/class/net/$1/statistics/rx_bytes)
sleep 1
y=$(cat /sys/class/net/$1/statistics/rx_bytes)
rxbps="$(((y-x)/1))"

x=$(cat /sys/class/net/$1/statistics/tx_bytes)
sleep 1
y=$(cat /sys/class/net/$1/statistics/tx_bytes)
txbps="$(((y-x)/1))"
echo "$(date +%s);$(hostname);$1 bandwith down:up;$rxbps:$txbps;bps;$status" >> $kppath/logs/$(hostname)_$1bps.dat
}
