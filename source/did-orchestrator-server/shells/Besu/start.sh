#!/bin/bash

CONTRACT_DIR="did-besu-contract"
MAKE_ACCOUNT_SCRIPT="$CONTRACT_DIR/scripts/make-account.js"
DEPLOY_SCRIPT="$CONTRACT_DIR/scripts/deploy-contract.js"
TAR_FILE="did-besu-contract-2.0.0.tar.gz"
OUTPUT_FILE="besu.dat"

if [ ! -f "$MAKE_ACCOUNT_SCRIPT" ]; then
    echo "Contract files are compressed."

    if [ -f "$TAR_FILE" ]; then
        echo "Extracting $TAR_FILE..."
        tar -xzvf "$TAR_FILE"
    else
        echo "Cannot find compressed file $TAR_FILE. Exiting."
        exit 1
    fi
else
    echo "Contract files are ready."
fi


CONTAINER_NAME="opendid-besu-node"
DATA_DIR="$(pwd)/data/besu-node"
IMAGE="hyperledger/besu:latest"

mkdir -p "$DATA_DIR"

if [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "Container already exists. Restarting container..."
    docker start $CONTAINER_NAME
else
    echo "First-time run: Creating and starting container..."
    docker run -d \
        -p 8545:8545 \
        -p 8546:8546 \
        -p 30303:30303 \
        -p 30303:30303/udp \
        -v "$DATA_DIR":/opt/besu/data \
        --name $CONTAINER_NAME \
        $IMAGE \
        --network=dev \
        --miner-enabled \
        --miner-coinbase=0xfe3b557e8fb62b89f4916b721be55ceb828dbd73 \
        --rpc-http-cors-origins="all" \
        --host-allowlist="*" \
        --rpc-ws-enabled \
        --rpc-http-enabled \
        --data-path=/opt/besu/data \
        --min-gas-price=0 \
        --tx-pool-price-bump=0
fi

echo "Besu container started. Waiting..."
sleep 5

cd "$CONTRACT_DIR" || { echo "Failed to move to $CONTRACT_DIR"; exit 1; }

if [ ! -f "hardhat.config.js" ]; then
    echo "hardhat.config.js not found. This is not a valid Hardhat project."
    exit 1
fi

if [ ! -f "node_modules/.bin/hardhat" ]; then
    echo "Hardhat is not installed locally. Installing..."
    npm install --save-dev hardhat
else
    echo "Hardhat is already installed locally."
fi


STATUS_SCRIPT_PATH="$(pwd)/../status.sh"
ACCOUNT_INFO_PATH="$(pwd)/../$OUTPUT_FILE"

if [ ! -f "$STATUS_SCRIPT_PATH" ]; then
    echo "status.sh not found: $STATUS_SCRIPT_PATH"
    exit 1
fi

echo "Checking contract deployment status..."
command="sh $STATUS_SCRIPT_PATH $ACCOUNT_INFO_PATH"
eval $command

if [ $? -eq 200 ]; then
    echo "starting checked"
else
    echo "Contract deployment required. Starting new deployment..."

    echo "Hardhat: Creating account..."
    npx hardhat run scripts/make-account.js --network dev > "$ACCOUNT_INFO_PATH"

    echo "Hardhat: Deploying contract..."
    DEPLOY_OUTPUT=$(npx hardhat run scripts/deploy-contract.js --network dev)

    echo "$DEPLOY_OUTPUT"

    DEPLOY_LINE=$(echo "$DEPLOY_OUTPUT" | grep "OpenDID deployed to:")
    echo "$DEPLOY_LINE" >> "$ACCOUNT_INFO_PATH"

    echo "Chaincode initialization is not required."
fi

cd ..

CONTRACT_ADDRESS=$(grep "OpenDID deployed to:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)
PRIVATE_KEY=$(grep "Private Key:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)

if [ -z "$CONTRACT_ADDRESS" ] || [ -z "$PRIVATE_KEY" ]; then
    echo "Deploying chaincode failed"
    exit 1
fi

echo "Generating blockchain.properties..."

# Generate blockchain.properties
cat <<EOF > ${PWD}/blockchain.properties
evm.network.url=http://localhost:8545
evm.chainId=1337
evm.gas.limit=10000000
evm.gas.price=0
evm.connection.timeout=10000
evm.contract.address=${CONTRACT_ADDRESS}
evm.contract.privateKey=${PRIVATE_KEY}
EOF

# Run easy-adoption injector
sh easy-adoption-injector.sh
