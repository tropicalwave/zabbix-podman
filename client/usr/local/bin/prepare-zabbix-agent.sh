#!/bin/bash
set -e

SERVER_IP="$(dig +short server)"
MY_IP="$(dig +short "$(hostname)")"
MY_HOSTNAME="$(host "$MY_IP" | head -n 1 | awk '{ print $NF }' | sed "s/\.$//")"
sed -i /etc/zabbix/zabbix_agent2.conf \
    -e "s/^Server=.*/Server=$SERVER_IP/" \
    -e "s/^ServerActive=.*/ServerActive=$SERVER_IP/" \
    -e "s/# HostMetadata=.*/HostMetadata=Linux/" \
    -e "s/^Hostname=.*/Hostname=$MY_HOSTNAME/"
echo 'AllowKey=system.run[*]' >>/etc/zabbix/zabbix_agent2.conf
