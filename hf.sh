#!/bin/bash

source .env

init_hf () {
    SPLUNK_HOST="hf$1"
    DB_HOST="cmdb$1"

    echo "Wait for DB Connect on ${SPLUNK_HOST}"
    http_status=""
    until [[ $http_status -eq 200 ]]; do
    sleep 10
    http_status=$(curl -k -s -o /dev/null -w "%{http_code}" -u admin:$SPLUNK_PASSWORD  https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities)
    echo "Status: $http_status on ${SPLUNK_HOST}"
    done

    echo "Create identity on ${SPLUNK_HOST}"
    curl -k -s -X POST  -u admin:$SPLUNK_PASSWORD  \
    https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities \
    -d "{\"name\":\"$DB_USER\",\"username\":\"$DB_USER\",\"password\":\"$DB_PASSWORD\"}"
    echo "Identity created on ${SPLUNK_HOST}"

    echo "Create MySQL Connection on ${SPLUNK_HOST}"
    curl -k -s -X POST  -u admin:$SPLUNK_PASSWORD \
    https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/connections \
    -d "{\"name\":\"${DB_NAME}-${DB_HOST}\", \"connection_type\":\"mysql\",  \
    \"host\":\"${DB_HOST}\", \"database\":\"${DB_NAME}\", \"identity\":\"${DB_USER}\", \
    \"port\":\"3306\", \"timezone\":\"${TZ}\"}"
    echo "Connection created on ${SPLUNK_HOST}"
}

for hf in {1..2}
do
  init_hf $hf
done
