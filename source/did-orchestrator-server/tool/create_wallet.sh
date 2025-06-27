#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

FILENAME=$1

java -jar did-cli-tool-server-2.0.0.jar walletManager createWallet -m $FILENAME -p