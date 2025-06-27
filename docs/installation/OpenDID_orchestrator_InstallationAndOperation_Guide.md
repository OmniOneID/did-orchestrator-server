# OpenDID Orchestrator Installation and Running Guide

This document describes how to install and run the OpenDID Orchestrator. Follow the steps below.

---

## 1. System Requirements

To install and run OpenDID Orchestrator, make sure the following requirements are met:

- **MacOS or Linux**
- **Java 21**
- **Gradle 7.0 or higher**
- **Node.js 22.12.0**
- **Git installed**
- **Bash support**
- **Docker support**

To install Git, refer to the [Git Installation Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).  
For Docker installation, refer to the [Docker Installation Guide](https://docs.docker.com/get-started/get-docker/) to install it for your OS.  
Currently, Windows is not officially supported. Please use VMware or other virtualization software to install Linux.

---

## 2. Clone did-orchestrator-server from Git

Clone the OpenDID Orchestrator project to your local environment by entering the following command in the terminal:

```bash
git clone https://github.com/OmniOneID/did-orchestrator-server.git
```

---

## 3. Run download.sh

OpenDID Orchestrator manages and runs individual server entities. You need to download the resources for these servers.  
Enter the following command in the terminal to run `download.sh` with the version information and download the server entities:

```bash
cd did-orchestrator-server/source/did-orchestrator-server/
sh download.sh 2.0.0
```

---

## 4. Running the Server

The project source is located under the `source` directory. There are two main ways to run the server:

1. **Using the console command after building**: Build the project and run the generated JAR file using the console command (`java -jar`).
2. **Using an IDE**: Open the project in an Integrated Development Environment (IDE), set up the run configuration, and start the server.

### 4.1. Running with Console Commands

Use the following steps to build the project with Gradle and run the server with the generated JAR file.

#### 4.1.1. Gradle Build Commands

- Move to the source folder of the cloned repository and give execution permission to `gradlew`:

  ```shell
  cd source/did-orchestrator-server
  chmod 755 ./gradlew
  ./gradlew clean build
  ```

- Move to the build folder and confirm the JAR file is generated:

  ```shell
  cd build/libs
  ls
  ```

- This will generate the `did-orchestrator-server-2.0.0.jar` file.

#### 4.1.2. Running the Server

Use the following commands to run the server:

```bash
cp did-orchestrator-server-2.0.0.jar ../../
cd ../../
sudo java -jar did-orchestrator-server-2.0.0.jar
```

- On Linux, make sure to run as `sudo` or as `root`.

---

### 4.2. Running with IntelliJ IDEA (Gradle Support)

IntelliJ IDEA is a popular IDE for Java development. OpenDID’s server uses Gradle, making it easy to configure and run in IntelliJ IDEA.

#### 4.2.1. Installing IntelliJ IDEA

Install IntelliJ IDEA using the following link:

> [IntelliJ IDEA Download](https://www.jetbrains.com/idea/download/)

#### 4.2.2. Open the Project in IntelliJ IDEA

- In IntelliJ, go to `File -> New -> Project from Existing Sources` and select the `source/did-orchestrator-server` folder.
- When opening the project, the `build.gradle` file will be automatically detected.
- Wait for Gradle to finish downloading the necessary dependencies.

#### 4.2.3. Build the Project with Gradle

- In the Gradle tab in IntelliJ, execute `Tasks -> build -> build`.
- Once the build is complete, the project will be ready to run.

#### 4.2.4. Run the Server

- In IntelliJ’s Gradle tab, find `Tasks -> application -> bootRun` and run it.
- Gradle will build and start the server.
- Check the console log for “Started [ApplicationName] in [time] seconds” to confirm successful startup.
- On Linux, ensure the run is executed as `sudo` or `root`.

---

## 5. Accessing the Orchestrator in Browser

Once the server is running, open your browser and navigate to:

```
http://<current_IP>:9001
```

For example, if you’re running it locally:

```
http://localhost:9001
```

---

## 6. Repository Selection

OpenDID Orchestrator provides `Hyperledger Besu` and `Ledger Service Server` as trusted storage repositories.  
When you first access the Orchestrator in the browser, you’ll be prompted to choose the desired repository.  
Hyperledger Besu is a blockchain-based distributed ledger, while Ledger Service Server uses a lightweight RDBMS-based trusted storage.

---

## 7. Running Hyperledger Besu and PostgreSQL with Docker

OpenDID Orchestrator uses Docker to run Hyperledger Besu and PostgreSQL DB.  
You’ll need to start these services using Docker. Refer to the [Docker Installation Guide](https://docs.docker.com/get-started/get-docker/) for setup instructions.  
Ensure your Docker environment supports `docker-compose`.

For example, on macOS, run `colima start` after installing Docker.

---

## 8. Creating Wallets and DID Documents

Use the **Generate All** button in the Orchestrator’s top-right corner to create wallets and DID Documents for all entities automatically.  
Each entity’s wallet and DID Document will be created using the default entity names and passwords.

### Creating for Individual Entities

To manually create wallets or DID Documents for specific entities, go to the **Configuration** tab and set **easySettingModeEnabled** to **false**.  
After saving, individual buttons will become available to manually enter names and passwords to generate them.

Note: For manually generated wallets, you must also manually configure the path and password on the entity’s settings page.

---

## 9. Running All Entities

In the browser, after accessing the Orchestrator, click the **Start All** button to start all entities.  
Each service and entity will light up green when running.

* You can also start/stop individual entities or all at once. *

---

## 10. Configuring Individual Entities

Once the Orchestrator is running, refer to each entity’s manual for additional configuration.  
Click the **Settings** button to navigate to the entity-specific settings page.

---

## Additional Notes

If any services or entities fail to start, you can check the logs by clicking the log icon to the right of the entity name.

---

The OpenDID Orchestrator is now fully operational.  
For additional questions, use the project’s [Issue Tracker](https://github.com/OmniOneID/did-orchestrator-server/issues).
