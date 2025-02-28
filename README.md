DID Orchestrator Server
==

Welcome to the DID Orchestrator Server repository. <br>
This repository contains the source code, documentation, and related resources for the DID Orchestrator server.

## Folder Structure
Overview of the main folders and documents in the project directory:

```
did-orchestrator-server
├── CHANGELOG.md
├── CLA.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── dependencies-license.md
├── MAINTAINERS.md
├── README.md
├── README_ko.md
├── RELEASE-PROCESS.md
├── SECURITY.md
├── docs
│    ├── api
│    │    └── Orchestrator_API_ko.md
│    ├── installation
│    │    └── Orchestrator_installation_Guide.md
│    └── manual
│         └── Orchestrator_manual.md
└── source
    └── did-orchestrator-server
        ├── gradle
        ├── libs
        └── src
        └── build.gradle
        └── README.md
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
| &nbsp;&nbsp;&nbsp;┖ build.gradle | Gradle build configuration file                |
| &nbsp;&nbsp;&nbsp;┖ README.md    | Overview and instructions for the source code  |

<br/>

## Libraries

The libraries used in this project are as follows:

1. **Third-party libraries**: These are open-source dependencies managed via the [build.gradle](source/did-orchestrator-server/build.gradle) file. A detailed list of third-party libraries and their licenses can be found in the [dependencies-license.md](dependencies-license.md) file.

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

