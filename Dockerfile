# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
FROM rockylinux/rockylinux:9
ARG ZABBIX_VERSION
ARG ZABBIX_REVISION
RUN rpm -Uvh "https://repo.zabbix.com/zabbix/$ZABBIX_VERSION/rocky/9/x86_64/zabbix-release-${ZABBIX_VERSION}-${ZABBIX_REVISION}.el9.noarch.rpm" \
    && dnf install -y glibc-langpack-en \
        python3-requests \
        mysql \
	mysql-server \
	zabbix-server-mysql \
	zabbix-web-mysql \
	zabbix-nginx-conf \
	zabbix-sql-scripts \
	zabbix-selinux-policy \
	zabbix-agent2 \
	zabbix-agent2-plugin-* \
    && dnf clean all

COPY etc/systemd/system/* /etc/systemd/system/
COPY usr/local/bin/* /usr/local/bin/
COPY usr/local/etc/zabbix/* /usr/local/etc/zabbix/

RUN systemctl enable mysqld \
        prepare-database \
	prepare-zabbix \
	configure-zabbix-all \
	configure-zabbix-web \
	nginx \
	php-fpm \
	zabbix-agent2 \
        zabbix-server

CMD ["/usr/sbin/init"]
