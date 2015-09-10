#! /bin/bash

# General configuration
lang=fr

# Set test to run
source functions.sh
loadavg
memory
###########################################
###########################################
# Output
source generate_html.sh
headers $lang > webdatas/index.html

echo "<table>">>webdatas/index.html
echo "<tr>
    <th>Server Name</th>
    <th>Check Name</th>
    <th>Values</th>
    <th>Type of datas</th>
</tr>">>webdatas/index.html
for i in $(ls logs)
do 
tail -n 1 $PWD/logs/$i|awk -F ";" '{print "<tr><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td></tr>";fflush(stdout)}'>>webdatas/index.html
done
echo "</table>">>webdatas/index.html

footer >> webdatas/index.html

