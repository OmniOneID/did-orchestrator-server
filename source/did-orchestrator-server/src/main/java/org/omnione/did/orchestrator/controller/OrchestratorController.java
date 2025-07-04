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

package org.omnione.did.orchestrator.controller;

import org.omnione.did.base.exception.OpenDidException;
import org.omnione.did.base.property.ConfigProperties;
import org.omnione.did.base.property.ServicesProperties;
import org.omnione.did.orchestrator.dto.OrchestratorConfigDto;
import org.omnione.did.orchestrator.dto.OrchestratorResponseDto;
import org.omnione.did.orchestrator.dto.OrchestratorRequestDto;
import org.omnione.did.orchestrator.service.OrchestratorService;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;

@Controller
public class OrchestratorController {
    private final ConfigProperties configProperties;
    private final ServicesProperties servicesProperties;
    private final OrchestratorService orchestratorService;

    public OrchestratorController(ServicesProperties servicesProperties, OrchestratorService orchestratorService, ConfigProperties configProperties) {
        this.servicesProperties = servicesProperties;
        this.orchestratorService = orchestratorService;
        this.configProperties = configProperties;
    }

    //@GetMapping("/")
    @GetMapping(value = {"/", "/conf", "/help"})
    public String index(Model model) {
        return "forward:/index.html";
    }

