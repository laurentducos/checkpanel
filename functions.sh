#! /bin/bash

# Start checks
# DATE FORMAT YYYY/MM/DD HH:MM:SS -> date "+%Y/%m/%d %H:%M:%S"

#function tester {
#echo "$(date +%s);$(hostname);test;42;test;critical" >> $kppath/logs/$(hostname)_test.dat
#}

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

if [[ ! -f $kppath/logs/$(hostname)_loadavg.dat ]]
then
echo "$(date +%s);$(hostname);loadavg;$load_avg_1:$load_avg_5:$load_avg_15;load;$status" > $kppath/logs/$(hostname)_loadavg.dat
fi
echo "$(date +%s);$(hostname);loadavg;$load_avg_1:$load_avg_5:$load_avg_15;load;$status" >> $kppath/logs/$(hostname)_loadavg.dat

# Graph datas
grep -q "date" $kppath/webdatas/$(hostname)_loadavg.csv
if [[ $? -ne 0 ]]
then
echo "date,load_avg1,load_avg5,load_avg15" > $kppath/webdatas/$(hostname)_loadavg.csv
fi
echo "$(date "+%Y/%m/%d %H:%M:%S"),$load_avg_1,$load_avg_5,$load_avg_15" >> $kppath/webdatas/$(hostname)_loadavg.csv
}

function memory {
status=ok
warning=800
critical=200
mem_free=$(cat /proc/meminfo|grep MemFree|awk '{print $2/1024}')
mem_available=$(cat /proc/meminfo|grep MemAvailable|awk '{print $2/1024}')
mem_total=$(cat /proc/meminfo|grep MemTotal|awk '{print $2/1024}')
mem_buffers=$(cat /proc/meminfo|grep Buffers|awk '{print $2/1024}')
mem_cached=$(cat /proc/meminfo|grep ^Cached|awk '{print $2/1024}')

if (( $(echo "$mem_free $warning" | awk '{print ($1 < $2)}') )) && (( $(echo "$mem_free $critical" | awk '{print ($1 > $2)}') ))
then status=warning
fi

if (( $(echo "$mem_free $critical" | awk '{print ($1 < $2)}') ))
then status=critical
fi


if [[ ! -f $kppath/logs/$(hostname)_memory.dat ]]
then
echo "$(date +%s);$(hostname);memory;$mem_free;mb;$status" > $kppath/logs/$(hostname)_memory.dat
fi
echo "$(date +%s);$(hostname);memory;$mem_free;mb;$status" >> $kppath/logs/$(hostname)_memory.dat

# Graph datas
grep -q "date" $kppath/webdatas/$(hostname)_memory.csv
if [[ $? -ne 0 ]]
then
echo "date,mem_free,mem_available,mem_total,mem_buffers,mem_cached" > $kppath/webdatas/$(hostname)_memory.csv
fi
echo "$(date "+%Y/%m/%d %H:%M:%S"),$mem_free,$mem_available,$mem_total,$mem_buffers,$mem_cached" >> $kppath/webdatas/$(hostname)_memory.csv
}

function process {
status=ok
warning=100
critical=200
process=$(ps aux| wc -l)

if (( $(echo "$process $warning" | awk '{print ($1 >= $2)}') )) && (( $(echo "$process $critical" | awk '{print ($1 < $2)}') ))
then status=warning
fi

if (( $(echo "$process $critical" | awk '{print ($1 >= $2)}') ))
then status=critical
fi

if [[ ! -f $kppath/logs/$(hostname)_process.dat ]]
then
echo "$(date +%s);$(hostname);process;$process;cnt;$status" > $kppath/logs/$(hostname)_process.dat
fi
echo "$(date +%s);$(hostname);process;$process;cnt;$status" >> $kppath/logs/$(hostname)_process.dat

# Graph datas
grep -q "date" $kppath/webdatas/$(hostname)_process.csv
if [[ $? -ne 0 ]]
then
echo "date,process" > $kppath/webdatas/$(hostname)_process.csv
fi
echo "$(date "+%Y/%m/%d %H:%M:%S"),$process" >> $kppath/webdatas/$(hostname)_process.csv
}

function bandwith {
status=ok
warning=
critical=

if [[ ! -f /tmp/$1_rx_bytes ]] || [[ ! -f /tmp/$1_tx_bytes ]]
then
cat "/sys/class/net/$1/statistics/rx_bytes" > "/tmp/$1_rx_bytes"
cat "/sys/class/net/$1/statistics/tx_bytes" > "/tmp/$1_tx_bytes"
fi

rx=$(cat "/sys/class/net/$1/statistics/rx_bytes")
tx=$(cat "/sys/class/net/$1/statistics/tx_bytes")
oldrx=$(cat "/tmp/$1_rx_bytes")
oldtx=$(cat "/tmp/$1_tx_bytes")

if [[ ! -f $kppath/logs/$(hostname)_bandwith_$1.dat ]]
then
echo "$(date +%s);$(hostname);bandwith_$1;$((rx-oldrx))rx:$((tx-oldtx))tx;mb;$status" > $kppath/logs/$(hostname)_bandwith_$1.dat
fi
echo "$(date +%s);$(hostname);bandwith_$1;$((rx-oldrx))rx:$((tx-oldtx))tx;mb;$status" >> $kppath/logs/$(hostname)_bandwith_$1.dat

cat "/sys/class/net/$1/statistics/rx_bytes" > "/tmp/$1_rx_bytes"
cat "/sys/class/net/$1/statistics/tx_bytes" > "/tmp/$1_tx_bytes"

# Graph datas
grep -q "date" $kppath/webdatas/$(hostname)_bandwith_$1.csv
if [[ $? -ne 0 ]]
then
echo "date,tx_bytes,rx_bytes" > $kppath/webdatas/$(hostname)_bandwith_$1.csv
fi
echo "$(date "+%Y/%m/%d %H:%M:%S"),$((rx-oldrx)),$((tx-oldtx))" >> $kppath/webdatas/$(hostname)_bandwith_$1.csv
}

function iostat {
status=ok
warning=
critical=
x=$(cat /sys/block/sda/stat)
#https://www.kernel.org/doc/Documentation/block/stat.txt
}
