#! /bin/bash

function headers {
echo "<!doctype html>
<html lang=\"$1\">
<head>
  <meta http-equiv="refresh" content="60">
  <meta charset=\"utf-8\">
  <title>Little Checker</title>
  <link rel=\"stylesheet\" href=\"style.css\">
  <script src=\"script.js\"></script>
</head>
<body>
<h1>Console</h1>
"
}

function footer {
echo "
  <!-- End of story -->
</body>
</html>"
}

