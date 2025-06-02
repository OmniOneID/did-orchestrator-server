#!/bin/bash

JAR_FILE=$1
PORT=$2
CONFIG_PATH=$3
SERVER_IP=$4

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOGS_PATH="$(dirname "$SCRIPT_DIR")/logs"

mkdir -p "$LOGS_PATH"

if [ ! -f "$JAR_FILE" ]; then
    echo "JAR file not found: $JAR_FILE" >&2
    exit 1
fi

if [ -z "$CONFIG_PATH" ] || [ ! -f "$CONFIG_PATH" ]; then
    echo "ERROR: Configuration file not found: $CONFIG_PATH" >&2
    exit 1
fi

LOG_FILE="$LOGS_PATH/lss.log"


nohup java -jar "$JAR_FILE" --server.port="$PORT" --spring.config.additional-location="file:$CONFIG_PATH" > "$LOG_FILE" 2>&1 &

echo "Server on port $PORT started with config: $CONFIG_PATH"
echo "Logging to: $LOG_FILE"
# Run easy-adoption injector
sh "$SCRIPT_DIR/easy-adoption-injector.sh" "$SERVER_IP"