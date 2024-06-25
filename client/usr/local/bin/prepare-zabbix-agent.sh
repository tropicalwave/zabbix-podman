#!/bin/bash
set -e

PSK_FILE=/etc/zabbix/zabbix_agent.psk
SERVER_IP="$(dig +short server)"
MY_IP="$(dig +short "$(hostname)")"
MY_HOSTNAME="$(host "$MY_IP" | head -n 1 | awk '{ print $NF }' | sed "s/\.$//")"
cp /run/secrets/zabbixpsk "$PSK_FILE"
chown zabbix "$PSK_FILE"
chmod 700 "$PSK_FILE"
sed -i /etc/zabbix/zabbix_agent2.conf \
    -e "s/^Server=.*/Server=$SERVER_IP/" \
    -e "s/^ServerActive=.*/ServerActive=$SERVER_IP/" \
    -e "s/# HostMetadata=.*/HostMetadata=Linux/" \
    -e "s/^Hostname=.*/Hostname=$MY_HOSTNAME/" \
    -e "s/^# TLSAccept=.*/TLSAccept=psk/" \
    -e "s/^# TLSConnect=.*/TLSConnect=psk/" \
    -e "s/^# TLSPSKFile=.*/TLSPSKFile=\/etc\/zabbix\/zabbix_agent.psk/" \
    -e "s/^# TLSPSKIdentity=.*/TLSPSKIdentity=MyPSK/"
echo 'AllowKey=system.run[*]' >>/etc/zabbix/zabbix_agent2.conf
