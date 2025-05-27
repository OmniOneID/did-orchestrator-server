#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <PGPORT> <PGUSER> <PGPASSWORD>"
  echo "Example: $0 5430 omn omn"
  exit 1
fi

PGPORT=$1
PGUSER=$2
PGPASSWORD=$3
PGHOST=localhost

export PGPASSWORD

TARGET_DBS=(tas cas issuer verifier wallet)

echo "PostgreSQL Drop Tables Script (excluding 'lss')"
echo "Host: $PGHOST  Port: $PGPORT  User: $PGUSER"

for DB in "${TARGET_DBS[@]}"; do
  echo "Processing database: $DB"

  TABLES=$(psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$DB" -Atc \
    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';")

  if [ -z "$TABLES" ]; then
    echo "No tables found in $DB."
    continue
  fi

  echo "Dropping tables in $DB:"
  for table in $TABLES; do
    echo "  - Dropping table: $table"
    psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$DB" -c "DROP TABLE IF EXISTS \"$table\" CASCADE;"
  done

  echo "All tables dropped from $DB."
done
