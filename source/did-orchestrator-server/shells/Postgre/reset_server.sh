#!/bin/bash

CONTAINER_NAME="postgre-opendid"

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <PGPORT> <PGUSER> <PGPASSWORD> <DB|all>"
  echo "Available DB names: tas, cas, issuer, verifier, wallet"
  echo "Example: $0 5432 postgres secret issuer"
  echo "         $0 5432 postgres secret all"
  exit 1
fi

PGPORT=$1
PGUSER=$2
PGPASSWORD=$3
TARGET=$4

export PGPASSWORD

ALL_DBS=(tas cas issuer verifier wallet)

if [ "$TARGET" = "all" ]; then
  DBS=("${ALL_DBS[@]}")
else
  DBS=("$TARGET")
fi

echo "Using Docker container: $CONTAINER_NAME"
echo "Target database(s): ${DBS[*]}"

for DB in "${DBS[@]}"; do
  echo "Processing database: $DB"

  TABLES=$(docker exec -e PGPASSWORD="$PGPASSWORD" "$CONTAINER_NAME" \
    psql -U "$PGUSER" -p "$PGPORT" -d "$DB" -Atc \
    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';")

  if [ -z "$TABLES" ]; then
    echo "⚠ No tables found in $DB."
    continue
  fi

  echo "Dropping tables in $DB:"
  for table in $TABLES; do
    echo "  - Dropping table: $table"
    docker exec -e PGPASSWORD="$PGPASSWORD" "$CONTAINER_NAME" \
      psql -U "$PGUSER" -p "$PGPORT" -d "$DB" -c "DROP TABLE IF EXISTS \"$table\" CASCADE;"
  done

  echo "All tables dropped from $DB."
done
