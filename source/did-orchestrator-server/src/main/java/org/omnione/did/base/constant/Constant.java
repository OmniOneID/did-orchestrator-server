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

package org.omnione.did.base.constant;

public class Constant {
    public static final String BLOCKCHAIN_START_MESSAGE = "starting checked";
    public static final String BLOCKCHAIN_SUCCESS_CHAINCODE_MESSAGE = "Chaincode initialization is not required";
    public static final String BLOCKCHAIN_FAIL_CHAINCODE_MESSAGE = "Deploying chaincode failed";
    public static final String BLOCKCHAIN_FAIL_DOCKER_MESSAGE = "Cannot connect to the Docker daemon";
    public static final String BLOCKCHAIN_RESET_MESSAGE = "Removing generated chaincode docker images";


    public static final String POSTGRE_START_MESSAGE = "Started";
    public static final String POSTGRE_STOP_MESSAGE = "stop";
    public static final String POSTGRE_HEALTH_MESSAGE = "All databases are successfully created";

    public static final String CLI_WALLET_EXCEPTION_MESSAGE = "org.omnione.did.wallet.exception.WalletException";
    public static final String CLI_CRYPTO_EXCEPTION_MESSAGE = "org.omnione.did.crypto.exception.CryptoException";

    public static String WALLET_DIR;
    public static String DID_DOC_DIR;
    public static String CLI_TOOL_DIR;
    public static String LOGS_PATH;

}
