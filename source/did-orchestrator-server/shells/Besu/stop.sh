#!/bin/bash

CONTAINER_NAME="opendid-besu-node"

echo "Attempting to stop Besu container..."

if [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
        echo "Stopping running container: $CONTAINER_NAME"
        docker stop "$CONTAINER_NAME"
    else
        echo "Container is already stopped: $CONTAINER_NAME"
    fi

    # Optionally remove the container (uncomment to enable)
    # echo "Removing container..."
    # docker rm "$CONTAINER_NAME"
else
    echo "Container does not exist: $CONTAINER_NAME"
fi
