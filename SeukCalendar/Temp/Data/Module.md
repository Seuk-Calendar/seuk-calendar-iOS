# Data Module

데이터 레이어를 담당하는 모듈입니다. 4개의 타겟으로 구성되어 있습니다.

## 역할

- Repository 인터페이스 구현
- 외부 데이터 소스와의 통신 (API, KeyChain 등)
- DTO → Domain Model 변환
- 인증 토큰 관리

## 디렉토리 구조

```
Data/
├── Package.swift
├── Sources/
│   ├── Common/
│   │   ├── Interceptor/
│   │   └── Network/
│   ├── CalendarData/
│   │   ├── Repository/
│   │   │   ├── CalendarRepositoryImpl.swift
│   ├── UserData/
│   │   └── Repository/
│   └── KeyChainData/
│       ├── KeyChain.swift
│       └── KeyChainType.swift
└── Tests/
    └── DataTests/
```

## 타겟 구성

### 1. Common

공통 네트워크 유틸리티.

**Interceptor**: `Sources/Common/Interceptor/`
- AuthInterceptor.swift (향후): 자동 토큰 주입

**Network**: `Sources/Common/Network/`
- 공통 네트워크 헬퍼

### 2. CalendarData

CalendarDomain의 Repository 구현.

**Repository**: `Sources/CalendarData/Repository/`
- CalendarRepositoryImpl.swift: 실제 구현

**Mapper**: `Sources/CalendarData/Mapper/`
- DTO → Domain Model 변환 로직

**구현 참고**:
- Repository 구현: `Sources/CalendarData/Repository/CalendarRepositoryImpl.swift`
- DTO 변환: `toDomain()` 메서드

### 3. UserData

UserDomain의 Repository 구현.

**Repository**: `Sources/UserData/Repository/`
- UserRepositoryImpl.swift: 실제 구현

### 4. KeyChainData

인증 토큰 등 보안 데이터 저장.

**위치**: `Sources/KeyChainData/`

**주요 파일**:
- KeyChain.swift: iOS Keychain Services 래퍼
- KeyChainType.swift: 저장 타입 정의 (accessToken, refreshToken, userId)

**구현 참고**:
- KeyChain 사용: `Sources/KeyChainData/KeyChain.swift`
- 저장 타입: `Sources/KeyChainData/KeyChainType.swift`

## 의존성

- **Core**: 공통 유틸리티
- **Domain**: 각 Data 타겟은 해당 Domain 타겟에 의존
  - CalendarData → CalendarDomain
  - UserData → UserDomain
- **Common**: CalendarData, UserData가 Common에 의존
- **외부 라이브러리**:
  - Alamofire: HTTP 통신 (Common)

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 18+
- 의존성: Core, Domain, Alamofire
- Products: Common, CalendarData, UserData, KeyChainData
