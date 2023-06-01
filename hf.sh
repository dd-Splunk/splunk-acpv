#!/bin/bash

SPLUNK_HOST=$(hostname)
SPLUNK_PASSWORD=Splunk4Me

# Check if this host is an Heavy Forwarder
if [[ ! $SPLUNK_HOST =~ ^hf([0-9]+) ]]; then exit 0; fi
# Database host has same numerical suffix as this HF
DB_HOST="cmdb${BASH_REMATCH[1]}"
DB_NAME=splunkdb
DB_USER=splunk
# Password will be initialized in Makefile using envsubst
DB_PASSWORD=jiw1wTEwTS65b9kU5P+8Ng==

# Now that Splunk is up
echo -e "\nWait for DB Connect to startup"
http_status=""
until [[ $http_status -eq 200 ]]; do
  sleep 10
  http_status=$(curl -k -s -o /dev/null -w "%{http_code}" -u admin:$SPLUNK_PASSWORD  https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities)
  echo "Status: $http_status"
done

# https://answers.splunk.com/answers/516111/splunk-db-connect-v3-automated-programmatic-creati.html
# Create identity
curl -k -s -X POST  -u admin:$SPLUNK_PASSWORD  \
https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/identities \
-d "{\"name\":\"$DB_USER\",\"username\":\"$DB_USER\",\"password\":\"$DB_PASSWORD\"}"
echo ""

# Create MySQL Connection
  curl -k -s -X POST  -u admin:$SPLUNK_PASSWORD \
  https://$SPLUNK_HOST:8089/servicesNS/nobody/splunk_app_db_connect/db_connect/dbxproxy/connections \
  -d "{\"name\":\"${DB_NAME}-${DB_HOST}\", \"connection_type\":\"mysql\",  \
  \"host\":\"${DB_HOST}\", \"database\":\"${DB_NAME}\", \"identity\":\"${DB_USER}\", \
  \"port\":\"3306\", \"timezone\":\"${TZ}\"}"
  echo ""
