#!/bin/bash

CONTAINER_NAME="opendid-besu-node"
DATA_DIR="$(pwd)/data"
CONTRACT_DIR="$(pwd)/did-besu-contract"
PROPERTIES_FILE="$(pwd)/blockchain.properties"
ACCOUNT_INFO_FILE="$(pwd)/besu.dat"
TA_DIR="$(pwd)/TA"
ISSUER_DIR="$(pwd)/Issuer"

echo "Resetting Besu environment..."

docker-compose down -v

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

if [ -d "$TA_DIR" ]; then
    echo "Deleting TA directory: $TA_DIR"
    rm -rf "$TA_DIR"
else
    echo "TA directory not found. Skipping."
fi

if [ -d "$ISSUER_DIR" ]; then
    echo "Deleting Issuer directory: $ISSUER_DIR"
    rm -rf "$ISSUER_DIR"
else
    echo "Issuer directory not found. Skipping."
fi

echo "Removing generated chaincode docker images"
