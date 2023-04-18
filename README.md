# DB Connect with multiple dataases

## Installation steps

1. Create `.env` file containing credentials from template
2. Generate all `.csv` files containing simulated data
3. Generate initialization `create-db.sql` file that contains
   - the MYSQL `splunk`user grants
   - tables schemas based on the corresponding csv file structure
   - table load based on the corresponding csv file content
4. Start the docker environment

- Splunk + apps
- MySQL DB server

5. Wait for DBConnect APIs to be online
6. Configure DBX using API calls

- create identity
- create DB connection to MySQL DB server

7. Enjoy

## Splunkbase App in use

* 2686: DB Connect
* 6150: JDBC for Microsoft SQL Server
* 6152: JDBC for Postgres
* 6154: JDBC for MySQL

## To Do

* [ ] Fix Makefile dependencies
  * [ ] .env / env confusion between the two
  * [ ] sql is never triggered
