DID Orchestrator Server 소스 코드
==

DID Orchestrator Server 소스 코드 저장소에 오신 것을 환영합니다. 이 디렉토리는 DID Orchestrator Server의 핵심 소스 코드와 빌드 구성을 포함하고 있습니다.

## 디렉토리 구조

다음은 디렉토리 구조의 개요입니다.

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
    └── Besu
    └── Postgre
├── src
└── build.gradle
└── README.md
```

<br/>

다음은 디렉토리의 각 폴더와 파일에 대한 설명입니다:

| 이름           | 설명                                   |
| -------------- | ------------------------------------- |
| did-orchestrator-server | Orchestrator Server 소스 코드 및 빌드 파일 |
| ┖ gradle       | Gradle 빌드 구성 및 스크립트            |
| ┖ libs         | 외부 라이브러리 및 종속성               |
| ┖ admin        | 프런트엔드 관련 소스 코드 디렉토리        |
| ┖ src          | 백엔드 소스 코드 디렉토리                |
| ┖ shells       | 블록체인, RDBMS 등을 위한 비소스 디렉토리 |
| ┖ build.gradle | Gradle 빌드 구성 파일                  |
| ┖ README.md    | 소스 코드 개요 및 지침서                |

## 라이브러리
이 프로젝트에서 사용되는 라이브러리는 세 가지 주요 범주로 구성되어 있습니다:

1. **프런트엔드 서드파티 라이브러리**: Orchestrator 서버의 프런트엔드는 [TypeScript](https://www.typescriptlang.org/)와 [React.js](https://react.dev/)를 기반으로 개발되었으며, DID Orchestrator를 위한 UI/UX를 제공합니다.

2. **백엔드 서드파티 라이브러리**: 이러한 라이브러리는 [build.gradle](build.gradle) 파일을 통해 관리되는 오픈소스 종속성입니다. 서드파티 라이브러리와 그 라이선스의 자세한 목록은 [LICENSE-dependencies.md](../../dependencies-license.md) 파일을 참조해 주세요.

3. **기타 라이브러리**: 이러한 라이브러리는 블록체인, RDBMS 및 기타 서드파티 모듈과 같이 소스 영역에 속하지 않는 모듈입니다.

## 프런트엔드 구성 요소
Orchestrator 서버의 모든 프런트엔드 관련 구성 요소는 admin 폴더 아래에 위치하며, 주요 항목은 다음과 같습니다:

- `src` : React 소스 코드 디렉토리
- `public` : index.html과 같은 정적 파일을 저장하는 디렉토리
- `build.sh` : 프로젝트 빌드 과정을 자동화하는 bash 스크립트
- `package.json` : 프로젝트의 메타데이터와 종속성 목록을 포함
- `package-lock.json` : package.json에 정의된 종속성의 정확한 버전을 기록
- `postcss.config.js` : PostCSS 구성 파일
- `tailwind.config.js` : Tailwind CSS 구성 파일
- `tsconfig.json` : TypeScript 구성 파일

### React 실행 지침
프런트엔드 애플리케이션은 admin 디렉토리에서 다음 명령어를 사용하여 실행할 수 있습니다:

```sh
npm install  # 필요한 경우 종속성 패키지 설치
npm start    # 개발 서버 시작
```

### 빌드 및 배포
서버 측 `resources/static` 디렉토리에 정적 파일을 배포하려면 빌드 과정을 완료해야 합니다. <br>
이를 위해 `admin` 디렉토리 아래의 `build.sh` 스크립트를 실행하면 빌드와 배포 과정을 자동으로 처리합니다. 예시 명령어는 다음과 같습니다:

```sh
sh build.sh     # 빌드 및 배포, 빌드된 파일을 백엔드 리소스 영역으로 이동
```

빌드된 정적 파일은 `build` 디렉토리에 생성되며, 이 파일들은 서버에서 제공하기 위해 백엔드의 `resources/static` 디렉토리로 이동할 수 있습니다.

## 비소스 모듈 (블록체인 및 RDBMS 구성 요소)
이러한 구성 요소는 shells 폴더 아래에 위치하며, 주요 항목은 다음과 같습니다:

- `Besu` : Hyperledger Besu 테스트 노드 실행 영역, **Hyperledger Besu v25.5.0** 사용
- `Postgre` : PostgreSQL 실행 영역, **PostgreSQL v16.4** 사용

## 문서

더 자세한 정보는 다음 문서를 참조하세요:

- [API 참조](../../docs/api/Orchestrator_API_ko.md)  
  DID Orchestrator Server의 API 엔드포인트에 대한 자세한 참조.

- [OpenDID orchestrator 설치 및 운영 가이드](../../docs/installation/OpenDID_orchestrator_InstallationAndOperation_Guide_ko.md)  
  설치 및 구성 지침.

## 기여하기

코드 행동 강령과 풀 리퀘스트 제출 과정에 대한 자세한 내용은 [CONTRIBUTING.md](../../CONTRIBUTING.md)와 [CODE_OF_CONDUCT.md](../../CODE_OF_CONDUCT.md)를 읽어주세요.

## 라이선스
[Apache 2.0](../../LICENSE)

## 연락처
질문이나 지원이 필요하시면 [관리자](../../MAINTAINERS.md)에게 연락해 주세요.