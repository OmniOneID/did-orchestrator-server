# OpenDID Orchestrator Installation and Operation Guide

This document explains how to install and run OpenDID Orchestrator. Follow the steps below to proceed.

---

## 1. System Requirements
To install and run OpenDID Orchestrator, the following requirements must be met:
- **Java 17** or higher
- **Gradle 7.0** or higher
- **Git installed**
- **Bash support**

For Git installation, refer to the [Git Installation Guide](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository).<br>
For Windows environments, WSL2 installation is required for Bash support. Refer to the [WSL2 Installation Guide](https://learn.microsoft.com/en-us/windows/wsl/install).

---

## 2. Clone the did-orchestrator-server Repository
Clone the OpenDID Orchestrator project to your local environment. Run the following command in the terminal to download the project:

```bash
git clone https://github.com/OmniOneID/did-orchestrator-server.git
```

---

## 3. Run download.sh
Since OpenDID Orchestrator manages and operates individual server entities, you need to download the configuration for each entity.<br>
Run the following command in the terminal to execute `download.sh` and download the individual server entities:

```bash
cd did-orchestrator-server/source/
sh download.sh
```

---

## 4. Running the Server
The project source is located under the `source` directory, and you need to load the source and configure it based on the chosen execution method.
There are two main ways to run the server:

1. **Using an IDE**: Open the project in an Integrated Development Environment (IDE), configure the execution settings, and run the server directly.

2. **Using console commands after building**: Build the project, then use the generated JAR file to run the server via console command (`java -jar`).

## 4.1. Running with IntelliJ IDEA (Gradle Support)
IntelliJ IDEA is a widely used IDE for Java development. Since OpenDID Orchestrator uses Gradle for building, you can easily set up the project and run the server in IntelliJ IDEA.

### 4.1.1. Install and Set Up IntelliJ IDEA
1. Install IntelliJ (refer to the link below for installation instructions):

> **Reference Links**
> - [Download IntelliJ IDEA](https://www.jetbrains.com/idea/download/)

### 4.1.2. Open the Project in IntelliJ
- Open IntelliJ and select `File -> New -> Project from Existing Sources`. When prompted, select the 'source/did-orchestrator-server' folder.
- The `build.gradle` file will be automatically recognized.
- Gradle will download the necessary dependencies. Wait until the process is complete.

### 4.1.3. Build with Gradle
- In IntelliJ IDEA, navigate to the `Gradle` tab and run `Tasks -> build -> build`.
- Once the build is successfully completed, the project is ready to run.

### 4.1.4. Running the Server
- In the IntelliJ IDEA Gradle tab, select `Tasks -> application -> bootRun` and run it.
- Gradle will automatically build and start the server.
- Check the console log for the message "Started [ApplicationName] in [time] seconds" to confirm successful execution.

## 4.2. Running with Console Commands
You can run the OpenDID server using console commands. The following steps involve building the project with Gradle and running the server using the generated JAR file.

### 4.2.1. Build with Gradle

- Use Gradle Wrapper to build the source.
  ```shell
    # Navigate to the cloned repository's source folder
    cd source/did-orchestrator-server

    # Grant execution permission to Gradle Wrapper
    chmod 755 ./gradlew

    # Clean build the project (delete previous build files and build anew)
    ./gradlew clean build
  ```

- Navigate to the build folder and verify the generated JAR file.
    ```shell
      cd build/libs
      ls
    ```
- This command will generate the file `did-orchestrator-server-1.0.0.jar`.

<br/>

### 4.2.2. Running the Server
Run the built JAR file:

```bash
cp did-orchestrator-server-1.0.0.jar ../../
cd ../../
java -jar did-orchestrator-server-1.0.0.jar
```

## 5. Accessing Orchestrator via Browser

Once the Orchestrator server is running successfully, access it via a browser using the following URL. The default port is `9001`.

```
http://<your_current_IP>:9001
```

For example, if running locally:
```
http://localhost:9001
```

---

## 6. Running Hyperledger Fabric and PostgreSQL via Docker
OpenDID Orchestrator uses the Hyperledger Fabric Network and PostgreSQL database.
To run these services, Docker Desktop or Colima must be running.

### Windows
1. Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop).  
2. Start Docker Desktop after installation.

### macOS
1. Install either [Docker Desktop](https://www.docker.com/products/docker-desktop) or [Colima](https://github.com/abiosoft/colima).  
2. If using Colima, run the following command:
```bash
colima start
```

### Linux
1. Install Docker.
```bash
sudo apt-get update
sudo apt-get install docker.io docker-compose
```
2. Start the Docker service.
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

## 7. Running All Entities

1. Access Orchestrator via a browser and click the **All Entities** button to start all entities.  
2. When each service and entity is running, they will be indicated with a green light.

*Each service and entity can be started/stopped individually or all at once.*

---

## 8. Generating Wallets and DID Documents
You can generate wallets and DID documents for all entities or for individual entities.

### Generating for All Entities
Click the **Generate All** button and enter a password to generate wallets and DID documents.
Wallets and DID documents will be automatically created based on each entity's name.

### Generating for Individual Entities
To manually generate a wallet or DID document for a specific entity, go to the **Servers** tab and click the respective **Wallet** or **DID Document** button.

*Generated wallets need to be configured in the entity settings page with a path and password. DID documents are used for entity registration.*

---

## 9. Configuring TAS and Issuing Registration Certificates
Click the **Settings** button for TAS in the **Servers** tab to navigate to the TAS settings page.
Follow the installation guide to configure TAS, register entities, and issue registration certificates.

---

## Additional Notes

- If any service or entity fails to start, check the logs for troubleshooting.

---

Now, OpenDID Orchestrator is successfully running.  
For further inquiries, please use the project's [issue tracker](https://github.com/OmnioneId/did-orchestrator/issues).

