#!/bin/bash

echo "Stopping containers"
docker stop $(docker ps -aq --filter label=service=hyperledger-fabric; docker ps -aq --filter name='dev-peer*'; docker ps -aq --filter name=ccaas) | sort | uniq 2>/dev/null || true
