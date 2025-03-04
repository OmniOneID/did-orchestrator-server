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

package org.omnione.did.base.exception;

public enum ErrorCode {
    UNKNOWN_SERVER_ERROR("9999", "An unknown server error has occurred.", 500),
    INVALID_PORT_NUMBER("1000", "Invalid port number.", 400),
    YAML_READ_ERROR("1001", "Error occurred while reading the YAML configuration file.", 500),
    YAML_WRITE_ERROR("1002", "Error occurred while writing to the YAML configuration file.", 500),
    FABRIC_STARTUP_FAILED("2001", "Hyperledger Fabric startup failed.", 500),
    FABRIC_SHUTDOWN_FAILED("2002", "Hyperledger Fabric shutdown failed.", 500),
    POSTGRE_STARTUP_FAILED("3001", "PostgreSQL startup failed.", 500),
    POSTGRE_SHUTDOWN_FAILED("3002", "PostgreSQL shutdown failed.", 500),
    POSTGRE_HEALTH_CHECK_FAILED("3003", "PostgreSQL health check failed.", 500),
    FABRIC_HEALTH_CHECK_FAILED("2003", "Hyperledger Fabric health check failed.", 500),
    INVALID_PASSWORD("4001", "The provided password is incorrect.", 401),
    CONFIG_UPDATE_FAILED("5001", "Failed to update the configuration.", 500);


    private final String code;
    private final String message;
    private final int httpStatus;

    ErrorCode(String code, String message, int httpStatus) {
        this.code = code;
        this.message = message;
        this.httpStatus = httpStatus;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }

    public int getHttpStatus() {
        return httpStatus;
    }

    public static String getMessageByCode(String code) {
        for (ErrorCode errorCode : values()) {
            if (errorCode.getCode().equals(code)) {
                return errorCode.getMessage();
            }
        }
        return "Unknown error code: " + code;
    }

    @Override
    public String toString() {
        return String.format("ErrorCode{code='%s', message='%s', httpStatus=%d}", code, message, httpStatus);
    }
}
