#! /bin/bash

# General configuration
lang=fr

# Set test to run
source functions.sh
loadavg
memory

# Output
source generate_html.sh
headers $lang > webdatas/index.html
footer >> webdatas/index.html
