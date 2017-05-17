.PHONY: build

SHELL := /bin/bash
CONTAINERNAME=postgres

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Bring the container up
	docker-compose up

down: ## Stop the container
	docker-compose stop || echo 'No container to stop'

enter: ## Enter the running container
	docker exec -it $(CONTAINERNAME) /bin/bash

clean: ## Remove the image and any stopped containers
	docker-compose down || echo 'No container to remove'

list_tables: ## List postgres tables for database
	docker exec -it $(CONTAINERNAME) psql -Upostgres -d $(db) -c '\z'

list_db: ## List postgres databases
	docker exec -it $(CONTAINERNAME) psql -Upostgres -c '\l'

createdb: ## Create a new databse
	docker exec -i $(CONTAINERNAME) /bin/bash -c "createdb -Upostgres $(db)"

dropdb: ## Drop a database
	docker exec -i $(CONTAINERNAME) /bin/bash -c "dropdb -Upostgres $(db)"

importdb: ## Import sql dump to a database (db=database_name, dump=database.sql)
	docker exec -i $(CONTAINERNAME) psql -Upostgres -d $(db) < $(dump)

importdump: ## Import sql dump with multiple databases
	docker exec -i $(CONTAINERNAME) psql -Upostgres postgres < $(dump)

exportdb: ## Export sql dump to a database (db=database_name)
	docker exec -i $(CONTAINERNAME) pg_dump -Upostgres $(db) > /tmp/$(db)-$(shell date +%F).sql

exportdump: ## Export sql dump with all databases
	docker exec -i $(CONTAINERNAME) pg_dumpall -Upostgres > $(dump)
