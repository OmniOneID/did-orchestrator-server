#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <filename> <keyid>"
  exit 1
fi

FILENAME=$1
KEYID=$2

java -jar did-cli-tool-server-2.0.0.jar walletManager addKey -m $FILENAME -i $KEYID -t 1 -p