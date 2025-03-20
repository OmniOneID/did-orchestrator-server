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

#apply to application.yml
JAR_PATHS=(
    "${PWD}/../../jars/TA"
    "${PWD}/../../jars/Issuer"
    "${PWD}/../../jars/Verifier"
    "${PWD}/../../jars/CA"
    "${PWD}/../../jars/Wallet"
    "${PWD}/../../jars/API"
)

BLOCKCHAIN_PATH="${PWD}/blockchain.properties"
SETUP_PATH="${PWD}/../../jars/"

for JAR_PATH in "${JAR_PATHS[@]}"; do
    APP_YML="${JAR_PATH}/application.yml"

    if [ -f "$APP_YML" ]; then
        echo "Updating: $APP_YML"

        # spring.profiles.active: dev
        awk '
        BEGIN { found=0 }
        /^spring:/ { in_spring=1 }
        in_spring && /^  profiles:/ { in_profiles=1 }
        in_profiles && /active:/ { found=1; sub(/active: .*/, "active: dev") }
        { print }
        END { if (!found) print "  profiles:\n    active: dev" }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

        # blockchain.file-path: ${PWD}/blockchain.properties
        awk -v bcpath="$BLOCKCHAIN_PATH" '
        BEGIN { found=0 }
        /^blockchain:/ { in_blockchain=1 }
        in_blockchain && /file-path:/ { found=1; sub(/file-path:.*/, "file-path: " bcpath) }
        { print }
        END { if (!found) print "blockchain:\n  file-path: " bcpath }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

        # setup.base-url: http://localhost and setup.path: ${SETUP_PATH}
        awk -v setup_base_url="http://localhost" -v setup_path="$SETUP_PATH" '
        BEGIN { found_base_url=0; found_path=0 }
        /^setup:/ { in_setup=1 }
        in_setup && /base-url:/ { found_base_url=1; sub(/base-url:.*/, "base-url: " setup_base_url) }
        in_setup && /path:/ { found_path=1; sub(/path:.*/, "path: " setup_path) }
        { print }
        END {
            if (!found_base_url) print "setup:\n  base-url: " setup_base_url
            if (!found_path) print "  path: " setup_path
        }
        ' "$APP_YML" > temp.yml && mv temp.yml "$APP_YML"

    else
        echo "Skipping: $APP_YML (File not found)"
    fi
done

