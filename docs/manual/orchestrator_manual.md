# Orchestrator User Manual

## 1. Overview
`Orchestrator` is an **integrated server management console** that allows you to monitor and control the status of various servers in one place.  
This manual explains the key features, screen layout, usage, and precautions of Orchestrator.

## 2. How to Access
- **Access URL**: Open a web browser and visit `http://<server IP>:9001`.
- **Initial Screen**: After accessing, you can view the status of all servers at a glance.

## 3. Screen Structure
The Orchestrator interface is composed of the following main sections:

### 3.1 Dashboard
![dashboard](./image/dashboard.png)

#### 3.1.1 Quick Start
Provides functionality to manage all services and entities at once.

- **All Entities**
  - **Status Icons**
    - ![gray](./image/gray_icon.png) All servers are in the initial (not started) state.
    - ![green](./image/green_icon.png) All servers are running normally.
    - ![yellow](./image/yellow_icon.png) Only some servers are running.
    - ![red](./image/red_icon.png) All servers are stopped.
  - **Functions**
    - `Start All`: Starts all services and entities at once.
    - `Stop All`: Stops all services and entities at once.
    - `Status All`: Checks the running status of all services and entities.
    - `Generate All`: Generates Wallets and DID Documents for all entities at once.

- **Wallet and DID Document Generation**:
  - If `easySettingModeEnabled` is set to false, a password input popup will appear.
    
    (The default setting is true.)

  - After entering the password, Wallets and DID Documents will be generated using each entity's name.

  ![Generate All Screen](./image/generate_all.png)

#### 3.1.2 Repositories
Provides functionality to manage core services (e.g., Hyperledger Fabric, PostgreSQL) individually.

- **Hyperledger Fabric**
  - **Status Icons**
    - ![green](./image/green_icon.png) Running
    - ![red](./image/red_icon.png) Stopped
  - **Functions**
    - `Start`: Starts the Hyperledger Fabric service.
    - `Stop`: Stops the Hyperledger Fabric service.
    - `Status`: Checks the status of the Hyperledger Fabric service.
    - `Reset`: Initializes the Hyperledger Fabric.

- **PostgreSQL**
  - **Status Icons**
    - ![green](./image/green_icon.png) Running
    - ![red](./image/red_icon.png) Stopped
  - **Functions**
    - `Start`: Starts the PostgreSQL service.
    - `Stop`: Stops the PostgreSQL service.
    - `Status`: Checks the status of the PostgreSQL service.

#### 3.1.3 Servers
Provides functionality to manage individual servers.

- **Individual Server Management**
  - **Status Icons**
    - ![green](./image/green_icon.png) Running
    - ![red](./image/red_icon.png) Stopped
  - **Displayed Info**: Server name and port number
  - **Functions**
    - `Start`: Starts the individual server.
    - `Stop`: Stops the individual server.
    - `Status`: Checks the running status of the server.
    - `Settings`: Opens the settings page of the server.
    - `Swagger`: Opens the Swagger API documentation page of the server.
    - `Wallet`: Generates a Wallet for the server.
    - `DID Document`: Generates a DID Document for the server.

    #### * Wallet and DID Document generation buttons for individual servers are hidden when `easySettingModeEnabled` is set to true.

- **Wallet Generation**:
  - Enter the Wallet name and password to generate the Wallet for the entity.

![Wallet Generation Screen](./image/wallet.png)

- **DID Document Generation**:
  - Enter the same name, DID, and password used for the Wallet to generate the DID Document for the entity.

![DID Document Generation Screen](./image/diddoc.png)

### 3.2 Configuration

![configuration](./image/configuration.png)

#### 3.2.1 Blockchain
Set the channel name and chaincode name of the blockchain.

#### 3.2.2 Database
Configure the database port and account information.

#### 3.2.3 Servers
Set the name, port, and deployment file name of each server.

#### 3.2.4 Service Paths
Configure the file paths for various components.

#### 3.2.5 Generator
Provides convenience when generating Wallets and DID Documents.

- **easySettingModeEnabled**
    - true
      - Uses a fixed password to generate all Wallets and DID Documents via "Generate All".
      - Does not support generating individual Wallets or DID Documents.
    - false
      - Requires user input for passwords when generating all Wallets and DID Documents.
      - Allows user-input-based generation for individual Wallets and DID Documents.

## 4. Precautions
- **Server Start/Stop Delay**: Using the `Start` or `Stop` buttons may take some time depending on the server environment.
- **Individual Entity Settings**: Use the `Settings` button to adjust individual server configurations.
- **Security**: Passwords used for generating Wallets and DID Documents should be managed securely.

*Orchestrator is intended for managing and monitoring the operation of individual entities. Detailed configurations must be handled on each entity’s own settings page.*
