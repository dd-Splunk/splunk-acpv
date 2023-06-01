.SILENT:
SHELL = bash

.env:
	echo ".env: Create env from template"

	SPL_P=Splunk4Me DB_P=Password42 envsubst < tpl.env | op inject -f > .env

env: .env
	echo "env: Create env from template"
	SPL_P=Splunk4Me DB_P=Password42 envsubst < tpl.env | op inject -f > .env

csv: env
	echo "Create csv with demo data"
	# source .venv/bin/activate && python init-csv.py

sql: csv
	echo "Create SQL initialization files"
	source .venv/bin/activate && ./init-sql.sh

up: sql
	echo "Powering up"
	docker compose build
	docker compose up -d

down:
	echo "Powering down"
	docker compose down

clean:
	echo "Powering down and removing volumes"
	docker compose down -v
	rm -f .env

spl:
	echo "Downloading latest app version from container"
	./get-spl.sh

all:

.PHONY:	all env clean test
