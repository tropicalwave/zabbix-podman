#!/bin/bash
set -e
MYSQLZABBIXPW="$(cat /run/secrets/mysqlzabbixpw)"

if [ -f /etc/zabbix/web/zabbix.conf.php ]; then
    exit 0
fi

cat >/etc/zabbix/web/zabbix.conf.php <<EOF
<?php
// Zabbix GUI configuration file.

\$DB['TYPE']                     = 'MYSQL';
\$DB['SERVER']                   = 'localhost';
\$DB['PORT']                     = '0';
\$DB['DATABASE']                 = 'zabbix';
\$DB['USER']                     = 'zabbix';
\$DB['PASSWORD']                 = '$MYSQLZABBIXPW';

// Schema name. Used for PostgreSQL.
\$DB['SCHEMA']                   = '';

// Used for TLS connection.
\$DB['ENCRYPTION']               = false;
\$DB['KEY_FILE']                 = '';
\$DB['CERT_FILE']                = '';
\$DB['CA_FILE']                  = '';
\$DB['VERIFY_HOST']              = false;
\$DB['CIPHER_LIST']              = '';

// Vault configuration. Used if database credentials are stored in Vault secrets manager.
\$DB['VAULT']                    = '';
\$DB['VAULT_URL']                = '';
\$DB['VAULT_PREFIX']             = '';
\$DB['VAULT_DB_PATH']            = '';
\$DB['VAULT_TOKEN']              = '';
\$DB['VAULT_CERT_FILE']          = '';
\$DB['VAULT_KEY_FILE']           = '';
// Uncomment to bypass local caching of credentials.
// \$DB['VAULT_CACHE']           = true;

// Uncomment and set to desired values to override Zabbix hostname/IP and port.
// \$ZBX_SERVER                  = '';
// \$ZBX_SERVER_PORT             = '';

\$ZBX_SERVER_NAME                = 'zabbix';

\$IMAGE_FORMAT_DEFAULT   = IMAGE_FORMAT_PNG;

// Uncomment this block only if you are using Elasticsearch.
// Elasticsearch url (can be string if same url is used for all types).
//\$HISTORY['url'] = [
//      'uint' => 'http://localhost:9200',
//      'text' => 'http://localhost:9200'
//];
// Value types stored in Elasticsearch.
//\$HISTORY['types'] = ['uint', 'text'];

// Used for SAML authentication.
// Uncomment to override the default paths to SP private key, SP and IdP X.509 certificates, and to set extra settings.
//\$SSO['SP_KEY']                        = 'conf/certs/sp.key';
//\$SSO['SP_CERT']                       = 'conf/certs/sp.crt';
//\$SSO['IDP_CERT']              = 'conf/certs/idp.crt';
//\$SSO['SETTINGS']              = [];

// If set to false, support for HTTP authentication will be disabled.
// \$ALLOW_HTTP_AUTH = true;
EOF
