#!/bin/bash

ADDRESS_FILE=$1

# 파일 존재 여부 확인
if [ ! -f "$ADDRESS_FILE" ]; then
    echo "0 주소 파일이 존재하지 않습니다: $ADDRESS_FILE"
    exit 0
fi

# 파일에서 컨트랙트 주소 추출 (마지막 줄에서 주소 부분만 추출)
CONTRACT_ADDRESS=$(grep "OpenDID deployed to:" "$ADDRESS_FILE" | tail -n 1 | awk '{print $4}')

if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "0 주소 파일에서 컨트랙트 주소를 추출할 수 없습니다."
    exit 0
fi

RESPONSE=$(curl -s --fail -X POST --url http://localhost:8545 \
  --header 'Content-Type: application/json' \
  --data "{\"jsonrpc\":\"2.0\",\"method\":\"eth_getCode\",\"params\":[\"$CONTRACT_ADDRESS\",\"latest\"],\"id\":1}")

if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
    echo "0 구동 중이 아님 또는 노드에 연결 실패"
    exit 0
fi

# 결과 확인
RESULT=$(echo "$RESPONSE" | jq -r '.result')

echo "Status result : $RESULT" 

if [ "$RESULT" == "0x" ]; then
    echo "0 배포 실패: Contract 코드가 없음 ($CONTRACT_ADDRESS)"
    exit 0
else
    echo "200 배포 성공: 코드 감지됨 ($CONTRACT_ADDRESS)"
    exit 200
fi
