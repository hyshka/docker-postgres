# Postgres Docker Container

## General Usage

```
## start postgres
make up

# enter shell of container
make enter

# stop container and remove it
make clean

# list dbs
make list_db

# list tables of database
make list_tables db=db_name

## create db
make createdb db=db_name

## drop db
make dropdb db=db_name

## import sql dump to specific db
make importdb db=db_name dump=dump.sql
```
