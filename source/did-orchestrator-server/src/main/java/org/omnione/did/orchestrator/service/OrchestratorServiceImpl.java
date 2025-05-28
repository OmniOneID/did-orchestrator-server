/*
 * Copyright 2025 OmniOne.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.omnione.did.orchestrator.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.omnione.did.base.constant.Constant;
import org.omnione.did.base.exception.ErrorCode;
import org.omnione.did.base.exception.OpenDidException;
import org.omnione.did.base.property.BlockchainProperties;
import org.omnione.did.base.property.DatabaseProperties;
import org.omnione.did.base.property.ServicesProperties;
import org.omnione.did.orchestrator.dto.OrchestratorResponseDto;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.yaml.snakeyaml.DumperOptions;
import org.yaml.snakeyaml.Yaml;

import java.io.*;
import java.net.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@Slf4j
@Service
public class OrchestratorServiceImpl implements OrchestratorService{
    private final RestTemplate restTemplate = new RestTemplate();
    private final ServicesProperties servicesProperties;
    private final BlockchainProperties blockChainProperties;
    private final DatabaseProperties databaseProperties;
    private final String JARS_DIR;
    private final Map<String, String> SERVER_JARS;
    private final Map<String, String> SERVER_JARS_FOLDER;
    private final String WALLET_DIR;
    private final String DID_DOC_DIR;
    private final String CLI_TOOL_DIR;
    private final String YAML_FILE_PATH;
    private final String LOGS_PATH;

    @Autowired
    public OrchestratorServiceImpl(ServicesProperties servicesProperties, BlockchainProperties blockChainProperties, DatabaseProperties databaseProperties) {
        this.servicesProperties = servicesProperties;
        this.blockChainProperties = blockChainProperties;
        this.databaseProperties = databaseProperties;
        this.JARS_DIR = System.getProperty("user.dir") + servicesProperties.getJarPath();
        this.YAML_FILE_PATH = System.getProperty("user.dir") + "/configs/application.yml";
        this.SERVER_JARS = initializeServerJars();
        this.SERVER_JARS_FOLDER = initializeServerJarsFolder();
        this.WALLET_DIR = System.getProperty("user.dir") + servicesProperties.getWalletPath();
        this.DID_DOC_DIR = System.getProperty("user.dir") + servicesProperties.getDidDocPath();
        this.CLI_TOOL_DIR = System.getProperty("user.dir") + servicesProperties.getCliToolPath();
        this.LOGS_PATH = System.getProperty("user.dir") + servicesProperties.getLogPath();
        Constant.WALLET_DIR = System.getProperty("user.dir") + servicesProperties.getWalletPath();
        Constant.DID_DOC_DIR = System.getProperty("user.dir") + servicesProperties.getDidDocPath();
        Constant.CLI_TOOL_DIR = System.getProperty("user.dir") + servicesProperties.getCliToolPath();
        Constant.LOGS_PATH = System.getProperty("user.dir") + servicesProperties.getLogPath();
    }

    private Map<String, String> initializeServerJars() {
        Map<String, String> serverJars = new HashMap<>();
        servicesProperties.getServer().forEach((key, serverDetail) ->
                serverJars.put(String.valueOf(serverDetail.getPort()), serverDetail.getFile()));
        return serverJars;
    }

    private Map<String, String> initializeServerJarsFolder() {
        Map<String, String> serverJarsFolder = new HashMap<>();
        servicesProperties.getServer().forEach((key, serverDetail) ->
                serverJarsFolder.put(String.valueOf(serverDetail.getPort()), serverDetail.getName()));
        return serverJarsFolder;
    }

    interface BlockChainStartupCallback {
        void onStartupComplete();
        void onStartupFailed();
    }
    /**
     * Starts all servers in the list if they are not already running.
     * This method checks all servers' status, and starts any server that is not already running.
     */
    @Override
    public void requestStartupAll() {
        try {
            for (String serverPort : SERVER_JARS.keySet()) {
                if (!isServerRunning(serverPort)) {
                    startServer(serverPort);
                } else {
                    log.debug("Server on port " + serverPort + " is already running. Skipping startup.");
                }
            }
        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
    }

    /**
     * Shuts down all servers in the list if they are running.
     * This method checks all servers' status, and stops any server that is currently running.
     */
    @Override
    public void requestShutdownAll() {
        try {
            for (String serverPort : SERVER_JARS.keySet()) {
                if (isServerRunning(serverPort)) {
                    stopServer(serverPort);
                } else {
                    log.debug("Server on port " + serverPort + " is stop. Skipping shutdown.");
                }
            }
        } catch (InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
    }

    /**
     * Starts the server on the given port.
     * This method attempts to start the server on the provided port if it's not already running.
     *
     * @param port the port on which the server should be started
     * @return the response status indicating the success or failure of the startup process
     * @throws OpenDidException if an error occurs during the startup process
     */
    @Override
    public OrchestratorResponseDto requestStartup(String port) throws OpenDidException {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        response.setStatus("Unknown error");
        log.info("Startup request for port: " + port);
        try {
            response.setStatus(startServer(port));
        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        return response;
    }

    /**
     * Stops the server on the given port.
     * This method attempts to stop the server on the provided port if it is currently running.
     *
     * @param port the port on which the server should be stopped
     * @return the response status indicating the success or failure of the shutdown process
     * @throws OpenDidException if an error occurs during the shutdown process
     */
    @Override
    public OrchestratorResponseDto requestShutdown(String port) throws OpenDidException {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        response.setStatus("Unknown error");
        log.info("shutdown request for port: " + port);
        try {
            response.setStatus(stopServer(port));
        } catch (InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        return response;
    }

    /**
     * Checks the health status of the server on the given port.
     * This method returns "UP" if the server is running, and "DOWN" otherwise.
     *
     * @param port the port of the server whose health status should be checked
     * @return the health status of the server (either "UP" or "DOWN")
     */
    @Override
    public OrchestratorResponseDto requestHealthCheck(String port) {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        response.setStatus("DOWN");
        log.info("requestHealthCheck for port: " + port);
        if(isServerRunning(port))
            response.setStatus("UP");
        return response;
    }

    /**
     * Refreshes the configuration of the server on the given port.
     * This method sends a request to the server's refresh endpoint and returns the response.
     *
     * @param port the port of the server to refresh
     * @return the response status indicating the success of the refresh operation
     */
    @Override
    public OrchestratorResponseDto requestRefresh(String port) {
        String targetUrl = getServerUrl() + port + "/actuator/refresh";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> requestEntity = new HttpEntity<>("", headers);
        ResponseEntity<String> response = restTemplate.postForEntity(targetUrl, requestEntity, String.class);

        String responseBody = response.getBody();
        log.info("refresh : " + responseBody);
        OrchestratorResponseDto dto = new OrchestratorResponseDto();
        dto.setStatus("SUCCESS");
        return dto;
    }

    /**
     * Starts Hyperledger Besu if it is not already running.
     * This method executes the `start.sh` script for Besu, waits for startup logs, and checks the health of the Besu.
     *
     * @return the status of the Besu (UP or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestStartupBesu() {
        log.info("requestStartupBesu");
        String besuShellPath = System.getProperty("user.dir") + "/shells/Besu";
        String logFilePath = LOGS_PATH + "/besu.log";

        try {
            ProcessBuilder chmodBuilder = new ProcessBuilder("chmod", "+x", besuShellPath + "/start.sh");
            chmodBuilder.start().waitFor();
            System.out.println("besu start : " + blockChainProperties.getBesu().getChainId());
            ProcessBuilder builder = new ProcessBuilder(
                    "sh", "-c", "nohup " + besuShellPath + "/start.sh "  +
                    " > " + logFilePath + " 2>&1 &"
            );

            builder.directory(new File(besuShellPath));
            builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
            builder.redirectError(ProcessBuilder.Redirect.INHERIT);
            builder.start();
            Thread.sleep(500);
            watchBlockChainLogs(logFilePath, new BlockChainStartupCallback() {
                @Override
                public void onStartupComplete() {
                    log.debug("Hyperledger Besu is running successfully!");
                }

                @Override
                public void onStartupFailed() {
                    log.error("Besu startup failed.");
                }
            });

            return requestHealthCheckBesu();
        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
    }

    /**
     * Shuts down Hyperledger Besu by executing the `stop.sh` script.
     * This method stops the Besu service and checks its status after shutdown.
     *
     * @return the status of the Besu (DOWN or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestShutdownBesu() {
        log.info("requestShutdownBesu");
        try {
            String besuShellPath = System.getProperty("user.dir") + "/shells/Besu";
            ProcessBuilder builder = new ProcessBuilder("sh", besuShellPath + "/stop.sh");
            builder.directory(new File(besuShellPath));
            builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
            builder.redirectError(ProcessBuilder.Redirect.INHERIT);
            builder.start();
            Thread.sleep(3000);
        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        OrchestratorResponseDto response = requestHealthCheckBesu();
        return response;
    }

    /**
     * Checks the health of the Hyperledger Besu.
     * This method checks whether Besu is up and running by executing the `status.sh` script.
     *
     * @return the health status of the Besu (UP or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestHealthCheckBesu() {
        log.info("requestHealthCheckBesu");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            String besuShellPath = System.getProperty("user.dir") + "/shells/Besu";
            ProcessBuilder builder = new ProcessBuilder("sh", besuShellPath + "/status.sh", "besu.dat");
            builder.directory(new File(besuShellPath));
            Process process = builder.start();
            String output = getProcessOutput(process);
            log.info("besu output : " + output);
            if (output.contains("200")) {
                response.setStatus("UP");
                return response;
            }

        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        response.setStatus("ERROR");
        return response;
    }
    /**
     * Resets Hyperledger Besu by executing the `reset.sh` script.
     * This method attempts to reset Besu and checks if the reset was successful.
     *
     * @return the status of the Besu reset (UP or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestResetBesu() {
        log.info("requestResetBesu");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            String besuShellPath = System.getProperty("user.dir") + "/shells/Besu";
            ProcessBuilder builder = new ProcessBuilder("sh", besuShellPath + "/reset.sh");
            builder.directory(new File(besuShellPath));
            Process process = builder.start();
            String output = getProcessOutput(process);

            if (output.contains(Constant.BLOCKCHAIN_RESET_MESSAGE)) {
                response.setStatus("UP");
                return response;
            }

        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        response.setStatus("ERROR");
        return response;
    }

    /**
     * Watches the BlockChain startup logs for success or failure.
     * This method monitors the log file and triggers the provided callback when the startup completes or fails.
     *
     * @param logFilePath the path to the BlockChain log file
     * @param callback the callback to invoke on startup completion or failure
     */
    private void watchBlockChainLogs(String logFilePath, BlockChainStartupCallback callback) {
        File logFile = new File(logFilePath);
        log.debug("Monitoring log file: " + logFilePath);

        try {
            while (!logFile.exists() || logFile.length() == 0) {
                log.debug("Waiting for log file to be created...");
                Thread.sleep(3000);
            }

            long lastReadPosition = 0;
            long lastHealthCheckTime = System.currentTimeMillis();
            final long HEALTH_CHECK_INTERVAL = 3 * 60 * 1000; // 3 minutes

            while (true) {
                try (RandomAccessFile reader = new RandomAccessFile(logFile, "r")) {
                    reader.seek(lastReadPosition);
                    String line;
                    while ((line = reader.readLine()) != null) {
                        log.debug(line);

                        if (line.contains(Constant.BLOCKCHAIN_SUCCESS_CHAINCODE_MESSAGE) || line.contains(Constant.BLOCKCHAIN_START_MESSAGE)) {
                            callback.onStartupComplete();
                            return;
                        }
                        if (line.contains(Constant.BLOCKCHAIN_FAIL_CHAINCODE_MESSAGE) || line.contains(Constant.BLOCKCHAIN_FAIL_DOCKER_MESSAGE)) {
                            callback.onStartupFailed();
                            return;
                        }
                    }
                    lastReadPosition = reader.getFilePointer();
                }

                long now = System.currentTimeMillis();
                if (now - lastHealthCheckTime >= HEALTH_CHECK_INTERVAL) {
                    log.debug("Performing blockchain health check...");

                    OrchestratorResponseDto response = new OrchestratorResponseDto();
                    if(logFilePath.contains("besu")){
                        response = requestHealthCheckBesu();
                    }
                    if (response.getStatus().equals("UP")) {
                        log.debug("Blockchain health check successful. Triggering success callback.");
                        callback.onStartupComplete();
                        return;
                    } else {
                        log.debug("Blockchain health check failed. Will retry...");
                    }

                    lastHealthCheckTime = now;
                }
                Thread.sleep(3000);
            }
        } catch (InterruptedException | IOException e) {
            callback.onStartupFailed();
        }
    }
    /**
     * Starts Ledger Service if it is not already running.
     * This method executes the `start.sh` script for Ledger Service, waits for startup logs, and checks the health of the Ledger Service.
     *
     * @return the status of the Ledger Service (UP or ERROR)
     */

    @Override
    public OrchestratorResponseDto requestStartupLedgerService() {
        log.info("requestStartupLedgerService");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        response.setStatus("Unknown error");
        // db 구동 확인
        if(doesLssDatabaseExist()){
            log.info("'lss' database exists and is accessible.");

        } else {
            log.warn("'lss' database does not exist or is not accessible.");
            response.setStatus("DOWN");
            return response;
        }
        String lssFolder = "LSS";
        String port = blockChainProperties.getLedgerService().getPort();

        try {


            String jarFolder = System.getProperty("user.dir") + blockChainProperties.getLedgerService().getJarPath() + "/" + lssFolder;
            String jarFilePath = jarFolder + "/" + blockChainProperties.getLedgerService().getFile();
            String configFilePath = jarFolder + "/application.yml";
            File jarFile = new File(jarFilePath);
            File scriptFile = new File(System.getProperty("user.dir") + blockChainProperties.getLedgerService().getJarPath()  + "/start.sh");
            if (!new File(configFilePath).exists()) {
                log.info("requestStartupLedgerService configFilePath : " + configFilePath);
                throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
            }

            List<String> command = new ArrayList<>();
            command.add("sh");
            command.add(scriptFile.getAbsolutePath());
            command.add(jarFile.getAbsolutePath());
            command.add(port);
            command.add(configFilePath);

            log.info("Executing command: " + String.join(" ", command));

            ProcessBuilder builder = new ProcessBuilder(command);

            builder.directory(new File(System.getProperty("user.dir") + blockChainProperties.getLedgerService().getJarPath()));
            builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
            builder.redirectError(ProcessBuilder.Redirect.INHERIT);
            Process process = builder.start();
            log.debug("Server on port " + port + " started with nohup! Waiting for health check...");

            int retries = 5;
            while (retries-- > 0) {
                Thread.sleep(1000);
                if (isServerRunning(port)) {
                    log.debug("Server on port " + port + " is running!");
                    response.setStatus("UP");
                }
            }
            log.error("Server on port " + port + " failed to start.");
            response.setStatus("DOWN");
        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        return response;
    }

    private boolean doesLssDatabaseExist() {

        String url = "jdbc:postgresql://localhost:" + databaseProperties.getPort() + "/postgres";
        String user = databaseProperties.getUser();
        String password = databaseProperties.getPassword();

        boolean exists = false;
        String query = "SELECT 1 FROM pg_database WHERE datname = 'lss'";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                exists = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return exists;
    }
    /**
     * Shuts down Ledger Service by executing the `stop.sh` script.
     * This method stops the Ledger Service and checks its status after shutdown.
     *
     * @return the status of the Ledger Service (DOWN or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestShutdownLedgerService() {
        log.info("requestShutdownLedgerService");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        String port = blockChainProperties.getLedgerService().getPort();
        response.setStatus("Unknown error");
        try {
            response.setStatus(stopServer(port));
        } catch (InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        return response;
    }

    /**
     * Checks the health of the Ledger Service.
     * This method checks whether Ledger Service is up and running by executing the `status.sh` script.
     *
     * @return the health status of the Ledger Service (UP or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestHealthCheckLedgerService() {
        log.info("requestHealthCheckLedgerService");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        String port = blockChainProperties.getLedgerService().getPort();
        response.setStatus("DOWN");
        if(isServerRunning(port))
            response.setStatus("UP");
        return response;
    }
    /**
     * Resets Ledger Service by executing the `reset.sh` script.
     * This method attempts to reset Ledger Service and checks if the reset was successful.
     *
     * @return the status of the Ledger Service (UP or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestResetLedgerService() {
        log.info("requestResetLedgerService");

        OrchestratorResponseDto response = new OrchestratorResponseDto();
        response.setStatus("ERROR");

        String baseUrl = "jdbc:postgresql://localhost:" + databaseProperties.getPort();
        String user = databaseProperties.getUser();
        String password = databaseProperties.getPassword();

        String checkDbQuery = "SELECT 1 FROM pg_database WHERE datname = 'lss'";

        try (
                Connection adminConn = DriverManager.getConnection(baseUrl + "/postgres", user, password);
                Statement checkStmt = adminConn.createStatement();
                ResultSet rs = checkStmt.executeQuery(checkDbQuery)
        ) {
            if (!rs.next()) {
                log.warn("Database 'lss' does not exist.");
                response.setStatus("DB_NOT_FOUND");
                return response;
            }
        } catch (SQLException e) {
            log.error("Failed to check existence of 'lss' database", e);
            return response;
        }

        // If lss DB exists, proceed to drop tables
        String getTablesQuery = "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE'";

        try (
                Connection conn = DriverManager.getConnection(baseUrl + "/lss", user, password);
                Statement stmt = conn.createStatement()
        ) {
            // Get list of tables
            List<String> tables = new ArrayList<>();
            try (ResultSet rs = stmt.executeQuery(getTablesQuery)) {
                while (rs.next()) {
                    tables.add(rs.getString("table_name"));
                }
            }

            // Drop all tables with CASCADE
            stmt.execute("SET session_replication_role = 'replica';"); // Bypass FK constraints
            for (String table : tables) {
                log.info("Dropping table: " + table);
                stmt.executeUpdate("DROP TABLE IF EXISTS \"" + table + "\" CASCADE;");
            }
            stmt.execute("SET session_replication_role = 'origin';");

            response.setStatus("UP");
        } catch (SQLException e) {
            log.error("Failed to drop tables from 'lss' database", e);
        }

        return response;
    }

    /**
     * Starts PostgreSQL by executing the `start.sh` script.
     * This method starts the PostgreSQL service and checks if it started successfully.
     *
     * @return the status of the PostgreSQL server (UP or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestStartupPostgre() {
        log.info("requestStartupPostgre");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            String postgreShellPath = System.getProperty("user.dir") + "/shells/Postgre";
            ProcessBuilder builder = new ProcessBuilder("sh", postgreShellPath + "/start.sh", databaseProperties.getPort(), databaseProperties.getUser(), databaseProperties.getPassword(), databaseProperties.getDb());
            builder.directory(new File(postgreShellPath));

            Process process = builder.start();
            String output = getProcessOutput(process);
            if (output.contains(Constant.POSTGRE_START_MESSAGE)) {
                response.setStatus("UP");
                return response;
            }
        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        response.setStatus("ERROR");
        return response;
    }

    /**
     * Stops PostgreSQL by executing the `stop.sh` script.
     * This method stops the PostgreSQL service and checks if it stopped successfully.
     *
     * @return the status of the PostgreSQL server (DOWN or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestShutdownPostgre() {
        log.info("requestShutdownPostgre");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            String postgreShellPath = System.getProperty("user.dir") + "/shells/Postgre";
            ProcessBuilder builder = new ProcessBuilder("sh", postgreShellPath + "/stop.sh");
            builder.directory(new File(postgreShellPath));

            Process process = builder.start();
            String output = getProcessOutput(process);
            if (output.contains(Constant.POSTGRE_STOP_MESSAGE)) {
                response.setStatus("DOWN");
                return response;
            }
        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        response.setStatus("ERROR");
        return response;
    }

    /**
     * Checks the health of the PostgreSQL server.
     * This method checks whether PostgreSQL is up and running by executing the `status.sh` script.
     *
     * @return the health status of the PostgreSQL server (UP or ERROR)
     */
    @Override
    public OrchestratorResponseDto requestHealthCheckPostgre() {
        log.info("requestHealthCheckPostgre");
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            String postgreShellPath = System.getProperty("user.dir") + "/shells/Postgre";
            ProcessBuilder builder = new ProcessBuilder("sh", postgreShellPath + "/status.sh", databaseProperties.getUser(), databaseProperties.getPassword());
            builder.directory(new File(postgreShellPath));

            Process process = builder.start();
            String output = getProcessOutput(process);

            if (output.contains(Constant.POSTGRE_HEALTH_MESSAGE)) {
                response.setStatus("UP");
                return response;
            }

        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        response.setStatus("ERROR");
        return response;
    }

    /**
     * Performs batch creation of wallets and DID documents for all entities.
     * This method triggers the execution of a shell script to create wallets and DID documents for all related entities using the provided password.
     *
     * @param password the password used for creating the wallets and DID documents
     * @return a response indicating the success or failure of the creation process
     */
    @Override
    public OrchestratorResponseDto createAll(String password) {
        log.info("createAll : " + password);
        OrchestratorResponseDto response = new OrchestratorResponseDto();

        Process process = null;

        try {
            ProcessBuilder builder = new ProcessBuilder("sh", CLI_TOOL_DIR + "/create_all.sh", password);
            builder.directory(new File(CLI_TOOL_DIR));
            builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
            builder.redirectError(ProcessBuilder.Redirect.INHERIT);

            process = builder.start();

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                log.debug("Wallet / DID DOC creation successful.");
                response.setStatus("SUCCESS");
            } else {
                log.error("Wallet / DID DOC  creation failed.");
                response.setStatus("ERROR");
            }

        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        } finally {
            if (process != null) {
                process.destroy();
            }
        }

        return response;

    }

    /**
     * Creates a wallet using the specified file name and password.
     * This method triggers the execution of a shell script to create a wallet and write the provided password to it.
     *
     * @param fileName the name of the wallet to create
     * @param password the password to be used for creating the wallet
     * @return response indicating the success or failure of the wallet creation process
     */
    @Override
    public OrchestratorResponseDto createWallet(String fileName, String password) {
        log.debug("createWallet : " + fileName + " / " + password);
        OrchestratorResponseDto response = new OrchestratorResponseDto();

        Process process = null;
        BufferedWriter writer = null;
        OutputStreamWriter outputStreamWriter = null;

        try {

            ProcessBuilder builder = new ProcessBuilder("sh", CLI_TOOL_DIR + "/create_wallet.sh", fileName);
            builder.directory(new File(CLI_TOOL_DIR));
            builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
            builder.redirectError(ProcessBuilder.Redirect.INHERIT);

            process = builder.start();

            outputStreamWriter = new OutputStreamWriter(process.getOutputStream());
            writer = new BufferedWriter(outputStreamWriter);

            writer.write(password);
            writer.newLine();
            writer.flush();

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                log.debug("Wallet creation successful.");
            } else {
                log.error("Wallet creation failed.");
                response.setStatus("ERROR");
                return response;
            }

        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    log.error("Error closing BufferedWriter.");
                }
            }

            if (outputStreamWriter != null) {
                try {
                    outputStreamWriter.close();
                } catch (IOException e) {
                    log.error("Error closing OutputStreamWriter.");
                }
            }

            if (process != null) {
                process.destroy();
            }
        }

        response.setStatus("SUCCESS");
        return response;
    }

    /**
     * Creates keys for a specified wallet using a list of key IDs and the provided password.
     * This method triggers the execution of a shell script to create keys for the wallet.
     *
     * @param fileName the name of the wallet for which keys are to be created
     * @param password the password for the wallet
     * @param keyIds the list of key IDs to be created
     * @return response indicating the success or failure of key creation process
     */
    @Override
    public OrchestratorResponseDto createKeys(String fileName, String password, List<String> keyIds) {
        log.debug("createKeys : " + fileName + " / " + password);
        OrchestratorResponseDto response = new OrchestratorResponseDto();
//        String[] keyId = {"assert", "auth", "keyagree", "invoke"};
        Process process = null;
        BufferedWriter writer = null;
        OutputStreamWriter outputStreamWriter = null;
        for(int i = 0; i < keyIds.size(); i++) {
            try {
                log.debug("createKeys : " + fileName + " / " + password + " / " + keyIds.get(i));
                ProcessBuilder builder = new ProcessBuilder("sh", CLI_TOOL_DIR + "/create_keys.sh", fileName + ".wallet", keyIds.get(i));
                builder.directory(new File(CLI_TOOL_DIR));
                builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
                builder.redirectError(ProcessBuilder.Redirect.INHERIT);

                process = builder.start();

                outputStreamWriter = new OutputStreamWriter(process.getOutputStream());
                writer = new BufferedWriter(outputStreamWriter);

                writer.write(password);
                writer.newLine();
                writer.flush();

                int exitCode = process.waitFor();
                if (exitCode == 0) {
                    log.debug("Keypair creation successful.");
                } else {
                    log.error("Keypair creation failed.");
                    response.setStatus("ERROR");
                    return response;
                }
                if (process.isAlive()) {
                    process.destroy();
                }
            } catch (IOException | InterruptedException e) {
                throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
            } finally {
                if (writer != null) {
                    try {
                        writer.close();
                    } catch (IOException e) {
                        log.error("Error closing BufferedWriter.");
                    }
                }

                if (outputStreamWriter != null) {
                    try {
                        outputStreamWriter.close();
                    } catch (IOException e) {
                        log.error("Error closing OutputStreamWriter.");
                    }
                }

                if (process != null) {
                    process.destroy();
                }
            }
        }
        response.setStatus("SUCCESS");
        return response;
    }

    /**
     * Creates a DID document for the specified wallet and writes the provided password to it.
     * This method triggers the execution of a shell script to create a DID document for the wallet.
     *
     * @param fileName the name of the wallet and DID document
     * @param password the password to be used for creating the DID document
     * @param did the DID to be used in the document
     * @param controller the controller of the DID document
     * @param type the type of the DID document
     * @return response indicating the success or failure of the DID document creation process
     */
    @Override
    public OrchestratorResponseDto createDidDocument(String fileName, String password, String did, String controller, String type) {
        log.debug("createDidDocument : " + fileName + " / " + password + " / " + did + " / " + controller);
        OrchestratorResponseDto response = new OrchestratorResponseDto();

        Process process = null;
        BufferedWriter writer = null;
        OutputStreamWriter outputStreamWriter = null;

        try {
            ProcessBuilder builder = new ProcessBuilder("sh", CLI_TOOL_DIR + "/create_did_doc.sh", fileName + ".wallet", fileName + ".did", did, controller, type);
            builder.directory(new File(CLI_TOOL_DIR));
            builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
            builder.redirectError(ProcessBuilder.Redirect.INHERIT);

            process = builder.start();

            outputStreamWriter = new OutputStreamWriter(process.getOutputStream());
            writer = new BufferedWriter(outputStreamWriter);

            writer.write(password);
            writer.newLine();
            writer.flush();

            int exitCode = process.waitFor();
            if (exitCode == 0) {
                log.debug("DID Documents creation successful.");
                response.setStatus("SUCCESS");
                return response;
            } else {
                log.error("DID Documents creation failed.");
            }

        } catch (IOException | InterruptedException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        } finally {

            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    log.error("Error closing BufferedWriter.");
                }
            }

            if (outputStreamWriter != null) {
                try {
                    outputStreamWriter.close();
                } catch (IOException e) {
                    log.error("Error closing OutputStreamWriter.");
                }
            }

            if (process != null) {
                process.destroy();
            }

        }
        response.setStatus("ERROR");
        return response;
    }

    /**
     * Retrieves the IP address of the server.
     * This method iterates through all network interfaces and returns the first non-loopback IPv4 address that is up.
     * If no valid IP address is found, it returns "Unknown IP".
     *
     * @return the IP address of the server or "Unknown IP" if no valid address is found
     */
    @Override
    public String getServerIp() {
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface iface = interfaces.nextElement();

                if (iface.isLoopback() || !iface.isUp()) {
                    continue;
                }

                Enumeration<InetAddress> addresses = iface.getInetAddresses();
                while (addresses.hasMoreElements()) {
                    InetAddress addr = addresses.nextElement();

                    if (addr instanceof Inet4Address && !addr.isLoopbackAddress()) {
                        return addr.getHostAddress();
                    }
                }
            }
        } catch (SocketException e) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }
        return "Unknown IP";
    }

    /**
     * Updates the configuration stored in the YAML file.
     * This method loads the existing configuration, applies the updates, and writes the modified configuration back to the YAML file.
     *
     * @param updates a map containing the updates to apply to the configuration
     * @return a response indicating the success or failure of the update process
     */
    @Override
    public OrchestratorResponseDto updateConfig(Map<String, Object> updates) {
        OrchestratorResponseDto response = new OrchestratorResponseDto();

        DumperOptions options = new DumperOptions();
        options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK);
        options.setPrettyFlow(true);

        Yaml yaml = new Yaml(options);
        Map<String, Object> yamlData = new HashMap<>();
        response.setStatus("SUCCESS");

        try (InputStream inputStream = new FileInputStream(YAML_FILE_PATH)) {
            Map<String, Object> loaded = yaml.load(inputStream);
            if (loaded != null) {
                yamlData = loaded;
            }
        } catch (IOException e) {
            response.setStatus("YAML read error: " + e.getMessage());
        }

        mergeMaps(yamlData, updates);

        try (Writer writer = new FileWriter(YAML_FILE_PATH)) {
            yaml.dump(yamlData, writer);
        } catch (IOException e) {
            response.setStatus("YAML write error: " + e.getMessage());
        }

        return response;
    }

    @SuppressWarnings("unchecked")
    private void mergeMaps(Map<String, Object> originalMap, Map<String, Object> updateMap) {
        for (Map.Entry<String, Object> entry : updateMap.entrySet()) {
            String key = entry.getKey();
            Object updateValue = entry.getValue();
            if (originalMap.containsKey(key)) {
                Object originalValue = originalMap.get(key);
                if (originalValue instanceof Map && updateValue instanceof Map) {
                    mergeMaps((Map<String, Object>) originalValue, (Map<String, Object>) updateValue);
                } else {
                    originalMap.put(key, updateValue);
                }
            } else {
                originalMap.put(key, updateValue);
            }
        }
    }

    private String startServer(String port) throws IOException, InterruptedException {
        Map<String, String> server_jars = SERVER_JARS;
        server_jars = initializeServerJars();
        String jarFolder = SERVER_JARS_FOLDER.get(port);
        String jarFilePath = JARS_DIR + "/" + jarFolder + "/" + server_jars.get(port);
        String configFilePath = JARS_DIR + "/" + jarFolder + "/application.yml";
        File jarFile = new File(jarFilePath);
        File scriptFile = new File(JARS_DIR + "/start.sh");
        if (!new File(configFilePath).exists()) {
            throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
        }

        List<String> command = new ArrayList<>();
        command.add("sh");
        command.add(scriptFile.getAbsolutePath());
        command.add(jarFile.getAbsolutePath());
        command.add(port);
        command.add(configFilePath);

        log.info("Executing command: " + String.join(" ", command));

        ProcessBuilder builder = new ProcessBuilder(command);

        builder.directory(new File(JARS_DIR));
        builder.redirectOutput(ProcessBuilder.Redirect.INHERIT);
        builder.redirectError(ProcessBuilder.Redirect.INHERIT);
        Process process = builder.start();
        log.debug("Server on port " + port + " started with nohup! Waiting for health check...");

        int retries = 5;
        while (retries-- > 0) {
            Thread.sleep(1000);
            if (isServerRunning(port)) {
                log.debug("Server on port " + port + " is running!");
                return "UP";
            }
        }
        log.error("Server on port " + port + " failed to start.");
        return "DOWN";
    }

    private String stopServer(String port) throws InterruptedException {

        String targetUrl = getServerUrl() + port + "/actuator/shutdown";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> requestEntity = new HttpEntity<>("", headers);
        restTemplate.postForEntity(targetUrl, requestEntity, OrchestratorResponseDto.class).getBody();

        int retries = 5;
        while (retries-- > 0) {
            Thread.sleep(1000);
            if (isServerRunning(port)) {
                log.debug("Server on port " + port + " is running!");
                return "UP";
            }
        }
        log.error("Server on port " + port + " failed to start.");
        return "DOWN";
    }
    private boolean isServerRunning(String port) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL(getServerUrl() + port + "/actuator/health");
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(3000);
            connection.setReadTimeout(3000);

            int responseCode = connection.getResponseCode();
            log.debug("running code : " + responseCode);
            return (responseCode == 200);
        } catch (IOException e) {
            return false;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private String getServerUrl() {
        return "http://" + getServerIp() + ":";
    }

    private String getProcessOutput(Process process) throws IOException, InterruptedException {
        StringBuilder output = new StringBuilder();

        Thread stdoutThread = new Thread(() -> {
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    log.debug("[OUTPUT] " + line);
                    output.append(line).append("\n");
                }
            } catch (IOException e) {
                throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
            }
        });

        Thread stderrThread = new Thread(() -> {
            try (BufferedReader errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {
                String line;
                while ((line = errorReader.readLine()) != null) {
                    log.debug("[OUTPUT] " + line);
                    output.append(line).append("\n");
                }
            } catch (IOException e) {
                throw new OpenDidException(ErrorCode.UNKNOWN_SERVER_ERROR);
            }
        });

        stdoutThread.start();
        stderrThread.start();

        stdoutThread.join();
        stderrThread.join();

        int exitCode = process.waitFor();
        log.debug("Process exited with code: " + exitCode);

        return output.toString().trim();
    }

}



