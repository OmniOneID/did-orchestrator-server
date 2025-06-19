#!/bin/bash

JAR_FILE=$1
PORT=$2
SERVER_IP=$3

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOGS_PATH="$(dirname "$SCRIPT_DIR")/../logs"

mkdir -p "$LOGS_PATH"

if [ ! -f "$JAR_FILE" ]; then
    echo "JAR file not found: $JAR_FILE" >&2
    exit 1
fi

LOG_FILE="$LOGS_PATH/lss.log"


nohup java -jar "$JAR_FILE" --server.port="$PORT" > "$LOG_FILE" 2>&1 &

echo "Server on port $PORT started"
echo "Logging to: $LOG_FILE"
# Run easy-adoption injector
sh "$SCRIPT_DIR/easy-adoption-injector.sh" "$SERVER_IP"