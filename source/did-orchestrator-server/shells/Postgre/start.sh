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

echo "Waiting for database to be ready..."

TIMEOUT=300
ELAPSED=0

until docker exec postgre-opendid pg_isready -U postgres > /dev/null 2>&1; do
 echo "Waiting for PostgreSQL... (${ELAPSED}s elapsed)"
 sleep 2
 ELAPSED=$((ELAPSED + 2))
 
 if [ $ELAPSED -ge $TIMEOUT ]; then
   echo "Timeout: PostgreSQL did not become ready within 5 minutes."
   exit 1
 fi
done

echo "PostgreSQL is ready."

docker exec postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE tas;"
docker exec postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE cas;"
docker exec postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE issuer;"
docker exec postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE verifier;"
docker exec postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE wallet;"
docker exec postgre-opendid psql -U $POSTGRES_USER -c "CREATE DATABASE lss;"