    @GetMapping("/startup/all")
    public ResponseEntity<OrchestratorResponseDto> startupAll() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            orchestratorService.requestStartupAll();
            response.setStatus("SUCCESS");
            return ResponseEntity.ok(response);
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }

    }

    @GetMapping("/shutdown/all")
    public ResponseEntity<OrchestratorResponseDto> shutdownAll() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            orchestratorService.requestShutdownAll();
            response.setStatus("SUCCESS");
            return ResponseEntity.ok(response);
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/startup/{port}")
    public ResponseEntity<OrchestratorResponseDto> startup(@PathVariable String port) {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestStartup(port);
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);

    }

    @GetMapping("/shutdown/{port}")
    public ResponseEntity<OrchestratorResponseDto> shutdown(@PathVariable String port) {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestShutdown(port);
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);

    }

    @GetMapping("/healthcheck/{port}")
    public ResponseEntity<OrchestratorResponseDto> healthCheck(@PathVariable String port) {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestHealthCheck(port);
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/refresh/{port}")
    public ResponseEntity<OrchestratorResponseDto> refresh(@PathVariable String port) {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestRefresh(port);
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/startup/besu")
    public ResponseEntity<OrchestratorResponseDto> besuStartup() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestStartupBesu();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/shutdown/besu")
    public ResponseEntity<OrchestratorResponseDto> besuShutdown() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestShutdownBesu();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/healthcheck/besu")
    public ResponseEntity<OrchestratorResponseDto> besuHealthCheck() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestHealthCheckBesu();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/reset/besu")
    public ResponseEntity<OrchestratorResponseDto> besuReset() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestResetBesu();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }
    //ledger service server(db)
    @GetMapping("/startup/lss")
    public ResponseEntity<OrchestratorResponseDto> ledgerServiceStartup() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestStartupLedgerService();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/shutdown/lss")
    public ResponseEntity<OrchestratorResponseDto> ledgerServiceShutdown() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestShutdownLedgerService();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/healthcheck/lss")
    public ResponseEntity<OrchestratorResponseDto> ledgerServiceHealthCheck() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestHealthCheckLedgerService();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }
    @GetMapping("/reset/lss")
    public ResponseEntity<OrchestratorResponseDto> ledgerServiceReset() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestResetLedgerService();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/startup/postgre")
    public ResponseEntity<OrchestratorResponseDto> postgreStartup() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestStartupPostgre();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/shutdown/postgre")
    public ResponseEntity<OrchestratorResponseDto> postgreShutdown() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestShutdownPostgre();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/healthcheck/postgre")
    public ResponseEntity<OrchestratorResponseDto> postgreHealthCheck() {
        OrchestratorResponseDto response = new OrchestratorResponseDto();
        try {
            response = orchestratorService.requestHealthCheckPostgre();
        } catch (OpenDidException e) {
            response.setStatus("ERROR");
            return ResponseEntity.status(500).body(response);
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/create/all")
    public ResponseEntity<OrchestratorResponseDto> createAll(@RequestBody OrchestratorRequestDto request) {
        try{
            OrchestratorResponseDto result = orchestratorService.createAll(request.getPassword());
            return ResponseEntity.ok(result);
        } catch (OpenDidException e) {
            OrchestratorResponseDto errorResponse = new OrchestratorResponseDto();
            errorResponse.setStatus("ERROR");
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    @PostMapping("/create/wallet")
    public ResponseEntity<OrchestratorResponseDto> createWallet(@RequestBody OrchestratorRequestDto request) {
        try{
            OrchestratorResponseDto result = orchestratorService.createWallet(request.getFilename(), request.getPassword());
            return ResponseEntity.ok(result);
        } catch (OpenDidException e) {
            OrchestratorResponseDto errorResponse = new OrchestratorResponseDto();
            errorResponse.setStatus("ERROR");
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    @PostMapping("/create/keys")
    public ResponseEntity<OrchestratorResponseDto> createWalletKeys(@RequestBody OrchestratorRequestDto request) {
        List<String> keyIds = request.getKeyIds();
        if (keyIds == null || keyIds.isEmpty()) {
            throw new IllegalArgumentException("keyIds cannot be null or empty");
        }

        try{
            OrchestratorResponseDto result = orchestratorService.createKeys(request.getFilename(), request.getPassword(), keyIds);
            return ResponseEntity.ok(result);
        } catch (OpenDidException e) {
            OrchestratorResponseDto errorResponse = new OrchestratorResponseDto();
            errorResponse.setStatus("ERROR");
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    @PostMapping("/create/diddoc")
    public ResponseEntity<OrchestratorResponseDto> createDidDocument(@RequestBody OrchestratorRequestDto request) {
        try{
            OrchestratorResponseDto result = orchestratorService.createDidDocument(request.getFilename(), request.getPassword(), request.getDid(), request.getController(), request.getType());
            return ResponseEntity.ok(result);
        } catch (OpenDidException e) {
            OrchestratorResponseDto errorResponse = new OrchestratorResponseDto();
            errorResponse.setStatus("ERROR");
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    @GetMapping("/configs")
    public ResponseEntity<OrchestratorConfigDto> getConfig() {
        OrchestratorConfigDto response = new OrchestratorConfigDto(
                configProperties.getBlockchain(),
                configProperties.getDatabase(),
                configProperties.getServices(),
                configProperties.getGenerator()
        );
        return ResponseEntity.ok(response);
    }

    @PostMapping("/configs")
    public ResponseEntity<OrchestratorResponseDto> updateYaml(@RequestBody Map<String, Object> updates) {
        try {
            OrchestratorResponseDto response = orchestratorService.updateConfig(updates);
            return ResponseEntity.ok(response);
        } catch (OpenDidException e){
            OrchestratorResponseDto errorResponse = new OrchestratorResponseDto();
            errorResponse.setStatus("ERROR");
            return ResponseEntity.status(500).body(errorResponse);
        }
    }

    @GetMapping("/entities")
    public Map<String, Object> getEntities() {
        Map<String, Object> response = new HashMap<>();
        response.put("serviceNames", servicesProperties.getServer().values().stream()
                .map(ServicesProperties.ServiceDetail::getName)
                .collect(Collectors.toList()));

        response.put("servicePorts", servicesProperties.getServer().values().stream()
                .map(ServicesProperties.ServiceDetail::getPort)
                .collect(Collectors.toList()));

        return response;
    }

    @GetMapping("/select")
    public ResponseEntity<Map<String, String>> getTrustRepository() {
        Path CONFIG_PATH = Paths.get("repository.properties");
        if (!Files.exists(CONFIG_PATH)) {
            return ResponseEntity.ok(Map.of("selected", ""));
        }

        Properties props = new Properties();
        try (InputStream in = Files.newInputStream(CONFIG_PATH)) {
            props.load(in);
        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }

        String selected = props.getProperty("selectedRepositories", "");
        return ResponseEntity.ok(Map.of("selected", selected));
    }

    @PostMapping("/select")
    public ResponseEntity<Void> setTrustRepository(@RequestBody Map<String, String> payload) {
        Path CONFIG_PATH = Paths.get("repository.properties");
        String selected = payload.get("selected");

        if (selected != null && !selected.equals("besu") && !selected.equals("lss") && !selected.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        Properties props = new Properties();

        try {
            if (!Files.exists(CONFIG_PATH)) {
                Files.createFile(CONFIG_PATH);
            }

            if (selected == null || selected.isEmpty()) {
                props.remove("selectedRepositories");
            } else {
                props.setProperty("selectedRepositories", selected);
            }

            try (OutputStream out = Files.newOutputStream(CONFIG_PATH)) {
                props.store(out, "Ledger repository selection");
            }

        } catch (IOException e) {
            return ResponseEntity.internalServerError().build();
        }

        return ResponseEntity.ok().build();

    }

    @GetMapping("/getIp")
    public ResponseEntity<Map<String, String>> test() {
        Map<String, String> response = new HashMap<>();
        response.put("serverIp", orchestratorService.getServerIp());
        return ResponseEntity.ok(response);
    }
}
