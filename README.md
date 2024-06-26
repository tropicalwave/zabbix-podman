# zabbix-podman

[![GitHub Super-Linter](https://github.com/tropicalwave/zabbix-podman/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

## Introduction

This deployment sets up a Zabbix environment (server + three agents) with
the following characteristics:

* encrypted communication between server and agents
* agents are autoregistered on server
* a trigger action is installed (should a nginx service
  fail on some agent, it will be autorestarted)

## Quickstart

```bash
./init.sh
podman-compose build
podman-compose up -d
```

After some time, the Zabbix server will be available
at <http://localhost:8080>:

* user: Admin
* password: zabbix
