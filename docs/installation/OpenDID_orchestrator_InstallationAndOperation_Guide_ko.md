# OpenDID Orchestrator 설치 및 구동 가이드

본 문서는 OpenDID Orchestrator를 설치하고 구동하는 방법을 설명합니다. 아래 단계를 따라 진행하시면 됩니다.

---

## 1. 시스템 요구 사항
OpenDID Orchestrator를 설치 및 구동하기 위해서는 아래 요구사항이 충족되어야 합니다.
- **Java 17** 이상
- **Gradle 7.0** 이상
- **Git 설치**
- **Bash 지원**

Git 설치를 위해서는 [Git 설치 가이드](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)를 참조해주세요.<br>
Windows 환경의 경우 Bash 지원을 위해서는 WSL2 설치가 필요합니다. [WSL2 설치 가이드](https://learn.microsoft.com/en-us/windows/wsl/install)를 참조해주세요.

---

## 2. did-orchestrator-server를 git clone해서 내려받기
OpenDID Orchestrator 프로젝트를 로컬 환경에 클론합니다. 아래 명령어를 터미널에 입력하여 프로젝트를 다운로드하세요.

```bash
git clone https://github.com/OmniOneID/did-orchestrator-server.git
```

---

## 3. download.sh 실행
OpenDID Orchestrator는 개별 서버 엔티티들을 구동 및 관리하는 역할을 하므로, 각각의 개별 서버 엔티티 리소스에 대한 다운로드가 필요합니다.<br>
아래 명령어를 터미널에 입력하여 download.sh를 실행하여 개별 서버 엔티티들을 다운로드하세요.

```bash
cd did-orchestrator-server/source/did-orchestrator-server/
sh download.sh
```

---

## 4. 서버 구동
프로젝트 소스는 `source` 디렉토리 하위에 위치하며, 각 구동 방법에 따라 해당 디렉토리에서 소스를 불러와 설정해야 합니다.
아래와 같이 크게 2가지 방법으로 서버 구동이 가능합니다.

1. **IDE를 사용하는 방법**: 통합 개발 환경(IDE)에서 프로젝트를 열고, 실행 구성을 설정한 후 서버를 직접 실행할 수 있습니다.

2. **Build 후 콘솔 명령어를 사용하는 방법**: 프로젝트를 빌드한 후, 생성된 JAR 파일을 콘솔에서 명령어(`java -jar`)로 실행하여 서버를 구동할 수 있습니다.

## 4.1. IntelliJ IDEA로 구동하기 (Gradle 지원)
IntelliJ IDEA는 Java 개발에 널리 사용되는 통합 개발 환경(IDE)입니다. Open DID의 서버는 Gradle을 사용하여 빌드되므로, IntelliJ IDEA에서 쉽게 프로젝트를 설정하고 서버를 실행할 수 있습니다.

### 4.1.1. IntelliJ IDEA 설치 및 설정
1. IntelliJ를 설치합니다. (설치 방법은 아래 링크를 참조)

> **참고 링크**
> - [IntelliJ IDEA 다운로드](https://www.jetbrains.com/idea/download/)

### 4.1.2. IntelliJ에서 프로젝트 열기
- IntelliJ를 실행시키고 `File -> New -> Project from Existing Sources`를 선택합니다. 파일 선택 창이 나타나면 'source/did-orchestrator-server' 폴더를 선택합니다.
- 프로젝트를 열면 build.gradle 파일이 자동으로 인식됩니다.
- Gradle이 자동으로 필요한 의존성 파일들을 다운로드하며, 이 과정이 완료될 때까지 기다립니다.

### 4.1.3. Gradle 빌드
- IntelliJ IDEA의 `Gradle` 탭에서 `Tasks -> build -> build`를 실행합니다. 
- 빌드가 성공적으로 완료되면, 프로젝트가 실행 가능한 상태로 준비됩니다.

### 4.1.4. 서버 구동
- IntelliJ IDEA의 Gradle 탭에서 Tasks -> application -> bootRun을 선택하고 실행합니다.
- Gradle이 자동으로 서버를 빌드하고 실행합니다.
- 콘솔 로그에서 "Started [ApplicationName] in [time] seconds" 메시지를 확인하여 서버가 정상적으로 실행되었는지 확인합니다.

## 4.2. 콘솔 명령어로 구동하기
콘솔 명령어를 사용하여 Open DID 서버를 구동할 수 있습니다. 아래 절차는 Gradle을 이용해 프로젝트를 빌드하고, 생성된 JAR 파일을 사용하여 서버를 구동하는 과정입니다.

### 4.2.1. Gradle 빌드 명령어
- gradlew를 사용하여 소스를 빌드합니다.
  ```shell
    # 복제한 리포지토리로의 소스폴더로 이동
    cd source/did-orchestrator-server

    # Gradle Wrapper 실행 권한을 부여
    chmod 755 ./gradlew

    # 프로젝트를 클린 빌드 (이전 빌드 파일을 삭제하고 새로 빌드)
    ./gradlew clean build
  ```

- 빌드된 폴더로 이동하여 JAR 파일이 생성된 것을 확인합니다.
    ```shell
      cd build/libs
      ls
    ```
- 이 명령어는 `did-orchestrator-server-1.0.0.jar` 파일을 생성합니다.


### 4.2.2. 서버 구동
빌드된 JAR 파일을 사용하여 서버를 구동합니다:

```bash
cp did-orchestrator-server-1.0.0.jar ../../
cd ../../
java -jar did-orchestrator-server-1.0.0.jar
```

---

## 5. 브라우저에서 Orchestrator 접속

Orchestrator 서버가 정상적으로 구동되면, 브라우저에서 아래 주소로 접속합니다. 기본 포트는 `9001`입니다.

```
http://<현재_IP>:9001
```

예를 들어, 로컬 환경에서 실행 중이라면:  
```
http://localhost:9001
```

---

## 6. Hyperledger Fabric 및 PostgreSQL를 위한 Docker 구동
OpenDID Orchestrator는 Hyperledger Fabric Network와 PostgreSQL DB를 사용합니다.  
이러한 서비스를 구동하기 위해 Docker Desktop 또는 Colima를 실행해야 합니다. 아래는 각 운영체제별 실행 방법입니다.

### Windows
1. [Docker Desktop](https://www.docker.com/products/docker-desktop)을 다운로드 및 설치합니다.  
2. 설치 후 Docker Desktop을 실행합니다.

### macOS
1. [Colima](https://github.com/abiosoft/colima) 또는 [Docker Desktop](https://www.docker.com/products/docker-desktop)를 설치합니다.  
2. Colima를 사용하는 경우, 다음 명령어로 Colima를 실행합니다:  
```bash
colima start
```

### Linux
1. Docker를 설치합니다.  
```bash
sudo apt-get update
sudo apt-get install docker.io docker-compose
```
2. Docker 서비스를 시작합니다.  
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

---

## 7. Hyperledger Fabric 구동을 위한 Go 설치
Hyperledger Fabric의 Chaincode가 Go 언어로 구성되어 있어 Go 설치가 필요합니다.<br>
[Fabric 설치 가이드](https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html)의 Go 설치 부분을 참조하여 Go를 설치해주세요.<br>

위 절차까지 수행되면 Orchestrator를 사용하기 위한 모든 사전 준비가 완료되었습니다!

---

## 8. Wallet 및 DID Document 생성
오케스트레이터를 통해 전체 엔티티에 대한 Wallet 및 DID Document를 일괄 생성할 수 있습니다.<br>
우상단에 위치한 **Generate All** 버튼을 클릭해주세요.<br>
각 엔티티의 이름 및 기본 디폴트 패스워드를 기준으로 모든 엔티티들의 Wallet 및 DID Document가 자동 생성됩니다.<br>

### 개별 엔티티별 생성
특정 엔티티에 대한 Wallet 또는 DID Document를 수동으로 생성하려면 **Configuration** 탭으로 이동하여 **easySettingModeEnabled** 값을 **false**로 변경한 후 저장하세요.<br>
이렇게 하면 각 엔티티에 대한 개별 생성 버튼이 활성화되어 이름과 비밀번호를 수동으로 입력하여 생성할 수 있습니다.<br>
그러나 이 방법을 사용할 경우 생성된 Wallet에 대해서는 개별 엔티티 설정 페이지에서 경로와 비밀번호를 직접 설정해야 합니다.

---

## 9. 전체 엔티티 구동

브라우저에서 Orchestrator에 접속한 후, **All Entities** 버튼을 클릭하여 전체 엔티티들을 구동합니다.<br>
각 서비스 및 엔티티가 구동이 되면 녹색이 점등됩니다.<br>

*각 서비스 및 엔티티는 전체 구동/중지 및 개별 구동/중지가 가능합니다.*

---

## 10. 개별 엔티티 설정

Orchestrator의 역할은 이제 완료되었습니다.<br>
개별 엔티티의 매뉴얼을 참조하고, **Settings**를 클릭하여 이동한 후, 개별 설정을 진행하세요.

---

## 추가 참고 사항

각 서비스 및 엔티티의 구동이 정상적으로 실행되지 않는다면 로그를 확인할 수 있습니다. 엔티티 이름 오른쪽의 log 아이콘을 클릭하세요.<br>

---

이제 OpenDID Orchestrator가 정상적으로 구동되었습니다.  
추가적인 문의 사항은 프로젝트의 [이슈 트래커](https://github.com/OmniOneID/did-orchestrator-server/issues)를 이용해 주세요.
