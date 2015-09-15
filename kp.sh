#! /bin/bash

# General configuration
kppath="/home/lducos/koha_pannel"
lang="fr"

if [[ ! -d $kppath/logs/ ]]
then
mkdir $kppath/logs
fi

# Set test to run
source $kppath/functions.sh
loadavg 
memory
tester
bandwith tun0
bandwith wlan0

###########################################
###########################################
# Output
source $kppath/generate_html.sh
headers $lang > $kppath/webdatas/index.html
echo "<table>">>$kppath/webdatas/index.html
echo "<tr>
    <th>Server Name</th>
    <th>Check Name</th>
    <th>Values</th>
    <th>Type of datas</th>
</tr>">>$kppath/webdatas/index.html
for i in $(ls $kppath/logs)
do 
tail -n 1 $kppath/logs/$i|awk -F ";" '{ if ($6=="ok") color="green" ; else  if ($6=="warning") color="orange" ; else if ($6=="critical") color="red" ; print "<tr ><td>"$2"</td><td bgcolor="color">"$3"</td><td>"$4"</td><td>"$5"</td></tr>";fflush(stdout)}'>>$kppath/webdatas/index.html
done
echo "</table>">>$kppath/webdatas/index.html

footer >> $kppath/webdatas/index.html

echo '<html>
<head>
<script type="text/javascript"
  src="dygraph-combined-dev.js"></script>
</head>
<body>
<div id="graphdiv2"
  style="width:500px; height:300px;"></div>
<script type="text/javascript">
  g2 = new Dygraph(
    document.getElementById("graphdiv2"),
    "loadavg.csv", // path to CSV file
    {}          // options
  );
</script>
</body>
</html>'
