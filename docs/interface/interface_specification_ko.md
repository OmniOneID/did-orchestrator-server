# DID Orchestrator Server 인터페이스 명세

본 문서는 DID Orchestrator Server의 비즈니스 로직 구현에 있어서 중심이 되는 인터페이스에 대한 상위 레벨 구조 및 역할을 설명합니다. 주요 기능, 메서드 설명, 입력 및 반환 타입, 예외 사항 타입 등에 대해 안내합니다.

## 1. 개요

DID Orchestrator Server는 현재 `org.omnione.did.orchestrator.service.OrchestratorService`에서 단일 형태의 인터페이스를 정의합니다. 이는 시스템 내 다양한 구성 요소(Hyperledger Fabric, PostgreSQL, CLI Tool 등)의 시작(Start), 종료(Shutdown), 상태 점검(Health Check), 리소스 생성(Create) 작업을 통합적으로 관리하는 서비스 인터페이스입니다.

## 2. 설계 특징
### 2.1. 주요 특징
- 향후 Hyperledger Besu 등 새로운 인프라 확장 지원이 용이하도록 모듈화된 구조를 채택하였습니다.
- 모든 요청/응답은 일관된 `OrchestratorResponseDto` 객체를 사용하여 응답 포맷을 표준화합니다.
- Port 기반 엔티티 제어를 통해 유연한 인스턴스 관리가 가능합니다.

### 2.2. 인터페이스 호출 구조
Controller인 `OrchestratorController`에서 Request를 수신하며, `OrchestratorServiceImpl`이 인터페이스의 실제 구현체입니다.
```java
OrchestratorController → (Interface) OrchestratorService → (Implements) OrchestratorServiceImpl
```

## 3. 인터페이스 목록
| 인터페이스명 | 설명 | 풀 패키지 경로 |
|:------|:----|:---------|
| `OrchestratorService` | DID Orchestrator Server의 주요 비즈니스 로직을 정의하는 서비스 인터페이스 | **org.omnione.did.orchestrator.service.OrchestratorService** |
* DID Orchestrator Server는 현재 단일 인터페이스만 사용합니다.

## 4. 기능별 인터페이스 설명 (OrchestratorService)

### 4.1. Hyperledger Fabric 제어

| 메서드 | 설명 | 파라미터 | 반환 값 |
|:------|:----|:---------|:--------|
| `requestStartupFabric()` | Hyperledger Fabric 네트워크를 시작합니다. | 없음 | `OrchestratorResponseDto` | 
| `requestShutdownFabric()` | Hyperledger Fabric 네트워크를 종료합니다. | 없음 | `OrchestratorResponseDto` | 
| `requestHealthCheckFabric()` | Hyperledger Fabric 네트워크의 상태를 점검합니다. | 없음 | `OrchestratorResponseDto` | 
| `requestResetFabric()` | Hyperledger Fabric 네트워크를 재설정합니다. | 없음 | `OrchestratorResponseDto` | 
* OpenDID에서 공통적으로 사용하는 Ledger에 해당하는 `Hyperledger Fabric`을 제어하는 기능을 수행합니다.
* 향후 `Hyperledger Besu`, `RDBMS 기반 Repository 서버` 등을 확장 지원할 예정입니다.

#### 4.1.2. 소스 코드 예시
```java
package org.omnione.did.orchestrator.service;

..

public interface OrchestratorService {
    //Hyperledger Fabric
    OrchestratorResponseDto requestStartupFabric();
    OrchestratorResponseDto requestShutdownFabric();
    OrchestratorResponseDto requestHealthCheckFabric();
    OrchestratorResponseDto requestResetFabric();

..
```

### 4.2. PostgreSQL 제어

| 메서드 | 설명 | 파라미터 | 반환 값 |
|:------|:----|:---------|:--------|
| `requestStartupPostgre()` | PostgreSQL 데이터베이스를 시작합니다. | 없음 | `OrchestratorResponseDto` |
| `requestShutdownPostgre()` | PostgreSQL 데이터베이스를 종료합니다. | 없음 | `OrchestratorResponseDto` |
| `requestHealthCheckPostgre()` | PostgreSQL 데이터베이스의 상태를 점검합니다. | 없음 | `OrchestratorResponseDto` |
* OpenDID 서버들에서 공통적으로 사용하는 RDBMS 해당하는 `PostgreSQL`을 제어하는 기능을 수행합니다.
* Issuer, Verifier, TA 등이 운용되기 위한 각종 데이터들이 저장됩니다.

#### 소스 코드 예시
```java
package org.omnione.did.orchestrator.service;

..

public interface OrchestratorService {
..

    // PostgreSQL
    OrchestratorResponseDto requestStartupPostgre();
    OrchestratorResponseDto requestShutdownPostgre();
    OrchestratorResponseDto requestHealthCheckPostgre();

..
```

