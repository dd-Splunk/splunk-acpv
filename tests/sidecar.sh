#!/bin/bash

source .env

generate_identity_data () {
  cat <<EOF
{
  "name": "${DB_USER}",
  "username": "${DB_USER}",
  "password": "${DB_PASSWORD}"
}
EOF
}

generate_connection_data () {
  cat <<EOF
{
  "name": "${DB_NAME}-${DB_HOST}",
  "connection_type": "mysql",
  "host": "${DB_HOST}",
  "database": "${DB_NAME}",
  "identity": "${DB_USER}",
  "port": "3306",
  "timezone": "${TZ}"
}
EOF
}

generate_input_data () {
  cat <<EOF
{
  "name": "rising-${DB_TABLE}",
  "description": "rising-${DB_TABLE}",
  "query": "SELECT * FROM \`${DB_NAME}\`.\`${DB_TABLE}\` WHERE id >? ORDER BY id ASC",
  "interval": "*/1 * * * * ",
  "index": "${DB_TABLE}",
  "mode": "rising",
  "connection": "${DB_NAME}-${DB_HOST}",
  "rising_column_name": "id",
  "rising_column_index": 1,
  "timestamp_column_index": null,
  "timestamp_format": null,
  "timestampType": "current",
  "sourcetype": "acpv:${DB_TABLE}",
  "checkpoint": null
}
EOF
}

dbx_input () {
  DB_TABLE="$1"

  echo "Create DBX input ${DB_NAME}.${DB_TABLE} on ${SPLUNK_HOST}"
  curl -k -s -X POST  -u admin:$SPLUNK_PASSWORD \
    https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/inputs \
    -d "$(generate_input_data)"

}

init_hf () {
    SPLUNK_HOST="splunk.dessy.one"
    DB_HOST="cmdb$1"

    echo "Wait for DB Connect on ${SPLUNK_HOST}"
    http_status=""
    until [[ $http_status -eq 200 ]]; do
      sleep 1
      http_status=$(curl -k -s -o /dev/null -w "%{http_code}" -u admin:$SPLUNK_PASSWORD  https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities)
      echo "Status: $http_status on ${SPLUNK_HOST}"
    done

    echo "Create identity on ${SPLUNK_HOST}"
    curl -k -s -X POST  -u admin:$SPLUNK_PASSWORD  \
    https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities \
    -d "$(generate_identity_data)"

    echo "Create MySQL Connection on ${SPLUNK_HOST}"
    curl -k -s -X POST  -u admin:$SPLUNK_PASSWORD \
    https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/connections \
    -d "$(generate_connection_data)"
    echo "MySQL Connection created on ${SPLUNK_HOST}"

    for Table in assets
    do
      dbx_input $Table
    done

}

for hf in {1..1}
do
  init_hf $hf
done
