#!/bin/bash

SERVER_IP=$1
CONTRACT_DIR="did-besu-contract"
MAKE_ACCOUNT_WITH_REGIST_ROLE_SCRIPT="$CONTRACT_DIR/scripts/deploy-and-make-account-with-regist-role.js"
TAR_FILE="did-besu-contract-2.0.0.tar.gz"
OUTPUT_FILE="besu.dat"

if [ ! -f "$MAKE_ACCOUNT_WITH_REGIST_ROLE_SCRIPT" ]; then
    echo "Contract files are compressed."

    if [ -f "$TAR_FILE" ]; then
        echo "Extracting $TAR_FILE..."
        tar -xvf "$TAR_FILE"
    else
        echo "Cannot find compressed file $TAR_FILE. Exiting."
        exit 1
    fi
else
    echo "Contract files are ready."
fi

find "./$CONTRACT_DIR/contracts/" -name "*.sol" -exec sed -i '/Mac OS X/d' {} \; 2>/dev/null

if command -v docker-compose &> /dev/null; then
    echo "Using docker-compose..."
    docker-compose up -d
elif docker compose version &> /dev/null; then
    echo "Using docker compose..."
    docker compose up -d
else
    echo "Neither docker-compose nor docker compose found!"
    exit 1
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
    npm cache clean --force
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

    # Run make-account-with-regist-role.js which handles everything
    echo "Hardhat: Deploying contracts and creating accounts with roles..."
    DEPLOY_OUTPUT=$(npx hardhat run scripts/deploy-and-make-account-with-regist-role.js --network dev)

    echo "$DEPLOY_OUTPUT"

    # Save the deployment output to besu.dat
    echo "$DEPLOY_OUTPUT" > "$ACCOUNT_INFO_PATH"

    echo "Chaincode initialization is not required."
fi

cd ..

# Extract information from the output
CONTRACT_ADDRESS=$(grep "OpenDID deployed to:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)
DEPLOYER_ADDRESS=$(grep "Deploying the contract with the account:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)
TAS_ADDRESS=$(grep "== TAS Ethereum Wallet ==" -A 2 "$ACCOUNT_INFO_PATH" | grep "Address:" | cut -d ':' -f2- | xargs)
TAS_PRIVATE_KEY=$(grep "Private Key TAS:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)
ISSUER_ADDRESS=$(grep "== Issuer Ethereum Wallet ==" -A 2 "$ACCOUNT_INFO_PATH" | grep "Address:" | cut -d ':' -f2- | xargs)
ISSUER_PRIVATE_KEY=$(grep "Private Key Issuer:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)

echo "Extracted information:"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Deployer Address: $DEPLOYER_ADDRESS"
echo "TAS Address: $TAS_ADDRESS"
echo "TAS Private Key: $TAS_PRIVATE_KEY"
echo "Issuer Address: $ISSUER_ADDRESS"
echo "Issuer Private Key: $ISSUER_PRIVATE_KEY"

# Validation
if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "Failed to extract contract address"
    exit 1
fi

if [ -z "$TAS_PRIVATE_KEY" ] || [ -z "$ISSUER_PRIVATE_KEY" ]; then
    echo "Failed to extract TAS or Issuer private keys"
    exit 1
fi

echo "Generating blockchain.properties..."

# Modified generate_blockchain_properties function to accept private_key parameter
generate_blockchain_properties() {
    local target_path="$1"
    local include_private_key="$2"
    local private_key="$3"
    local target_dir
    target_dir="$(dirname "$target_path")"

    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

    echo "Generating blockchain.properties at: $target_path"
    {
        echo "evm.network.url=http://localhost:8545"
        echo "evm.chainId=1337"
        echo "evm.gas.limit=10000000"
        echo "evm.gas.price=0"
        echo "evm.connection.timeout=10000"
        echo "evm.contract.address=${CONTRACT_ADDRESS}"
        if [ "$include_private_key" = true ]; then
            echo "evm.contract.privateKey=${private_key}"
        fi
    } > "$target_path"
}

# Generate blockchain.properties files
COMMON_BLOCKCHAIN="${PWD}/blockchain.properties"
generate_blockchain_properties "$COMMON_BLOCKCHAIN" false ""

TA_BLOCKCHAIN_PATH="${PWD}/TA/blockchain.properties"
generate_blockchain_properties "$TA_BLOCKCHAIN_PATH" true "$TAS_PRIVATE_KEY"

ISSUER_BLOCKCHAIN_PATH="${PWD}/Issuer/blockchain.properties"
generate_blockchain_properties "$ISSUER_BLOCKCHAIN_PATH" true "$ISSUER_PRIVATE_KEY"

echo "blockchain.properties files generated successfully:"
echo "- Common: $COMMON_BLOCKCHAIN"
echo "- TAS: $TA_BLOCKCHAIN_PATH"
echo "- Issuer: $ISSUER_BLOCKCHAIN_PATH"

# Run easy-adoption injector
sh easy-adoption-injector.sh $SERVER_IP
