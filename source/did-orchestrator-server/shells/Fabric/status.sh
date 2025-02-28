#!/bin/bash

CHANNEL=$1
CHAINCODE_NAME=$2

export PATH=${PWD}/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=$PWD/fabric-samples/config/

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID=Org1MSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051

peer chaincode query -C $CHANNEL -n $CHAINCODE_NAME -c '{"Args":["document_getDidDoc","did:open:user","1"]}'

#(docker ps -aq --filter label=service=hyperledger-fabric --filter "status=running"; docker ps -aq --filter name='dev-peer*' --filter "status=running"; docker ps -aq --filter name=ccaas --filter "status=running" | sort | uniq) | wc -l
