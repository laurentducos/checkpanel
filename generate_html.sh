#! /bin/bash

function headers {
echo "<!doctype html>
<html lang=\"$1\">
<head>
  <meta http-equiv="refresh" content="20">
  <meta charset=\"utf-8\">
  <title>Tiny Pannel</title>
  <link rel=\"stylesheet\" href=\"style.css\">
  <script src=\"script.js\"></script>
</head>
<body>
<h1>Tiny Pannel</h1>
<p>
<ul>
<li>green=ok</li>
<li>orange=warning</li>
<li>red=critical</li>
</ul>
</p>
"
}

function footer {
echo "
  <!-- End of story -->
</body>
</html>"
}

