DID Orchestrator Server
==

Welcome to the DID Orchestrator Server repository. <br>
This repository contains the source code, documentation, and related resources for the DID Orchestrator server.

## Overview of DID Orchestrator
The DID Orchestrator is an integrated management tool that monitors and controls the status of various servers and repositories within the OpenDID system. It plays a key role in facilitating easy installation and operation, helping users onboard to OpenDID with ease.

![Overview](./docs/manual/image/dashboard.png)

The DID Orchestrator is primarily composed of the following menus and features:
- Dashboard: Provides server orchestration and status monitoring functions
  - Quick Start: Quick start/stop of all entities
  - Repositories: start/stop of blockchain and DB
  - Servers: start/stop of server entities
  - Demo: start/stop of demo services
- Configuration: Provides the function to modify its own configuration settings.

## Folder Structure
Overview of the main folders and documents in the project directory:

```
did-orchestrator-server
├── CHANGELOG.md
├── CLA.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── MAINTAINERS.md
├── README.md
├── README_ko.md
├── RELEASE-PROCESS.md
├── SECURITY.md
├── dependencies-license.md
├── docs
│   ├── api
│   │   ├── Orchestrator_API.md
│   │   └── Orchestrator_API_ko.md
│   ├── installation
│   │   ├── OpenDID_orchestrator_InstallationAndOperation_Guide.md
│   │   └── OpenDID_orchestrator_InstallationAndOperation_Guide_ko.md
│   └── manual
│       ├── orchestrator_manual.md
│       └── orchestrator_manual_ko.md
└── source
    └── did-orchestrator-server
        ├── README.md
        ├── admin
        ├── build.gradle
        ├── configs
        ├── gradle
        ├── jars
        ├── logs
        ├── shells
        ├── src
        └── tool
```

<br/>

Below is a description of each folder and file in the directory:

| Name                             | Description                                     |
| -------------------------------- | ---------------------------------------------- |
| CHANGELOG.md                     | Version-specific changes in the project        |
| CODE_OF_CONDUCT.md               | Contributor code of conduct                    |
| CONTRIBUTING.md                  | Contribution guidelines and procedures         |
| LICENSE                          | License                                        |
| dependencies-license.md          | License information for project dependencies   |
| MAINTAINERS.md                   | Project maintainer guidelines                  |
| RELEASE-PROCESS.md               | New version release process                    |
| SECURITY.md                      | Security policies and vulnerability reporting  |
| docs                             | Documentation                                  |
| ┖ api                            | API guide documentation                        |
| ┖ installation                   | Installation and operation guide               |
| ┖ manual                         | Manual                                        |
| source                           | Server source code project                     |
| ┖ did-orchestrator-server        | Orchestrator server source code and build files |
| &nbsp;&nbsp;&nbsp;┖ gradle       | Gradle build settings and scripts              |
| &nbsp;&nbsp;&nbsp;┖ libs         | External libraries and dependencies            |
| &nbsp;&nbsp;&nbsp;┖ src          | Main source code directory                     |
| &nbsp;&nbsp;&nbsp;┖ admin        | Front-end code Directory |
| &nbsp;&nbsp;&nbsp;┖ shells       | Blockchain, RDBMS, and other Modules Directory  |
| &nbsp;&nbsp;&nbsp;┖ build.gradle | Gradle build configuration file                |
| &nbsp;&nbsp;&nbsp;┖ README.md    | Overview and instructions for the source code  |

## S/W Specifications
| Category           | Details                      |
|--------------------|------------------------------|
| OS                | MacOS, Linux                  |
| Language          | Java 21                       |
| IDE               | IntelliJ IDEA Ultimate Edition|
| Compatibility     | Node.js 22.12.0, Hyperledger Besu 25.5.0 |
| Test Environment  | macOS Sonoma, CentOS Stream 10, Oracle Linux 8.1 |

## Libraries

The libraries used in this project are as follows:

- **Back-end Third-party Libraries**: These are open-source dependencies managed via the [build.gradle](source/did-orchestrator-server/build.gradle) file. A detailed list of third-party libraries and their licenses can be found in the [dependencies-license.md](dependencies-license.md) file.
- **Front-end Third-party Libraries**: These are modules that provide the UI/UX for the DID Orchestrator. For more details, please refer to the [README.md](source/did-orchestrator-server/README.md) file within the source area.
- **Other Libraries**: These are modules that do not belong to the source area, such as Blockchain and RDBMS. For more details, please refer to the [README.md](source/did-orchestrator-server/README.md) file within the source area.


## Installation and Operation Guide

For detailed instructions on installing and configuring the Orchestrator server, refer to the guide below:
- [OpenDID Orchestrator Server Installation and Operation Guide](docs/installation/OpenDID_orchestrator_InstallationAndOperation_Guide.md)

## API Reference Documentation

- **Orchestrator API**: Detailed reference material for Orchestrator server API endpoints and usage.
  - [Orchestrator API Reference](docs/api/Orchestrator_API.md)

## Change Log

The Change Log contains detailed records of version-wise changes and updates. You can check it here:
- [Change Log](./CHANGELOG.md)  

## OpenDID Demonstration Video

To watch the demonstration video of the OpenDID system, visit the [Demo Repository](https://github.com/OmniOneID/did-demo-server). <br>

This video showcases key features such as user registration, VC issuance, and VP submission processes.

## Contribution

For details on the contribution process and code of conduct, please refer to [CONTRIBUTING.md](CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

## License
[Apache 2.0](LICENSE)