### 4.3. 엔티티 제어 (포트 기반 제어)

| 메서드 | 설명 | 파라미터 | 반환 값 |
|:------|:----|:---------|:--------|
| `requestStartupAll()` | 모든 엔티티를 일괄 시작합니다. | 없음 | `void` |
| `requestShutdownAll()` | 모든 엔티티를 일괄 종료합니다. | 없음 | `void` |
| `requestStartup(String port)` | 특정 포트 기반의 엔티티를 시작합니다. | `port: 엔티티 포트 번호` | `OrchestratorResponseDto` |
| `requestShutdown(String port)` | 특정 포트 기반의 엔티티를 종료합니다. | `port: 엔티티 포트 번호` | `OrchestratorResponseDto` |
| `requestHealthCheck(String port)` | 특정 포트 기반의 엔티티 상태를 점검합니다. | `port: 엔티티 포트 번호` | `OrchestratorResponseDto` |
| `requestRefresh(String port)` | 특정 포트 기반 엔티티의 구성을 새로고침(Refresh)합니다. | `port: 엔티티 포트 번호` | `OrchestratorResponseDto` |
* OpenDID 내부 서버들을 포트 기반으로 식별하여 해당 엔티티를 제어하는 기능을 수행합니다.

#### 소스 코드 예시
```java
package org.omnione.did.orchestrator.service;

..

public interface OrchestratorService {
..

    //entities
    void requestStartupAll();
    void requestShutdownAll();
    OrchestratorResponseDto requestStartup(String port) throws OpenDidException;
    OrchestratorResponseDto requestShutdown(String port) throws OpenDidException;
    OrchestratorResponseDto requestHealthCheck(String port) throws OpenDidException;
    OrchestratorResponseDto requestRefresh(String port);

..
```

### 4.4. CLI Tool 기반 DID 리소스 생성

| 메서드 | 설명 | 파라미터 | 반환 값 |
|:------|:----|:---------|:--------|
| `createAll(String password)` | CLI Tool을 이용해 지갑, 키, DID Document를 모두 생성합니다. | `password: 암호화 키 비밀번호` | `OrchestratorResponseDto` |
| `createWallet(String fileName, String password)` | 지정된 파일명과 비밀번호를 이용해 지갑(Wallet)을 생성합니다. | `fileName: 파일명`, `password: 비밀번호` | `OrchestratorResponseDto` |
| `createKeys(String fileName, String password, List<String> keyIds)` | 지정된 파일에 여러 키(Key)를 생성합니다. | `fileName: 파일명`, `password: 비밀번호`, `keyIds: 키 ID 리스트` | `OrchestratorResponseDto` |

| 메서드 | 설명 | 파라미터 | 반환 값 |
|:------|:----|:---------|:--------|
| `createDidDocument(String fileName, String password, String did, String controller, String type)` | DID Document를 생성합니다. | `fileName: 파일명`, `password: 비밀번호`, `did: DID 식별자`, `controller: 컨트롤러 DID`, `type: 키 타입` | `OrchestratorResponseDto` |
* OpenDID 엔티티들을 구동하기 위한 Wallet, Key, DID Document 등을 생성 및 핸들링을 수행하는 역할을 합니다.


#### 소스 코드 예시
```java
package org.omnione.did.orchestrator.service;

..

public interface OrchestratorService {
..

    //cli-tool
    OrchestratorResponseDto createAll(String password);
    OrchestratorResponseDto createWallet(String fileName, String password);
    OrchestratorResponseDto createKeys(String fileName, String password, List<String> keyIds);
    OrchestratorResponseDto createDidDocument(String fileName, String password, String did, String controller, String type);

..
```

### 4.5. 기타

| 메서드 | 설명 | 파라미터 | 반환 값 |
|:------|:----|:---------|:--------|
| `getServerIp()` | 오케스트레이터 서버의 IP 주소를 반환합니다. | 없음 | `String` |
| `updateConfig(Map<String, Object> updates)` | 오케스트레이터 서버의 설정(config)을 업데이트합니다. | `updates: 설정 변경값 맵` | `OrchestratorResponseDto` |

#### 코드 예시
```java
package org.omnione.did.orchestrator.service;

..

public interface OrchestratorService {
..

    String getServerIp();
    OrchestratorResponseDto updateConfig(Map<String, Object> updates);

..
```

## 5. 기타

### 예외 처리 전략
- `requestStartup(String port)`, `requestShutdown(String port)`, `requestHealthCheck(String port)` 메서드는 `OpenDidException`을 발생시킬 수 있습니다.
- 나머지 메서드는 실패 시에도 `OrchestratorResponseDto` 객체를 통해 상태를 반환합니다.
