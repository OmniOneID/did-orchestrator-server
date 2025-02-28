# Orchestrator API 문서

---

- **일자**: 2025-02-24
- **버전**: v1.0.0

---

## 목차

1. [개요](#1-개요)
2. [API 목록](#2-api-목록)
3. [API 상세 설명](#3-api-상세-설명)
   - [3.1. 전체 서비스 및 엔티티 구동](#31-전체-서비스-및-엔티티-구동)
   - [3.2. 전체 서비스 및 엔티티 종료](#32-전체-서비스-및-엔티티-종료)
   - [3.3. 특정 엔티티 구동](#33-특정-엔티티-구동)
   - [3.4. 특정 엔티티 종료](#34-특정-엔티티-종료)
   - [3.5. 특정 엔티티 상태 확인](#35-특정-엔티티-상태-확인)
   - [3.6. 특정 엔티티 리프레시](#36-특정-엔티티-리프레시)
   - [3.7. HyperLedger Fabric 시작](#37-hyperledger-fabric-시작)
   - [3.8. HyperLedger Fabric 종료](#38-hyperledger-fabric-종료)
   - [3.9. HyperLedger Fabric 상태 확인](#39-hyperledger-fabric-상태-확인)
   - [3.10. HyperLedger Fabric 초기화](#310-hyperledger-fabric-초기화)
   - [3.11. PostgreSQL 시작](#311-postgresql-시작)
   - [3.12. PostgreSQL 종료](#312-postgresql-종료)
   - [3.13. PostgreSQL 상태 확인](#313-postgresql-상태-확인)
   - [3.14. Wallet 생성](#314-wallet-생성)
   - [3.15. Wallet 키쌍 생성](#315-wallet-키쌍-생성)
   - [3.16. DID 문서 생성](#316-did-문서-생성)
   - [3.17. 설정 조회](#317-설정-조회)
   - [3.18. 설정 업데이트](#318-설정-업데이트)
4. [에러 코드](#4-에러-코드)
5. [참고 사항](#5-참고-사항)

---

## 1. 개요

본 문서는 Orchestrator 서비스가 제공하는 API를 정의합니다. Orchestrator는 다양한 서비스의 시작, 종료, 상태 확인, 설정 관리 등을 담당합니다.

---

## 2. API 목록

| API                          | Method | URL                          | 설명                          |
|------------------------------|--------|------------------------------|-------------------------------|
| `전체 서비스 및 엔티티 구동`            | GET    | `/startup/all`               | 모든 서비스 및 엔티티 구동               |
| `전체 서비스 및 엔티티 종료`            | GET    | `/shutdown/all`              | 모든 서비스 및 엔티티 종료               |
| `특정 엔티티 구동`            | GET    | `/startup/{port}`            | 특정 포트의 엔티티 시작        |
| `특정 엔티티 종료`            | GET    | `/shutdown/{port}`           | 특정 포트의 엔티티 종료        |
| `특정 엔티티 상태 확인`       | GET    | `/healthcheck/{port}`        | 특정 포트의 엔티티 상태 확인   |
| `특정 엔티티 리프레시`        | GET    | `/refresh/{port}`            | 특정 포트의 엔티티 리프레시    |
| `HyperLedger Fabric 시작`                | GET    | `/startup/fabric`            | HyperLedger Fabric 시작             |
| `HyperLedger Fabric 종료`                | GET    | `/shutdown/fabric`           | HyperLedger Fabric 종료             |
| `HyperLedger Fabric 상태 확인`           | GET    | `/healthcheck/fabric`        | HyperLedger Fabric 상태 확인        |
| `HyperLedger Fabric 초기화`           | GET    | `/reset/fabric`        | HyperLedger Fabric 초기화        |
| `PostgreSQL 시작`            | GET    | `/startup/postgre`           | PostgreSQL 시작         |
| `PostgreSQL 종료`            | GET    | `/shutdown/postgre`          | PostgreSQL 종료         |
| `PostgreSQL 상태 확인`       | GET    | `/healthcheck/postgre`       | PostgreSQL 상태 확인    |
| `Wallet 생성`                | POST   | `/create/wallet`             | Wallet 생성                   |
| `Wallet 키쌍 생성`                    | POST   | `/create/keys`               | Wallet 내 키 생성             |
| `DID 문서 생성`              | POST   | `/create/diddoc`             | DID 문서 생성                 |
| `설정 조회`                  | GET    | `/configs`                   | Orchestrator 현재 설정 조회                |
| `설정 업데이트`              | POST   | `/configs`            | Orchestrator 설정 업데이트                 |

---

## 3. API 상세 설명

### 3.1. 전체 서비스 및 엔티티 구동

- **URL**: `/startup/all`
- **Method**: `GET`
- **설명**: Orchestrator가 관리하는 모든 서비스 및 엔티티를 시작합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/startup/all"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.2. 전체 서비스 및 엔티티 종료

- **URL**: `/shutdown/all`
- **Method**: `GET`
- **설명**: Orchestrator가 관리하는 모든 서비스 및 엔티티를 종료합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/startup/all"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.3. 특정 엔티티 구동

- **URL**: `/startup/{port}`
- **Method**: `GET`
- **설명**: 특정 포트의 엔티티를 시작합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/startup/8090"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.4. 특정 엔티티 종료

- **URL**: `/shutdown/{port}`
- **Method**: `GET`
- **설명**: 특정 포트의 엔티티를 종료합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/shutdown/8090"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.5. 특정 엔티티 상태 확인

- **URL**: `/healthcheck/{port}`
- **Method**: `GET`
- **설명**: 특정 포트의 엔티티 상태를 확인합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/healthcheck/8090"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.6. 특정 엔티티 리프레시

- **URL**: `/refresh/{port}`
- **Method**: `GET`
- **설명**: 특정 포트의 엔티티를 리프레시합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/refresh/9001"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.7. HyperLedger Fabric 시작

- **URL**: `/startup/fabric`
- **Method**: `GET`
- **설명**: HyperLedger Fabric 서비스의 시작을 수행합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/startup/fabric"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.8. HyperLedger Fabric 종료

- **URL**: `/shutdown/fabric`
- **Method**: `GET`
- **설명**: HyperLedger Fabric 서비스의 종료를 수행합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/shutdown/fabric"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.9. HyperLedger Fabric 상태 확인

- **URL**: `/healthcheck/fabric`
- **Method**: `GET`
- **설명**: HyperLedger Fabric 서비스의 상태 확인을 수행합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/healthcheck/fabric"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.10. HyperLedger Fabric 초기화

- **URL**: `/reset/fabric`
- **Method**: `GET`
- **설명**: HyperLedger Fabric 초기화를 수행합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/reset/fabric"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.11. PostgreSQL 시작

- **URL**: `/startup/postgre`
- **Method**: `GET`
- **설명**: PostgreSQL 서비스의 시작을 수행합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/startup/postgre"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.12. PostgreSQL 종료

- **URL**: `/shutdown/postgre`
- **Method**: `GET`
- **설명**: PostgreSQL 서비스의 종료를 수행합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/shutdown/postgre"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.13. PostgreSQL 상태 확인

- **URL**: `/healthcheck/postgre`
- **Method**: `GET`
- **설명**: PostgreSQL 서비스의 상태 확인을 수행합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/healthcheck/postgre"
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---


### 3.14. Wallet 생성

- **URL**: `/create/wallet`
- **Method**: `POST`
- **설명**: Wallet을 생성합니다.

#### 요청 예시

```shell
curl -X POST "http://${Host}:9001/create/wallet" \
-H "Content-Type: application/json" \
-d '{"filename": "tas", "password": "123456"}'
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.15. Wallet 키쌍 생성

- **URL**: `/create/keys`
- **Method**: `POST`
- **설명**: Wallet 내에 키쌍을 생성합니다.

#### 요청 예시

```shell
1. TAS
curl -X POST "http://${Host}:9001/create/keys" \
-H "Content-Type: application/json" \
-d '{
  "filename": "tas",
  "password": "123456",
  "keyIds": ["assert", "auth", "keyagree", "invoke"]
}'

2. Entities
curl -X POST "http://${Host}:9001/create/keys" \
-H "Content-Type: application/json" \
-d '{
  "filename": "issuer",
  "password": "123456",
  "keyIds": ["assert", "auth", "keyagree"]
}'
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.16. DID 문서 생성

- **URL**: `/create/diddoc`
- **Method**: `POST`
- **설명**: DID 문서를 생성합니다.

#### 요청 예시

```shell
1. TAS
curl -X POST "http://${Host}:9001/create/diddoc" \
-H "Content-Type: application/json" \
-d '{
  "filename": "tas",
  "password": "123456",
  "did": "did:omn:tas",
  "controller": "did:omn:tas",
  "type": "TAS"
}'

2. Entities
curl -X POST "http://${Host}:9001/create/diddoc" \
-H "Content-Type: application/json" \
-d '{
  "filename": "issuer",
  "password": "123456",
  "did": "did:omn:issuer",
  "controller": "did:omn:tas",
  "type": "ENTITY"
}'
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---

### 3.17. 설정 조회

- **URL**: `/configs`
- **Method**: `GET`
- **설명**: `/configs의 application.yml`의 현재설정을 조회합니다.

#### 요청 예시

```shell
curl -X GET "http://${Host}:9001/configs"
```

#### 응답 예시

```json
{
  "blockchain": {
    "channel": "mychannel",
    "chaincodeName": "opendid"
  },
  "database": {
    "port": "5430",
    "user": "omn",
    "password": "omn",
    "db": "omn"
  },
  "services": {
    "server": {
      "tas": {
        "name": "TAS",
        "port": 8090,
        "file": "did-ta-server-1.0.0.jar"
      },
      "issuer": {
        "name": "Issuer",
        "port": 8091,
        "file": "did-issuer-server-1.0.0.jar"
      },
      "verifier": {
        "name": "Verifier",
        "port": 8092,
        "file": "did-verifier-server-1.0.0.jar"
      },
      "api": {
        "name": "API",
        "port": 8093,
        "file": "did-api-server-1.0.0.jar"
      },
      "cas": {
        "name": "CAS",
        "port": 8094,
        "file": "did-cas-server-1.0.0.jar"
      },
      "wallet": {
        "name": "WalletService",
        "port": 8095,
        "file": "did-wallet-server-1.0.0.jar"
      },
      "demo": {
        "name": "Demo",
        "port": 8099,
        "file": "did-demo-server-1.0.0.jar"
      }
    },
    "jarPath": "/jars",
    "walletPath": "/wallet",
    "didDocPath": "/DIDDoc",
    "cliToolPath": "/tool"
  }
}
```

---

### 3.18. 설정 업데이트

- **URL**: `/configs`
- **Method**: `POST`
- **설명**: `/configs의 application.yml`을 업데이트합니다.

#### 요청 예시

```shell
curl -X POST "http://${Host}:9001/configs" \
-H "Content-Type: application/json" \
-d '{
  "blockchain": {
    "channel": "mychannel2",
    "chaincodeName": "opendid"
  },
  "database": {
    "port": "5430",
    "user": "omn",
    "password": "omn",
    "db": "omn"
  },
  "services": {
    "server": {
      "tas": {
        "name": "TAS",
        "port": 8090,
        "file": "did-ta-server-1.0.0.jar"
      },
      "issuer": {
        "name": "Issuer",
        "port": 8091,
        "file": "did-issuer-server-1.0.0.jar"
      },
      "verifier": {
        "name": "Verifier",
        "port": 8092,
        "file": "did-verifier-server-1.0.0.jar"
      },
      "api": {
        "name": "API",
        "port": 8093,
        "file": "did-api-server-1.0.0.jar"
      },
      "cas": {
        "name": "CAS",
        "port": 8094,
        "file": "did-cas-server-1.0.0.jar"
      },
      "wallet": {
        "name": "WalletService",
        "port": 8095,
        "file": "did-wallet-server-1.0.0.jar"
      },
      "demo": {
        "name": "Demo",
        "port": 8099,
        "file": "did-demo-server-1.0.0.jar"
      }
    },
    "jarPath": "/jars",
    "walletPath": "/wallet",
    "didDocPath": "/DIDDoc",
    "cliToolPath": "/tool"
  }
}'
```

#### 응답 예시

```json
{
  "status": "SUCCESS"
}
```

---


## 4. 에러 코드

| 코드         | 설명                          |
|--------------|-------------------------------|
| `500`        | 서버 내부 오류                |
| `400`        | 잘못된 요청                   |

---

## 5. 참고 사항

- API 호출 시 발생하는 오류는 `status` 필드를 통해 확인할 수 있습니다.
- 설정 업데이트는 `POST` 메서드를 사용하며, 요청 본문에 업데이트할 설정을 포함해야 합니다.