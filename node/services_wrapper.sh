#!/usr/bin/env bash

# Start the node exporter
echo "STARTING NODE EXPORTER: /usr/local/bin/node_exporter &"
/usr/local/bin/node_exporter &

echo "STARTING LOAD GENERATOR: stress ${@}"
# Start load generator
stress $@
