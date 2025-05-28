# Orchestrator API Documentation

- Subject: Orchestrator API Document
- Writer: Sangjun Kim
- Date: 2025-05-27
- Version: v2.0.0

| Version          | Date       | History                           |
| ---------------- | ---------- | ----------------------------------|
| v2.0.0           | 2025-05-27 | Initial                           |

## Table of Contents

1. [Overview](#1-overview)
2. [API List](#2-api-list)
3. [API Details](#3-api-details)
   - [3.1. Start All Services and Entities](#31-start-all-services-and-entities)
   - [3.2. Stop All Services and Entities](#32-stop-all-services-and-entities)
   - [3.3. Start a Specific Entity](#33-start-a-specific-entity)
   - [3.4. Stop a Specific Entity](#34-stop-a-specific-entity)
   - [3.5. Check the Status of a Specific Entity](#35-check-the-status-of-a-specific-entity)
   - [3.6. Refresh a Specific Entity](#36-refresh-a-specific-entity)
   - [3.7. Start HyperLedger Besu](#37-start-hyperledger-besu)
   - [3.8. Stop HyperLedger Besu](#38-stop-hyperledger-besu)
   - [3.9. Check HyperLedger Besu Status](#39-check-hyperledger-besu-status)
   - [3.10. Reset HyperLedger Besu](#310-reset-hyperledger-besu)
   - [3.11. Start Ledger Service Server](#311-start-ledger-service-server)
   - [3.12. Stop Ledger Service Server](#312-stop-ledger-service-server)
   - [3.13. Check Ledger Service Server Status](#313-check-ledger-service-server-status)
   - [3.14. Reset Ledger Service Server](#314-reset-ledger-service-server)   
   - [3.15. Start PostgreSQL](#315-start-postgresql)
   - [3.16. Stop PostgreSQL](#316-stop-postgresql)
   - [3.17. Check PostgreSQL Status](#317-check-postgresql-status)
   - [3.18. Create a Wallet](#318-create-a-wallet)
   - [3.19. Generate Wallet Key Pair](#319-generate-wallet-key-pair)
   - [3.20. Create a DID Document](#320-create-a-did-document)
   - [3.21. Retrieve Configuration](#321-retrieve-configuration)
   - [3.22. Update Configuration](#322-update-configuration)
4. [Error Codes](#4-error-codes)
5. [Notes](#5-notes)

---

## 1. Overview

This document defines the API provided by the Orchestrator service. The Orchestrator is responsible for managing the startup, shutdown, status checks, and configuration management of various services.

---

## 2. API List

| API                          | Method | URL                          | Description                    |
|------------------------------|--------|------------------------------|--------------------------------|
| `Start All Services and Entities`   | GET    | `/startup/all`               | Start all services and entities |
| `Stop All Services and Entities`   | GET    | `/shutdown/all`              | Stop all services and entities |
| `Start a Specific Entity`     | GET    | `/startup/{port}`            | Start an entity on a specific port |
| `Stop a Specific Entity`      | GET    | `/shutdown/{port}`           | Stop an entity on a specific port |
| `Check the Status of a Specific Entity` | GET    | `/healthcheck/{port}` | Check the status of an entity on a specific port |
| `Refresh a Specific Entity`   | GET    | `/refresh/{port}`            | Refresh an entity on a specific port |
| `Start HyperLedger Besu`    | GET    | `/startup/besu`            | Start HyperLedger Besu       |
| `Stop HyperLedger Besu`     | GET    | `/shutdown/besu`           | Stop HyperLedger Besu        |
| `Check HyperLedger Besu Status` | GET    | `/healthcheck/besu`  | Check HyperLedger Besu status |
| `Reset HyperLedger Besu`    | GET    | `/reset/besu`        | Reset HyperLedger Besu       |
| `Start Ledger Service Server`                | GET    | `/startup/lss`            | Start Ledger Service Server             |
| `Stop Ledger Service Server`                | GET    | `/shutdown/lss`           | Stop Ledger Service Server             |
| `Check Ledger Service Server Status`           | GET    | `/healthcheck/lss`        | Check Ledger Service Server Status        |
| `Reset Ledger Service Server`           | GET    | `/reset/lss`        | Reset Ledger Service Server        |
| `Start PostgreSQL`            | GET    | `/startup/postgre`           | Start PostgreSQL               |
| `Stop PostgreSQL`             | GET    | `/shutdown/postgre`          | Stop PostgreSQL                |
| `Check PostgreSQL Status`     | GET    | `/healthcheck/postgre`       | Check PostgreSQL status        |
| `Create a Wallet`             | POST   | `/create/wallet`             | Create a wallet                |
| `Generate Wallet Key Pair`    | POST   | `/create/keys`               | Generate a key pair in a wallet |
| `Create a DID Document`       | POST   | `/create/diddoc`             | Create a DID document          |
| `Retrieve Configuration`      | GET    | `/configs`                   | Retrieve the current Orchestrator configuration |
| `Update Configuration`        | POST   | `/configs`                   | Update the Orchestrator configuration |

---

## 3. API Details

### 3.1. Start All Services and Entities

- **URL**: `/startup/all`
- **Method**: `GET`
- **Description**: Starts all services and entities managed by the Orchestrator.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/startup/all"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.2. Stop All Services and Entities

- **URL**: `/shutdown/all`
- **Method**: `GET`
- **Description**: Stops all services and entities managed by the Orchestrator.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/shutdown/all"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.3. Start a Specific Entity

- **URL**: `/startup/{port}`
- **Method**: `GET`
- **Description**: Starts an entity on a specific port.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/startup/8090"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.4. Stop a Specific Entity

- **URL**: `/shutdown/{port}`
- **Method**: `GET`
- **Description**: Stops an entity on a specific port.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/shutdown/8090"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.5. Check the Status of a Specific Entity

- **URL**: `/healthcheck/{port}`
- **Method**: `GET`
- **Description**: Checks the status of an entity on a specific port.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/healthcheck/8090"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.6. Refresh a Specific Entity

- **URL**: `/refresh/{port}`
- **Method**: `GET`
- **Description**: Refreshes an entity on a specific port.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/refresh/9001"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.7. Start HyperLedger Besu

- **URL**: `/startup/besu`
- **Method**: `GET`
- **Description**: Starts the HyperLedger Besu service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/startup/besu"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.8. Stop HyperLedger Besu

- **URL**: `/shutdown/besu`
- **Method**: `GET`
- **Description**: Stops the HyperLedger Besu service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/shutdown/besu"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.9. Check HyperLedger Besu Status

- **URL**: `/healthcheck/besu`
- **Method**: `GET`
- **Description**: Checks the status of the HyperLedger Besu service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/healthcheck/besu"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.10. Reset HyperLedger Besu

- **URL**: `/reset/besu`
- **Method**: `GET`
- **Description**: Performs a reset on the HyperLedger Besu service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/reset/besu"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.11. Start Ledger Service Server

- **URL**: `/startup/lss`
- **Method**: `GET`
- **설명**: Starts the Ledger Service Server.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/startup/lss"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.12. Stop Ledger Service Server

- **URL**: `/shutdown/lss`
- **Method**: `GET`
- **설명**: Stops the Ledger Service Server.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/shutdown/lss"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.13. Check Ledger Service Server Status

- **URL**: `/healthcheck/lss`
- **Method**: `GET`
- **설명**: Checks the status of the  Ledger Service Server.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/healthcheck/lss"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.14. Reset Ledger Service Server

- **URL**: `/reset/lss`
- **Method**: `GET`
- **설명**: Performs a reset on the Ledger Service Server.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/reset/lss"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.15. Start PostgreSQL

- **URL**: `/startup/postgre`
- **Method**: `GET`
- **Description**: Starts the PostgreSQL service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/startup/postgre"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.12. Stop PostgreSQL

- **URL**: `/shutdown/postgre`
- **Method**: `GET`
- **Description**: Stops the PostgreSQL service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/shutdown/postgre"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.13. Check PostgreSQL Status

- **URL**: `/healthcheck/postgre`
- **Method**: `GET`
- **Description**: Checks the status of the PostgreSQL service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/healthcheck/postgre"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.14. Create a Wallet

- **URL**: `/create/wallet`
- **Method**: `POST`
- **Description**: Creates a wallet.

#### Request Example

```shell
curl -X POST "http://${Host}:9001/create/wallet" \
-H "Content-Type: application/json" \
-d '{"filename": "tas", "password": "123456"}'
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.15. Generate Wallet Key Pair

- **URL**: `/create/keys`
- **Method**: `POST`
- **Description**: Generates key pairs within a wallet.

#### Request Example

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

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.16. Create a DID Document

- **URL**: `/create/diddoc`
- **Method**: `POST`
- **Description**: Creates a DID document.

#### Request Example

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

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.17. Retrieve Configuration

- **URL**: `/configs`
- **Method**: `GET`
- **Description**: Retrieves the current configuration from `application.yml`.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/configs"
```

#### Response Example

```json
{
  "blockchain": {
    "besu": {
      "chainId": "1337",
      "chaincodeName": "opendid",
      "channel": "mychannel",
      "connectionTimeout": 10000,
      "gasLimit": 10000000,
      "gasPrice": 0
    },
    "ledgerService": {
      "file": "did-ledger-service-server-2.0.0.jar",
      "jarPath": "/jars",
      "port": "8098"
    }
  },
  "database": {
    "db": "omn",
    "password": "omn",
    "port": "5430",
    "user": "omn"
  },
  "generator": {
    "easySettingModeEnabled": true
  },
  "services": {
    "cliToolPath": "/tool",
    "didDocPath": "/DIDDoc",
    "jarPath": "/jars",
    "logPath": "/logs",
    "server": {
      "tas": {
        "file": "did-ta-server-2.0.0.jar",
        "name": "TA",
        "port": 8090
      },
      "issuer": {
        "file": "did-issuer-server-2.0.0.jar",
        "name": "Issuer",
        "port": 8091
      },
      "verifier": {
        "file": "did-verifier-server-2.0.0.jar",
        "name": "Verifier",
        "port": 8092
      },
      "api": {
        "file": "did-api-server-2.0.0.jar",
        "name": "API",
        "port": 8093
      },
      "cas": {
        "file": "did-ca-server-2.0.0.jar",
        "name": "CA",
        "port": 8094
      },
      "wallet": {
        "file": "did-wallet-server-2.0.0.jar",
        "name": "Wallet",
        "port": 8095
      },
      "demo": {
        "file": "did-demo-server-2.0.0.jar",
        "name": "Demo",
        "port": 8099
      }
    },
    "walletPath": "/wallet"
  }
}
```

---

### 3.18. Update Configuration

- **URL**: `/configs`
- **Method**: `POST`
- **Description**: Updates `application.yml`.

#### Request Example

```shell
curl -X POST "http://${Host}:9001/configs" \
-H "Content-Type: application/json" \
-d '{
  "blockchain": {
    "besu": {
      "chainId": "1337",
      "chaincodeName": "opendid",
      "channel": "mychannel",
      "connectionTimeout": 10000,
      "gasLimit": 10000000,
      "gasPrice": 0
    },
    "ledgerService": {
      "file": "did-ledger-service-server-2.0.0.jar",
      "jarPath": "/jars",
      "port": "8098"
    }
  },
  "database": {
    "db": "omn",
    "password": "omn",
    "port": "5430",
    "user": "omn"
  },
  "generator": {
    "easySettingModeEnabled": true
  },
  "services": {
    "cliToolPath": "/tool",
    "didDocPath": "/DIDDoc",
    "jarPath": "/jars",
    "logPath": "/logs",
    "server": {
      "tas": {
        "file": "did-ta-server-2.0.0.jar",
        "name": "TA",
        "port": 8090
      },
      "issuer": {
        "file": "did-issuer-server-2.0.0.jar",
        "name": "Issuer",
        "port": 8091
      },
      "verifier": {
        "file": "did-verifier-server-2.0.0.jar",
        "name": "Verifier",
        "port": 8092
      },
      "api": {
        "file": "did-api-server-2.0.0.jar",
        "name": "API",
        "port": 8093
      },
      "cas": {
        "file": "did-ca-server-2.0.0.jar",
        "name": "CA",
        "port": 8094
      },
      "wallet": {
        "file": "did-wallet-server-2.0.0.jar",
        "name": "Wallet",
        "port": 8095
      },
      "demo": {
        "file": "did-demo-server-2.0.0.jar",
        "name": "Demo",
        "port": 8099
      }
    },
    "walletPath": "/wallet"
  }
}'
```




#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

## 4. Error Codes

| Code  | Description                 |
|-------|-----------------------------|
| `500` | Internal server error       |
| `400` | Bad request                 |

---

## 5. Notes

- Errors occurring during API calls can be checked using the `status` field.
- Configuration updates use the `POST` method and require the updated settings in the request body.

