#!/bin/bash

ADDRESS_FILE=$1
echo "Current directory: $(pwd)"

if [ ! -f "$ADDRESS_FILE" ]; then
    echo "Read failed (0): Address file not found: $ADDRESS_FILE"
    exit 0
fi

CONTRACT_ADDRESS=$(grep "OpenDID deployed to:" "$ADDRESS_FILE" | tail -n 1 | awk '{print $4}')

if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "Read failed (0): Failed to extract contract address from file."
    exit 0
fi

RESPONSE=$(curl -s --fail -X POST --url http://localhost:8545 \
  --header 'Content-Type: application/json' \
  --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getCode\",\"params\":[\"$CONTRACT_ADDRESS\",\"latest\"],\"id\":1}")

if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
    echo "Connection failed (0): Node not running or cannot connect."
    echo "$RESPONSE"
    exit 0
fi

RESULT=$(echo "$RESPONSE" | jq -r '.result')

echo "Status result: $RESULT"

if [ "$RESULT" == "0x" ]; then
    echo "Deployment failed (0): Contract code is empty ($CONTRACT_ADDRESS)"
    exit 0
else
    echo "Deployment success (200): Contract code found ($CONTRACT_ADDRESS)"
    exit 200
fi
