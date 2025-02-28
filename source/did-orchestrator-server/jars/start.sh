JAR_FILE=$1
PORT=$2
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOGS_PATH="$(dirname "$SCRIPT_DIR")/logs"

mkdir -p "$LOGS_PATH"

if [ ! -f "$JAR_FILE" ]; then
    echo "JAR file not found: $JAR_FILE" >&2
    exit 1
fi

nohup java -jar "$JAR_FILE" > "$LOGS_PATH/server_$PORT.log" 2>&1 &
echo "Server on port $PORT started!"
