#!/bin/bash

INPUT_JSON="$1"

HOST_1_IP=$(echo $INPUT_JSON | jq -r '.["ip-address-instance-1"].["value"]')
HOST_2_IP=$(echo $INPUT_JSON | jq -r '.["ip-address-instance-2"].["value"]')

cat <<EOL > ./ansible/inventory.ini
app_server1 ansible_host=$HOST_1_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform_gce_key
app_server2 ansible_host=$HOST_1_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/terraform_gce_key

[web-servers]
app_server1
app_server2

[web-servers:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOL