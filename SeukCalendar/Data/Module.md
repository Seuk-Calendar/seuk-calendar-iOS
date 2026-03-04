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
├── Data.xcodeproj
├── Common/
│   ├── Interceptor/
│   └── Network/
├── CalendarData/
│   ├── Repository/
│   │   └── EventKitScheduleRepository.swift
├── UserData/
│   └── Repository/
├── KeyChainData/
│   ├── KeyChain.swift
│   └── KeyChainType.swift
└── DataTests/
```

## 타겟 구성

### 1. Common

공통 네트워크 유틸리티.

**Interceptor**: `Common/Interceptor/`
- AuthInterceptor.swift (향후): 자동 토큰 주입

**Network**: `Common/Network/`
- 공통 네트워크 헬퍼

### 2. CalendarData

CalendarDomain의 Repository 구현.

**Repository**: `CalendarData/Repository/`
- `EventKitScheduleRepository.swift`: EventKit 권한 요청, 일정 CRUD, EKEvent ↔ Schedule 변환
  - `EKAlarm` ↔ `ScheduleAlarm` 매핑으로 알림 생성/조회 지원
  - `requestAccess()`에서 캘린더/알림 권한을 함께 처리
  - `observeScheduleChanges()`로 `EKEventStoreChanged` 알림을 AsyncStream으로 전달

**구현 참고**:
- Repository 구현: `CalendarData/Repository/EventKitScheduleRepository.swift`
- EventKit 권한 요청: `requestAccess()`
- iCloud 캘린더 확인: `hasICloudCalendar()`
- 외부 변경 감지: `observeScheduleChanges()`

### 3. UserData

UserDomain의 Repository 구현.

**Repository**: `UserData/Repository/`
- UserRepositoryImpl.swift: 실제 구현

### 4. KeyChainData

인증 토큰 등 보안 데이터 저장.

**위치**: `KeyChainData/`

**주요 파일**:
- KeyChain.swift: iOS Keychain Services 래퍼
- KeyChainType.swift: 저장 타입 정의 (accessToken, refreshToken, userId)

**구현 참고**:
- KeyChain 사용: `KeyChainData/KeyChain.swift`
- 저장 타입: `KeyChainData/KeyChainType.swift`

## 의존성

- **Core**: 공통 유틸리티
- **Domain**: 각 Data 타겟은 해당 Domain 타겟에 의존
  - CalendarData → CalendarDomain
  - UserData → UserDomain
- **Common**: CalendarData, UserData가 Common에 의존
- **외부 라이브러리**:
  - Alamofire: HTTP 통신 (Common)
  - EventKit: 시스템 캘린더 접근 및 동기화

## Xcode 프로젝트 설정

**위치**: `Data.xcodeproj`

**주요 설정**:
- 플랫폼: iOS 18+
- 프레임워크 타입: Dynamic Framework
- 의존성: Core.framework, CalendarDomain.framework, UserDomain.framework, Alamofire
- 타겟:
  - Common (Framework)
  - CalendarData (Framework)
  - UserData (Framework)
  - KeyChainData (Framework)
  - DataTests (Unit Test)
