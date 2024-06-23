#!/bin/bash
set -e
HOME=/root

if [ -f "$HOME/.root.my.cnf" ]; then
    exit 0
fi

MYSQLROOTPW="$(cat /run/secrets/mysqlrootpw)"
MYSQLZABBIXPW="$(cat /run/secrets/mysqlzabbixpw)"

mysql -sfu root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQLROOTPW';
DROP USER ''@'localhost';
DROP USER ''@'$(hostname)';
DROP DATABASE test;
FLUSH PRIVILEGES;
EOF

cat >"$HOME/.root.my.cnf" <<EOF
[client]
user=root
password=$MYSQLROOTPW
EOF

cat >"$HOME/.zabbix.my.cnf" <<EOF
[client]
user=zabbix
password=$MYSQLZABBIXPW
EOF

mysql --defaults-file="$HOME/.root.my.cnf" <<EOF
create database zabbix character set utf8mb4 collate utf8mb4_bin;
create user zabbix@localhost identified by '$MYSQLZABBIXPW';
grant all privileges on zabbix.* to zabbix@localhost;
set global log_bin_trust_function_creators = 1;
EOF

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --defaults-file="$HOME/.zabbix.my.cnf" --default-character-set=utf8mb4 zabbix

mysql --defaults-file="$HOME/.root.my.cnf" -e "set global log_bin_trust_function_creators = 0;"

sed -i "s/# DBPassword=/DBPassword=$MYSQLZABBIXPW/" /etc/zabbix/zabbix_server.conf
sed -i "s/.*listen /listen /;s/.*server_name /server_name /" /etc/nginx/conf.d/zabbix.conf
