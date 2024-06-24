#!/bin/bash
set -e
HOME=/root
MYSQLZABBIXPW="$(cat /run/secrets/mysqlzabbixpw)"

if ! grep "# DBPassword=" /etc/zabbix/zabbix_server.conf; then
    exit 0
fi

sed -i "s/# DBPassword=/DBPassword=$MYSQLZABBIXPW/" /etc/zabbix/zabbix_server.conf
sed -i "s/.*listen /listen /;s/.*server_name /server_name /" /etc/nginx/conf.d/zabbix.conf
