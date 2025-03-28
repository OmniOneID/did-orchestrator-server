DID Orchestrator Server Source Code
==

Welcome to the DID Orchestrator Server source code repository. This directory contains the core source code and build configurations for the DID Orchestrator Server.

## Directory Structure

Here's an overview of the directory structure.

```
did-orchestrator-server
├── gradle
├── libs
├── admin
│   └── src
│   └── public
│   └── build.sh
│   └── package.json
│   └── package-lock.json
│   └── postcss.config.js
│   └── tailwind.config.js
│   └── tsconfig.json
└── shells
    └── Fabric
    └── Postgre
├── src
└── build.gradle
└── README.md
```

<br/>

Below is a description of each folder and file in the directory:

| Name           | Description                                   |
| -------------- | --------------------------------------------- |
| did-orchestrator-server | Orchestrator Server source code and build files         |
| ┖ gradle       | Gradle build configurations and scripts       |
| ┖ libs         | External libraries and dependencies           |
| ┖ admin        | Front-end related source code directory       |
| ┖ src          | Back-end source code directory                |
| ┖ shells       | Non-source directory for Blockchain, RDBMS, and others |
| ┖ build.gradle | Gradle build configuration file               |
| ┖ README.md    | Overview and instructions for the source code |


## Libraries
Libraries used in this project are organized into three main categories:

1. **Front-end Third-Party Libraries**: The front-end of the Orchestrator server is developed based on [TypeScript](https://www.typescriptlang.org/) and [React.js](https://react.dev/), and it provides the UI/UX for the DID Orchestrator.

2. **Back-end Third-Party Libraries**: These libraries are open-source dependencies managed via the [build.gradle](build.gradle) file. For a detailed list of third-party libraries and their licenses, please refer to the [LICENSE-dependencies.md](../../dependencies-license.md) file.

3. **Other Libraries**: These libraries are modules that do not belong to the source area, such as Blockchain, RDBMS, and other third-party modules.

## Front-end Components
All front-end related components of the Orchestrator server are located under the admin folder, with the main items as follows:

- `src` : React source code directory
- `public` : Directory for storing static files such as index.html
- `build.sh` : A bash script that automates the project build process
- `package.json` : Contains metadata and a list of dependencies for the project
- `package-lock.json` : Records the exact versions of the dependencies defined in package.json
- `postcss.config.js` : PostCSS configuration file
- `tailwind.config.js` : Tailwind CSS configuration file
- `tsconfig.json` : TypeScript configuration file

### React Execution Instructions
The front-end application can be executed under the admin directory using the following commands:

```sh
npm install  # Install dependency packages if needed
npm start    # Start the development server
```

### Build and Deployment
To deploy static files to the server-side `resources/static` directory, the build process must be completed. <br>
To do this, run the `build.sh` script under the `admin` directory, which will automatically handle both the build and deployment processes. An example command is as follows:

```sh
sh build.sh     # Build and deploy, move the built files to the back-end resource area
```

The built static files will be created in the `build` directory, and these files can be moved to the back-end's `resources/static` directory for serving by the server.

## Non-source Modules (Blockchain and RDBMS Components)
These components are located under the shells folder, with the main items as follows:

- `Fabric` : Area for Running the Hyperledger Fabric Test Network, Using **Hyperledger Fabric v2.5.10.**
- `Postgre` : Area for Running PostgreSQL, Using **PostgreSQL v16.4.**

## Documenttation

Refer to the following documents for more detailed information:

- [API Reference](../../docs/api/Orchestrator_API.md)  
  Detailed reference for the DID Orchestrator Server's API endpoints.

- [OpenDID orchestrator InstallationAndOperation Guide](../../docs/installation/OpenDID_orchestrator_InstallationAndOperation_Guide.md)  
  Installation and configuration instructions.

## Contributing

Please read [CONTRIBUTING.md](../../CONTRIBUTING.md) and [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md) for details on our code of conduct, and the process for submitting pull requests to us.

## License
[Apache 2.0](../../LICENSE)

## Contact
For questions or support, please contact [maintainers](../../MAINTAINERS.md).
