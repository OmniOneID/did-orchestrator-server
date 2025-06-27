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

import org.omnione.did.base.exception.OpenDidException;
import org.omnione.did.orchestrator.dto.OrchestratorResponseDto;

import java.util.List;
import java.util.Map;

public interface OrchestratorService {

    //Hyperledger Besu
    OrchestratorResponseDto requestStartupBesu();
    OrchestratorResponseDto requestShutdownBesu();
    OrchestratorResponseDto requestHealthCheckBesu();
    OrchestratorResponseDto requestResetBesu();


    // ledger service server(DB)
    OrchestratorResponseDto requestStartupLedgerService();
    OrchestratorResponseDto requestShutdownLedgerService();
    OrchestratorResponseDto requestHealthCheckLedgerService();
    OrchestratorResponseDto requestResetLedgerService();

    // PostgreSQL
    OrchestratorResponseDto requestStartupPostgre();
    OrchestratorResponseDto requestShutdownPostgre();
    OrchestratorResponseDto requestHealthCheckPostgre();

    //entities
    void requestStartupAll();
    void requestShutdownAll();
    OrchestratorResponseDto requestStartup(String port) throws OpenDidException;
    OrchestratorResponseDto requestShutdown(String port) throws OpenDidException;
    OrchestratorResponseDto requestHealthCheck(String port) throws OpenDidException;
    OrchestratorResponseDto requestRefresh(String port);

    //cli-tool
    OrchestratorResponseDto createAll(String password);
    OrchestratorResponseDto createWallet(String fileName, String password);
    OrchestratorResponseDto createKeys(String fileName, String password, List<String> keyIds);
    OrchestratorResponseDto createDidDocument(String fileName, String password, String did, String controller, String type);

    String getServerIp();
    OrchestratorResponseDto updateConfig(Map<String, Object> updates);

}
