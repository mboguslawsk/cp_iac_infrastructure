#!/bin/bash

INPUT_JSON="$1"

HOST_1_IP=$(echo $INPUT_JSON | jq -r '.["ip-address-instance-1"].["value"]')
HOST_2_IP=$(echo $INPUT_JSON | jq -r '.["ip-address-instance-2"].["value"]')

cat <<EOL > ./ansible/inventory.ini
[web-servers]
app_server1 $HOST_1_IP ansible_user=ubuntu
app_server2 $HOST_1_IP ansible_user=ubuntu
EOL