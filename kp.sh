#! /bin/bash

# General configuration
kppath="/home/lducos/koha_pannel"
lang="fr"

if [[ ! -d $kppath/var/run ]]
then
mkdir -p $kppath/var/run
fi

if [[ ! -d $kppath/tmp ]]
then
mkdir -p $kppath/tmp
fi

if [[ ! -d $kppath/logs/ ]]
then
mkdir $kppath/logs
fi

if [[ -f $kppath/var/run/kp.pid ]]
then
exit
fi

touch $kppath/var/run/kp.pid

# Set test to run
source $kppath/functions.sh
loadavg 
memory
process
bandwith lo
bandwith lxcbr0
bandwith wlan0
bandwith eth0

###########################################
###########################################
# Output
rm $kppath/webdatas/index.html
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
tail -n 1 $kppath/logs/$i|awk -F ";" '{ if ($6=="ok") color="green" ; else  if ($6=="warning") color="orange" ; else if ($6=="critical") color="red" ; print "<tr ><td>"$2"</td><td bgcolor="color"><a href="$2"_"$3".csv.html>"$3"</a></td><td>"$4"</td><td>"$5"</td></tr>";fflush(stdout)}'>>$kppath/webdatas/index.html
done
echo "</table>">>$kppath/webdatas/index.html

footer >> $kppath/webdatas/index.html

#Graph
cd $kppath/webdatas/
for i in *.csv
do
echo "<html>
<head>
<script type=\"text/javascript\"
  src=\"dygraph-combined-dev.js\"></script>
</head>
<body>
   <div id=\"graphdiv\" style=\"width:800px; height:500px;\"></div>
   <script type=\"text/javascript\">
     new Dygraph(document.getElementById(\"graphdiv\"),
                 \"$i\",  // CSV file with headers
                 { }); // options
   </script>

</body>
</html>" > $i.html
done
rm $kppath/var/run/kp.pid
