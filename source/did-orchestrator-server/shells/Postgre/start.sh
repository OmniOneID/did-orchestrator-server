#!/bin/bash

POSTGRES_PORT=$1
POSTGRES_USER=$2
POSTGRES_PASSWORD=$3
POSTGRES_DB=$4

export POSTGRES_PORT
export POSTGRES_USER
export POSTGRES_PASSWORD
export POSTGRES_DB

docker-compose up -d

sleep 10

docker exec -it postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE tas;"
docker exec -it postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE cas;"
docker exec -it postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE issuer;"
docker exec -it postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE verifier;"
docker exec -it postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE wallet;"
docker exec -it postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE lss;"
