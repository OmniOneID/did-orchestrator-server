#!/bin/bash

# ---------------------------
# Step 0: Hardhat 프로젝트 준비
# ---------------------------

CONTRACT_DIR="did-besu-contract"
MAKE_ACCOUNT_SCRIPT="$CONTRACT_DIR/scripts/make-account.js"
DEPLOY_SCRIPT="$CONTRACT_DIR/scripts/deploy-contract.js"
TAR_FILE="did-besu-contract-2.0.0.tar.gz"
OUTPUT_FILE="account-info.txt"

if [ ! -f "$MAKE_ACCOUNT_SCRIPT" ]; then
    echo "컨트랙트 파일이 압축되어있습니다."

    if [ -f "$TAR_FILE" ]; then
        echo "$TAR_FILE 압축 해제 중..."
        tar -xzvf "$TAR_FILE"
    else
        echo "압축 파일 $TAR_FILE 을(를) 찾을 수 없습니다. 스크립트를 종료합니다."
        exit 1
    fi
else
    echo "컨트랙트 파일이 준비되었습니다."
fi

# ---------------------------
# Step 1: Besu 컨테이너 구동
# ---------------------------

CONTAINER_NAME="opendid-besu-node"
DATA_DIR="$(pwd)/data/besu-node"
IMAGE="hyperledger/besu:latest"

mkdir -p "$DATA_DIR"

if [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
    echo "기존 컨테이너가 존재합니다. 컨테이너를 재시작합니다..."
    docker start $CONTAINER_NAME
else
    echo "최초 실행: 컨테이너를 생성하고 실행합니다..."
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

echo "Besu 컨테이너 구동 완료. 5초 대기..."
sleep 2

# ---------------------------
# 🧾 Step 2: Hardhat 작업 실행
# ---------------------------

cd "$CONTRACT_DIR" || { echo "$CONTRACT_DIR 디렉토리로 이동 실패"; exit 1; }

if [ ! -f "hardhat.config.js" ]; then
    echo "hardhat.config.js 파일이 없습니다. 유효한 Hardhat 프로젝트가 아닙니다."
    exit 1
fi

# Hardhat 로컬 설치 확인
if [ ! -f "node_modules/.bin/hardhat" ]; then
    echo "Hardhat이 로컬에 설치되어 있지 않습니다. 설치를 시작합니다..."
    npm install --save-dev hardhat
else
    echo "Hardhat 로컬 설치 확인 완료."
fi

# ---------------------------
# 🧪 Step 3: 배포 여부 상태 점검
# ---------------------------

STATUS_SCRIPT_PATH="$(pwd)/../status.sh"
ACCOUNT_INFO_PATH="$(pwd)/../$OUTPUT_FILE"

if [ ! -f "$STATUS_SCRIPT_PATH" ]; then
    echo "상태 확인용 status.sh 스크립트가 없습니다: $STATUS_SCRIPT_PATH"
    exit 1
fi

echo "배포 상태 확인 중..."
# bash "$STATUS_SCRIPT_PATH" "$ACCOUNT_INFO_PATH"
# STATUS_CODE=$?

# echo "status code : $STATUS_CODE"

# if [ "$STATUS_CODE" -eq 200 ]; then
command="sh $STATUS_SCRIPT_PATH $ACCOUNT_INFO_PATH"
eval $command
echo "status code : $?"

if [ $? -eq 200 ]; then
    echo "이미 배포된 컨트랙트가 존재합니다. 배포를 건너뜁니다."
else
    echo "컨트랙트 배포가 필요합니다. 새로 배포를 시작합니다..."

    # 1. 계정 생성 실행 및 결과 저장
    echo "Hardhat: 계정 생성 실행 중..."
    npx hardhat run scripts/make-account.js --network dev > "$ACCOUNT_INFO_PATH"

    # 2. 컨트랙트 배포 실행 및 출력 저장
    echo "Hardhat: 컨트랙트 배포 실행 중..."
    DEPLOY_OUTPUT=$(npx hardhat run scripts/deploy-contract.js --network dev)

    echo "$DEPLOY_OUTPUT"

    # 3. "OpenDID deployed to:" 라인만 추출해 저장
    DEPLOY_LINE=$(echo "$DEPLOY_OUTPUT" | grep "OpenDID deployed to:")
    echo "$DEPLOY_LINE" >> "$ACCOUNT_INFO_PATH"

    echo "컨트랙트 새로 배포 완료!"
fi

cd ..
echo "현재 디렉토리: $(pwd)"
echo "account-info.txt 경로: $ACCOUNT_INFO_PATH"

# 안전한 값 추출
CONTRACT_ADDRESS=$(grep "OpenDID deployed to:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)
PRIVATE_KEY=$(grep "Private Key:" "$ACCOUNT_INFO_PATH" | cut -d ':' -f2- | xargs)


# 유효성 검사
if [ -z "$CONTRACT_ADDRESS" ] || [ -z "$PRIVATE_KEY" ]; then
    echo "account-info.txt에서 주소 또는 프라이빗 키를 추출할 수 없습니다."
    exit 1
fi

echo "generate blockchain properties!"

#generate blockchain properties
cat <<EOF > ${PWD}/blockchain.properties
evm.network.url=http://localhost:8545
evm.chainId=1337
evm.gas.limit=10000000
evm.gas.price=0
evm.connection.timeout=10000
evm.contract.address=${CONTRACT_ADDRESS}
evm.contract.privateKey=${PRIVATE_KEY}
EOF

#easy-adoption injector
sh easy-adoption-injector.sh
