#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <DB_USER> <DB_PASSWORD>"
    exit 1
fi

DB_USER="$1"
DB_PASSWORD="$2"
DB_NAMES=("tas" "cas" "issuer" "verifier" "wallet")

export PGPASSWORD="$DB_PASSWORD"

missing_db=0
for db in "${DB_NAMES[@]}"; do
    result=$(docker exec -i "postgre-opendid" psql -h localhost -p 5432 -U "$DB_USER" -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$db';")

    if [ "$result" == "1" ]; then
        echo "Database '$db' exists."
    else
        echo "Database '$db' is missing."
        missing_db=$((missing_db + 1))
    fi
done

if [ "$missing_db" -eq 0 ]; then
    echo "All databases are successfully created!"
    exit 1
else
    echo "Some databases are missing. Please check!"
    exit 0
fi

#docker ps -aq --filter name=postgre-opendid --filter "status=running" | wc -l