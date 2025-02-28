# Orchestrator API Documentation

---

- **Date**: 2025-02-24
- **Version**: v1.0.0

---

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
   - [3.7. Start HyperLedger Fabric](#37-start-hyperledger-fabric)
   - [3.8. Stop HyperLedger Fabric](#38-stop-hyperledger-fabric)
   - [3.9. Check HyperLedger Fabric Status](#39-check-hyperledger-fabric-status)
   - [3.10. Reset HyperLedger Fabric](#310-reset-hyperledger-fabric)
   - [3.11. Start PostgreSQL](#311-start-postgresql)
   - [3.12. Stop PostgreSQL](#312-stop-postgresql)
   - [3.13. Check PostgreSQL Status](#313-check-postgresql-status)
   - [3.14. Create a Wallet](#314-create-a-wallet)
   - [3.15. Generate Wallet Key Pair](#315-generate-wallet-key-pair)
   - [3.16. Create a DID Document](#316-create-a-did-document)
   - [3.17. Retrieve Configuration](#317-retrieve-configuration)
   - [3.18. Update Configuration](#318-update-configuration)
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
| `Start HyperLedger Fabric`    | GET    | `/startup/fabric`            | Start HyperLedger Fabric       |
| `Stop HyperLedger Fabric`     | GET    | `/shutdown/fabric`           | Stop HyperLedger Fabric        |
| `Check HyperLedger Fabric Status` | GET    | `/healthcheck/fabric`  | Check HyperLedger Fabric status |
| `Reset HyperLedger Fabric`    | GET    | `/reset/fabric`        | Reset HyperLedger Fabric       |
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

### 3.7. Start HyperLedger Fabric

- **URL**: `/startup/fabric`
- **Method**: `GET`
- **Description**: Starts the HyperLedger Fabric service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/startup/fabric"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.8. Stop HyperLedger Fabric

- **URL**: `/shutdown/fabric`
- **Method**: `GET`
- **Description**: Stops the HyperLedger Fabric service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/shutdown/fabric"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.9. Check HyperLedger Fabric Status

- **URL**: `/healthcheck/fabric`
- **Method**: `GET`
- **Description**: Checks the status of the HyperLedger Fabric service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/healthcheck/fabric"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.10. Reset HyperLedger Fabric

- **URL**: `/reset/fabric`
- **Method**: `GET`
- **Description**: Performs a reset on the HyperLedger Fabric service.

#### Request Example

```shell
curl -X GET "http://${Host}:9001/reset/fabric"
```

#### Response Example

```json
{
  "status": "SUCCESS"
}
```

---

### 3.11. Start PostgreSQL

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
    "channel": "mychannel",
    "chaincodeName": "opendid"
  },
  "database": {
    "port": "5430",
    "user": "omn",
    "password": "omn",
    "db": "omn"
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
    "channel": "mychannel2"
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

