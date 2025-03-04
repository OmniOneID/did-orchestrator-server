#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ]; then
  echo "Usage: $0 <wallet filename> <did doc filename> <did> <controller> <type : TAS or ENTITY>"
  exit 1
fi

#filename .wallet / .did
WALLET_FILENAME=$1

#filename .wallet / .did
DID_FILENAME=$2

#did name
DID=$3

#controller did
CONTROLLER=$4

#type : TAS or ENTITY
TYPE=$5

if [ "$TYPE" == "TAS" ]; then
  java -jar did-cli-tool-server-1.0.0.jar did createDid -m "$WALLET_FILENAME" -f "$DID_FILENAME" -id "$DID" -ci "$CONTROLLER" -mi assert -ai auth -ki keyagree -ii invoke -p
elif [ "$TYPE" == "ENTITY" ]; then
  java -jar did-cli-tool-server-1.0.0.jar did createDid -m "$WALLET_FILENAME" -f "$DID_FILENAME" -id "$DID" -ci "$CONTROLLER" -mi assert -ai auth -ki keyagree -p
else
    echo "Invalid type. Please use 'TAS' or 'ENTITY'."
    exit 1
fi