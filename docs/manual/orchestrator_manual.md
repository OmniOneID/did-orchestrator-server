# Orchestrator User Manual

## 1. Overview
`Orchestrator` is a **unified server management console** that allows monitoring and controlling multiple servers in a unified way.
This manual describes the key features, screen structure, usage instructions, and precautions for Orchestrator.

## 2. Accessing Orchestrator
- **Access URL**: Open a web browser and go to `http://<server IP>:9001`.
- **Initial Screen**: After accessing, you can view the status of all servers at a glance.

## 3. Screen Structure
The Orchestrator interface consists of the following main sections:

![Screen Structure](https://raw.githubusercontent.com/OmniOneID/did-orchestrator-server/refs/heads/main/docs/manual/orchestrator.png)

### 3.1 Quick Start
Provides functions to manage all services and entities collectively.

- **All Entities**
  - **Status Icons**:
    - 🟢 All servers are running normally
    - 🟡 Some servers are running
    - 🔴 All servers are stopped
  - **Functions**:
    - `Start All`: Starts all services and entities at once.
    - `Stop All`: Stops all services and entities at once.
    - `Status All`: Checks the operating status of all services and entities.
    - `Generate All`: Generates Wallet and DID Documents for all entities collectively.

- **Wallet and DID Document Generation**:
  - By entering a password, a Wallet and DID Document are created for each entity name.

![Generate All Screen](https://raw.githubusercontent.com/OmniOneID/did-orchestrator-server/refs/heads/main/docs/manual/generate_all.png)

### 3.2 Repositories
Provides functions to manage key services (e.g., Hyperledger Fabric, PostgreSQL) individually.

- **Hyperledger Fabric**
  - **Status Icons**: 🟢 (Running) / 🔴 (Stopped)
  - **Functions**:
    - `Start`: Starts the Hyperledger Fabric service.
    - `Stop`: Stops the Hyperledger Fabric service.
    - `Status`: Checks the operating status of Hyperledger Fabric.
    - `Reset`: Resets Hyperledger Fabric.

- **PostgreSQL**
  - **Status Icons**: 🟢 (Running) / 🔴 (Stopped)
  - **Functions**:
    - `Start`: Starts the PostgreSQL service.
    - `Stop`: Stops the PostgreSQL service.
    - `Status`: Checks the operating status of PostgreSQL.

### 3.3 Servers
Provides functions to manage individual servers.

- **Individual Server Management**
  - **Status Icons**: 🟢 (Running) / 🔴 (Stopped)
  - **Displayed Information**: Server name and port number
  - **Functions**:
    - `Start`: Starts an individual server.
    - `Stop`: Stops an individual server.
    - `Status`: Checks the operating status of an individual server.
    - `Settings`: Moves to the settings page of the individual server.
    - `Swagger`: Moves to the Swagger API documentation page of the individual server.
    - `Wallet`: Generates a Wallet for the individual server.
    - `DID Document`: Generates a DID Document for the individual server.

- **Wallet Generation**:
  - By entering the Wallet name and password, a Wallet for the corresponding entity is created.

![Wallet Generation Screen](https://raw.githubusercontent.com/OmniOneID/did-orchestrator-server/refs/heads/main/docs/manual/wallet.png)

- **DID Document Generation**:
  - By entering the same name, DID, and password as the generated Wallet, a DID Document for the corresponding entity is created.

![DID Document Generation Screen](https://raw.githubusercontent.com/OmniOneID/did-orchestrator-server/refs/heads/main/docs/manual/diddoc.png)

## 4. Precautions
- **Server Start/Stop Time**: When using the `Start` or `Stop` button, the operation may take some time depending on the server execution environment.
- **Individual Entity Settings**: The `Settings` button allows adjusting the detailed settings of individual servers.
- **Security**: Passwords used for Wallet and DID Document generation must be managed securely.

*Orchestrator is designed for managing and monitoring individual entities, while the detailed settings of each entity should be configured through their respective settings pages.*

