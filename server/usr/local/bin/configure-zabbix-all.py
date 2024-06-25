#!/usr/bin/python3
# pylint: disable=invalid-name,import-error
"""Do Zabbix configuration"""
import glob
import json
import os
import sys

import requests

state_file = os.path.join(
    os.path.dirname(__file__), "..", "etc", "zabbix", "configured_all"
)

if os.path.exists(state_file):
    sys.exit(0)

API_URL = "http://localhost:8080/api_jsonrpc.php"
# Get authentication token
s = requests.Session()
r = s.post(
    API_URL,
    headers={"Content-Type": "application/json-rpc"},
    json={
        "jsonrpc": "2.0",
        "method": "user.login",
        "params": {"username": "Admin", "password": "zabbix"},
        "id": 1,
    },
    timeout=60,
)
r.raise_for_status()
auth_token = r.json()["result"]

rid = 1
json_files = sorted(
    glob.glob(
        os.path.join(os.path.dirname(__file__), "..", "etc", "zabbix") + "/*.json"
    )
)
for f in json_files:
    with open(f, encoding="utf-8") as fo:
        j = json.load(fo)

    j["auth"] = auth_token
    j["id"] = rid
    rid += 1

    if "params" in j.keys() and "tls_psk" in j["params"].keys():
        with open("/run/secrets/zabbixpsk", encoding="utf-8") as fpsk:
            j["params"]["tls_psk"] = fpsk.read().strip()

    r = s.post(API_URL, headers={"Content-Type": "application/json-rpc"}, json=j)
    r.raise_for_status()

with open(state_file, "w", encoding="utf-8") as fo:
    fo.write("done")
