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

package org.omnione.did.orchestrator.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.omnione.did.base.property.BlockchainProperties;
import org.omnione.did.base.property.GeneratorProperties;
import org.omnione.did.base.property.DatabaseProperties;
import org.omnione.did.base.property.ServicesProperties;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class OrchestratorConfigDto {
    private BlockchainProperties blockchain;
    private DatabaseProperties database;
    private ServicesProperties services;
    private GeneratorProperties generator;
}