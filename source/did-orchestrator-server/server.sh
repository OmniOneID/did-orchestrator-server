#!/usr/bin/env bash

set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$APP_DIR/../.." && pwd)"
BRANCH="release/QA-v3.0.0"
JAR="$APP_DIR/build/libs/did-orchestrator-server-3.0.0.jar"
LOG_DIR="$APP_DIR/logs"
LOG_FILE="$LOG_DIR/orchestrator.log"
BUILD_LOG="$LOG_DIR/orchestrator-build.log"
PID_FILE="$LOG_DIR/orchestrator.pid"
BASE_URL="http://127.0.0.1:9001"

usage() {
    echo "Usage: ./server.sh {stop|start|status|pull}" >&2
    exit 2
}

is_healthy() {
    curl --max-time 2 -fsS "$BASE_URL/actuator/health" 2>/dev/null | grep -q '"status":"UP"'
}

is_orchestrator() {
    curl --max-time 2 -fsS "$BASE_URL/configs" 2>/dev/null | grep -q '"services"'
}

managed_pid() {
    local pid
    [[ -f "$PID_FILE" ]] || return 1
    pid="$(cat "$PID_FILE")"
    [[ "$pid" =~ ^[0-9]+$ ]] || return 1
    kill -0 "$pid" 2>/dev/null || return 1
    ps -p "$pid" -o args= 2>/dev/null | grep -Fq "$JAR" || return 1
    printf '%s\n' "$pid"
}

wait_for_stop() {
    local attempt
    for attempt in {1..15}; do
        if ! is_orchestrator; then
            rm -f "$PID_FILE"
            echo "Orchestrator stopped."
            return 0
        fi
        sleep 1
    done
    return 1
}

stop_server() {
    local pid
    if is_orchestrator; then
        curl --max-time 5 -fsS -X POST "$BASE_URL/actuator/shutdown" >/dev/null 2>&1 || true
        if wait_for_stop; then return 0; fi
    fi

    if pid="$(managed_pid)"; then
        kill -TERM "$pid"
        if wait_for_stop; then return 0; fi
        echo "Orchestrator did not stop. Check PID $pid and $LOG_FILE." >&2
        return 1
    fi

    if is_healthy; then
        echo "Port 9001 is in use, but this script cannot identify its process." >&2
        return 1
    fi
    rm -f "$PID_FILE"
    echo "Orchestrator is already stopped."
}

start_server() {
    local attempt pid
    if is_healthy; then
        echo "Port 9001 is already serving an application. Stop it before starting." >&2
        return 1
    fi
    if pid="$(managed_pid)"; then
        echo "Orchestrator process $pid is running but not healthy. Check $LOG_FILE." >&2
        return 1
    fi

    mkdir -p "$LOG_DIR"
    : > "$BUILD_LOG"
    echo "Building the admin UI... (log: $BUILD_LOG)"
    (cd "$APP_DIR/admin" && npm ci && sh build.sh) >> "$BUILD_LOG" 2>&1 || {
        echo "Admin UI build failed. Check $BUILD_LOG." >&2
        return 1
    }
    echo "Building the Orchestrator JAR..."
    (cd "$APP_DIR" && ./gradlew bootJar) >> "$BUILD_LOG" 2>&1 || {
        echo "Orchestrator JAR build failed. Check $BUILD_LOG." >&2
        return 1
    }

    (
        cd "$APP_DIR"
        nohup java -jar "$JAR" >> "$LOG_FILE" 2>&1 < /dev/null &
        echo $! > "$PID_FILE"
    )
    for attempt in {1..30}; do
        if is_healthy; then
            echo "Orchestrator started on port 9001 (PID $(cat "$PID_FILE"))."
            echo "Log: $LOG_FILE"
            return 0
        fi
        if ! pid="$(managed_pid)"; then
            echo "Orchestrator exited during startup. Check $LOG_FILE." >&2
            rm -f "$PID_FILE"
            return 1
        fi
        sleep 1
    done
    echo "Orchestrator did not become healthy within 30 seconds. Check $LOG_FILE." >&2
    return 1
}

status_server() {
    local pid
    if is_healthy && is_orchestrator; then
        if pid="$(managed_pid)"; then
            echo "UP (port 9001, PID $pid)"
        else
            echo "UP (port 9001, started outside this script)"
        fi
        echo "Log: $LOG_FILE"
    elif pid="$(managed_pid)"; then
        echo "DOWN (process $pid is running; check $LOG_FILE)"
        return 1
    else
        echo "DOWN (port 9001)"
        return 1
    fi
}

pull_source() {
    local current_branch
    current_branch="$(git -C "$REPO_DIR" branch --show-current)"
    if [[ "$current_branch" != "$BRANCH" ]]; then
        echo "Current branch is '$current_branch'; switch to '$BRANCH' first." >&2
        return 1
    fi
    git -C "$REPO_DIR" pull --ff-only origin "$BRANCH"
    echo "Source updated. Run './server.sh stop' and './server.sh start' to apply it."
}

case "${1:-}" in
    stop) stop_server ;;
    start) start_server ;;
    status) status_server ;;
    pull) pull_source ;;
    *) usage ;;
esac
