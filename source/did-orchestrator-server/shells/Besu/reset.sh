#!/bin/bash

CONTAINER_NAME="opendid-besu-node"
DATA_DIR="$(pwd)/data"
CONTRACT_DIR="$(pwd)/did-besu-contract"
PROPERTIES_FILE="$(pwd)/blockchain.properties"
ACCOUNT_INFO_FILE="$(pwd)/besu.dat"

echo "Resetting Besu environment..."

if [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Removing container: $CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
else
    echo "Container $CONTAINER_NAME does not exist. Skipping."
fi

if [ -d "$CONTRACT_DIR" ]; then
    echo "Deleting contract directory: $CONTRACT_DIR"
    rm -rf "$CONTRACT_DIR"
else
    echo "Contract directory not found: $CONTRACT_DIR"
fi

if [ -d "$DATA_DIR" ]; then
    echo "Deleting data directory: $DATA_DIR"
    rm -rf "$DATA_DIR"
else
    echo "Data directory not found: $DATA_DIR"
fi

if [ -f "$PROPERTIES_FILE" ]; then
    echo "Deleting blockchain.properties: $PROPERTIES_FILE"
    rm -f "$PROPERTIES_FILE"
else
    echo "blockchain.properties not found. Skipping."
fi

if [ -f "$ACCOUNT_INFO_FILE" ]; then
    echo "Deleting account data: $ACCOUNT_INFO_FILE"
    rm -f "$ACCOUNT_INFO_FILE"
else
    echo "account data not found. Skipping."
fi

echo "Removing generated chaincode docker images"
