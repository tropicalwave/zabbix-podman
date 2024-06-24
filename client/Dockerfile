# checkov:skip=CKV2_DOCKER_1:sudo enabled for Zabbix actions
# checkov:skip=CKV_DOCKER_2:healthcheck not enabled
# checkov:skip=CKV_DOCKER_3:no user necessary
FROM rockylinux/rockylinux:9
ARG ZABBIX_VERSION
ARG ZABBIX_REVISION
RUN rpm -Uvh "https://repo.zabbix.com/zabbix/$ZABBIX_VERSION/rocky/9/x86_64/zabbix-release-${ZABBIX_VERSION}-${ZABBIX_REVISION}.el9.noarch.rpm" \
    && dnf install -y sudo \
        bind-utils \
        zabbix-agent2 \
        zabbix-agent2-plugin-* \
    && dnf clean all

COPY etc/sudoers.d/* /etc/sudoers.d/
COPY etc/systemd/system/* /etc/systemd/system/
COPY usr/local/bin/* /usr/local/bin/

RUN systemctl enable prepare-zabbix-agent zabbix-agent2

CMD ["/usr/sbin/init"]
