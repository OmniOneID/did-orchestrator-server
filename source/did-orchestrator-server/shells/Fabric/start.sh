#!/bin/bash

CHANNEL=$1
CHAINCODE_NAME=$2

command="${PWD}/fabric-samples/bin/peer"
eval $command

if [ $? -eq 0 ]; then
        echo "installation checked"
else
        tar -xvf did-fabric-contract-1.0.0.tar.gz
        tar -xvf fabric-samples-1.4.4.tar.gz
        ${PWD}/install-fabric.sh --fabric-version 2.5.11 binary
        ${PWD}/install-fabric.sh --fabric-version 2.5.1 docker
        ${PWD}/fabric-samples/test-network/network.sh down
fi

${PWD}/fabric-samples/test-network/network.sh createChannel -c $CHANNEL
${PWD}/fabric-samples/test-network/network.sh up -ca -s couchdb
sleep 3

command="sh ${PWD}/status.sh $CHANNEL $CHAINCODE_NAME"
eval $command

if [ $? -eq 0 ]; then
        echo "starting checked"
else
        ${PWD}/fabric-samples/test-network/network.sh deployCC -c $CHANNEL -ccn $CHAINCODE_NAME -ccp ${PWD}/did-fabric-contract/source/did-fabric-contract -ccl go -ccs 1
fi

cp ${PWD}/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/* ${PWD}/cert/sk
cp ${PWD}/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/* ${PWD}/cert/cert.pem

#generate blockchain properties
cat <<EOF > ${PWD}/blockchain.properties
fabric.mspId=Org1MSP
fabric.configFilePath=${PWD}/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/connection-org1.yaml
fabric.privateKeyFilePath=${PWD}/cert/sk
fabric.certificateFilePath=${PWD}/cert/cert.pem
fabric.networkName=$CHANNEL
fabric.chaincodeName=$CHAINCODE_NAME
EOF

#easy-adoption injector
sh easy-adoption-injector.sh
