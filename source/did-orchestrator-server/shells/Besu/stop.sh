#!/bin/bash

CONTAINER_NAME="opendid-besu-node"

echo "Besu 컨테이너 중지 시도 중..."

if [ "$(docker ps -a -q -f name=^/${CONTAINER_NAME}$)" ]; then
    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
        echo "실행 중인 컨테이너 중지: $CONTAINER_NAME"
        docker stop "$CONTAINER_NAME"
    else
        echo "컨테이너는 이미 중지 상태입니다: $CONTAINER_NAME"
    fi

    # 컨테이너 삭제 옵션 (주석 해제 시 활성화)
    # echo "컨테이너 삭제 중..."
    # docker rm "$CONTAINER_NAME"
else
    echo "컨테이너가 존재하지 않습니다: $CONTAINER_NAME"
fi
