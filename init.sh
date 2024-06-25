#!/bin/bash
if [ -f .mysql-root-pw ]; then
    echo "Already initialized"
    exit 0
fi

pwgen -N 1 >.mysql-root-pw
pwgen -N 1 >.mysql-zabbix-pw
openssl rand -hex 32 >.zabbix_agents.psk
