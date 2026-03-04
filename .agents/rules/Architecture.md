# Architecture

SeukCalendar 프로젝트의 아키텍처 구조를 설명합니다.

## 목차

1. [레이어 구조](#레이어-구조)
2. [패키지 구성](#패키지-구성)
3. [의존성 주입 (DI)](#의존성-주입-di)
4. [네비게이션 / 라우팅](#네비게이션--라우팅)
5. [데이터 흐름](#데이터-흐름)
6. [네트워킹](#네트워킹)
7. [테스트 전략](#테스트-전략)
8. [기술 스택](#기술-스택)

---

## 레이어 구조

SeukCalendar는 **Clean Architecture 기반의 3계층 구조**를 따릅니다.

### 개요

```
                  ┌─────────────────────────────────────┐
                  │     Presentation Layer              │
                  │  (View + ViewModel + UI Logic)      │
                  └─────────────────────────────────────┘
                             ↓ depends on
                  ┌─────────────────────────────────────┐
                  │       Domain Layer                  │
                  │  (UseCase + Entity + Repository     │
                  │   Interface + Business Service)     │
                  └─────────────────────────────────────┘
                            ↑ depends on
┌─────────────────────────────────────┐┌─────────────────────────────────────┐
│       Data Layer                    ││       AI Layer                      │
│  (Repository Implementation +       ││                                     │
│   API Client + Data Source)         ││                                     │
└─────────────────────────────────────┘└─────────────────────────────────────┘
```

### Presentation Layer

**역할**:
- 사용자 인터페이스(UI) 렌더링
- 사용자 인터랙션 처리
- ViewModel을 통한 Domain Layer와의 통신

**패턴**: MVVM (Model-View-ViewModel)

**주요 구성**:
- **View** (SwiftUI): UI 컴포넌트
- **ViewModel** (@Observable): 프레젠테이션 로직 및 상태 관리
- **ViewFactory**: 화면 생성 팩토리

### Domain Layer

**역할**:
- 비즈니스 로직 캡슐화
- 순수 도메인 엔티티 정의
- Repository 인터페이스 제공 (Data Layer와의 계약)

**주요 구성**:
- **Entity**: 순수 비즈니스 객체 (예: `Schedule`, `User`)
- **UseCase**: 특정 비즈니스 로직 실행
- **Repository Interface**: Data Layer가 구현해야 할 계약
- **Service**: 복잡한 도메인 로직

### Data Layer

**역할**:
- Repository 인터페이스 구현
- 외부 데이터 소스와의 통신 (API, 로컬 DB, KeyChain 등)
- DTO → Domain Model 변환

**주요 구성**:
- **Repository Implementation**: Domain의 Repository 인터페이스 구현
- **API Client**: OpenAPI 자동 생성 클라이언트 사용
- **Mock Repository**: 테스트/개발용 Mock 구현체
- **KeyChain**: 보안 데이터 저장소

### 레이어 간 데이터 흐름 예시

### AI Layer

**역할**:
- 자연어 입력을 구조화된 일정 데이터(`ParsedEvent`)로 파싱
- Domain의 `ScheduleNaturalLanguageParser` 인터페이스 구현 제공

**주요 구성**:
- `FoundationModelsParser` (AI): Foundation Models 기반 파서
- `ParsedEventGenerable` (AI): `@Generable` 구조체
- `ParseEventUseCase` (Domain): 파싱 실행 + `ParsedEvent -> Schedule` 변환

---

## 모듈 구성

Xcode 프로젝트 기반으로 각 레이어와 Feature를 **모듈**로 관리합니다.

### 전체 모듈 구조

```
SeukCalendar/
├── Core/                   # 공통 기반 모듈
│   └── Core.xcodeproj
├── DesignSystem/           # UI 디자인 시스템
│   └── DesignSystem.xcodeproj
├── Navigation/             # 네비게이션 시스템
│   └── Navigation.xcodeproj
├── Coordinator/            # 의존성 조립 및 라우팅
│   └── Coordinator.xcodeproj
├── Domain/                 # 비즈니스 로직 (다중 타겟)
│   └── Domain.xcodeproj
├── Data/                   # 데이터 레이어 (다중 타겟)
│   └── Data.xcodeproj
├── AI/                     # AI 레이어 (다중 타겟)
│   └── AI.xcodeproj
├── Feature/                # UI 레이어 (다중 타겟)
│   └── Feature.xcodeproj
├── SeukCalendar/           # App + Widget Extension 타겟
│   └── SeukCalendar.xcodeproj
└── TodayScheduleWidget/    # Widget Extension 소스
    ├── TodayScheduleWidget.swift
    └── TodayScheduleWidgetBundle.swift
```

**핵심 설계 원칙**:
- **독립 xcodeproj 구조**: 각 모듈은 독립적인 Xcode 프로젝트로 구성
- **멀티 타겟**: 각 프로젝트 내부에 여러 타겟을 포함하여 모듈 분리
- **명확한 의존성**: Framework 링크를 통한 타겟 간 의존 관계 관리

### 모듈별 역할

| 모듈 | 역할 | 의존성 | 상세 |
|--------|------|--------|------|
| **Core** | 공통 유틸리티, Extension, 에러 타입 | 없음 | [Module.md](SeukCalendar/Core/Module.md) |
| **DesignSystem** | SwiftUI 공통 컴포넌트, 디자인 리소스 | Core | [Module.md](SeukCalendar/DesignSystem/Module.md) |
| **Navigation** | Router, Destination, 네비게이션 시스템 | Core | [Module.md](SeukCalendar/Navigation/Module.md) |
| **Coordinator** | DI Container, Coordinator | Core, Navigation | [Module.md](SeukCalendar/Coordinator/Module.md) |
| **Domain** | Entity, UseCase, Repository Interface, Service | Core | [Module.md](SeukCalendar/Domain/Module.md) |
| **Data** | Repository 구현, API Client, KeyChain | Core, Domain | [Module.md](SeukCalendar/Data/Module.md) |
| **AI** | Foundation Models, External API, OCR, Speech | Core, Domain | [Module.md](SeukCalendar/AI/Module.md) |
| **Feature** | View, ViewModel, ViewFactory | Core, DesignSystem, Domain, Navigation | [Module.md](SeukCalendar/Feature/Module.md) |
| **SeukCalendar(App)** | 앱 진입점, DI 조립, 위젯 딥링크 처리 | Feature, Data, Domain, AI | [Module.md](SeukCalendar/SeukCalendar/Module.md) |
| **TodayScheduleWidget** | 홈/잠금화면 일정 위젯, TimelineProvider | App Groups(UserDefaults), WidgetKit | [Module.md](SeukCalendar/SeukCalendar/Module.md) |

**의존성 방향**:
1. **Core**: 최하위 레이어, 의존성 없음
2. **DesignSystem, Navigation**: Core에만 의존
3. **Domain**: Core에만 의존 (각 타겟 독립)
4. **Data**: 해당 Domain + Core에 의존
5. **AI**: 해당 Domain + Core에 의존
6. **Feature**: 필요한 Domain + DesignSystem + Core에 의존
7. **Coordinator**: Feature + Domain + Navigation에 의존
8. **App**: 모든 Framework 통합 + Widget 데이터 동기화
9. **Widget Extension**: App Groups를 통해 공유 스냅샷을 읽고 UI 렌더링

---

## 의존성 주입 (DI)

의존성 주입을 통해 각 모듈 간 결합도를 낮추고, 테스트 용이성을 향상시킵니다.

### 목표

- Swinject DI Container 도입
- ViewFactory를 통한 의존성 주입
- 중앙 집중식 의존성 관리

---

## 네비게이션 / 라우팅

완전한 SwiftUI 기반의 **선언적 네비게이션** 시스템을 구현합니다.

### 아키텍처 개요

```
User Action
    ↓
 ViewModel → router.navigate(to: .push(.detail))
    ↓
Router (@Observable, Environment)
    ↓
SwiftUI State 변경 (navigationStackPath, presentedSheet 등)
    ↓
Coordinator → ViewFactory
    ↓
View 생성 및 표시
```

**핵심 컴포넌트**:
1. **Destination**: 모든 화면 목적지를 타입 안전하게 정의
2. **Router**: 계층적 라우터, 네비게이션 상태 관리 (@Observable)
3. **Coordinator**: Destination → View 매핑
4. **NavigationContainer**: Router 계층 생성 및 NavigationStack 관리

### Router 계층 구조

```
Root Router (level: 0)
├── selectedTab: TabDestination?
├── presentedSheet: SheetDestination?
├── fullScreen: FullScreenDestination?
└── Child Routers
    ├── Tab 1 Router (level: 1)
    │   └── navigationStackPath: [PushDestination]
    └── Tab 2 Router (level: 1)
        └── navigationStackPath: [PushDestination]
```

**자세한 내용**: [Navigation Module.md](Pool/Navigation/Module.md)

---

## 데이터 흐름

Clean Architecture 원칙에 따라 **단방향 데이터 흐름**을 구현합니다.

### 전체 데이터 흐름

```
User Interaction
    ↓
View (SwiftUI)
    ↓ send(.action)
 ViewModel (@Observable)
    ↓ execute()
UseCase (Domain)
    ↓ fetch()
Repository Interface (Domain)
    ↑ implements
Repository Implementation (Data)
    ↓ API call
OpenAPIClient
    ↓ HTTP Request
Backend Server
    ↓ HTTP Response
DTO (Data Transfer Object)
    ↓ mapToModel()
Domain Model
    ↓ return
UseCase
    ↓ return
 ViewModel (상태 변경)
    ↓ @Observable 자동 알림
View (자동 리렌더링)
```

### 주요 단계

1. **View → ViewModel**: 사용자 이벤트를 Action으로 전달
2. **ViewModel → UseCase**: 비즈니스 로직 실행
3. **UseCase → Repository**: 데이터 요청
4. **Repository → API**: 네트워크 호출
5. **API → Repository**: DTO 수신 및 Domain Model 변환
6. **Repository → ViewModel**: Domain Model 반환
7. **ViewModel → View**: 상태 변경, 자동 리렌더링

### AI 자연어 파싱 흐름

```
User Input (자연어)
    ↓
CalendarViewModel.send(.parseNaturalLanguage)
    ↓
ParseEventUseCase (Domain)
    ↓
ScheduleNaturalLanguageParser (Domain Interface)
    ↑ implements
FoundationModelsParser (AI)
    ↓
ParsedEvent
    ↓ (수정 가능)
ParseEventUseCase.toSchedule()
    ↓
CreateScheduleUseCase → ScheduleRepository (EventKit)
```

### Widget 데이터 공유 흐름

```
CalendarViewModel
    ↓ fetch/create/update/delete
WidgetSyncingScheduleRepository (App)
    ↓
EventKitScheduleRepository (Data)
    ↓
WidgetScheduleSnapshotStore (App Groups UserDefaults)
    ↓
WidgetCenter.reloadTimelines()
    ↓
TodayScheduleWidget TimelineProvider
    ↓
Small / Medium / Large / Lock Screen 위젯 렌더링
```

---

## 네트워킹

작성 필요

---

## 테스트 전략

레이어 별 주요 로직과 ViewModel을 테스트하여 코드 품질을 보장하고 오버 테스트를 지양합니다.

### 레이어별 테스트

| 레이어 | 테스트 대상 | Mock 사용 | 목표 커버리지 |
|--------|-------------|----------|---------------|
| **Domain** | UseCase, Service | Repository | 80%+ |
| **Presentation** | ViewModel | UseCase, Service | 70%+ |
| **Data** | Repository | - | 60%+ |

### TestSupport 디렉토리

각 패키지의 TestSupport 디렉토리에 Mock을 정의합니다.

```
Domain/
└── TestSupport/
    └── ShortsDomainTestSupport/
        ├── MockShortsRepository.swift
        └── Shorts+Mock.swift

Feature/
└── Sources/
    └── ShortsFeature/
        └── TestSupport/
            └── MockFeedViewModel.swift
```

---

## 기술 스택

Pool iOS 프로젝트에서 사용하는 주요 기술 및 라이브러리입니다.

### UI Framework

| 기술 | 버전 | 용도 |
|------|------|------|
| **SwiftUI** | iOS 26+ | 전체 UI 구현 |
| **UIKit** | iOS 26+ | 일부 UIHostingController, 서드파티 통합 |

**특징**:
- 완전한 SwiftUI 기반
- UIKit은 복잡한 UI에 사용

### 상태 관리

| 기술 | 용도 |
|------|------|
| **@Observable** (iOS 17+) | ViewModel 상태 관리 |
| **Combine** | 비동기 이벤트 스트림 (일부) |

**특징**:
- `@Observable` 매크로로 `@Published` + `ObservableObject` 대체
- Combine은 최소한 사용 (async/await 선호)

### 아키텍처 & DI

| 기술 | 상태 | 용도 |
|------|------|------|
| **Swinject** | 도입 예정 | 의존성 주입 |

**목표**:
- Swinject DI Container 도입
- ViewFactory를 통한 의존성 주입

### 네트워킹

작성 필요

### 데이터 저장

| 기술 | 용도 |
|------|------|
| **Keychain Services** | 인증 토큰 암호화 저장 |
| **UserDefaults** | 간단한 설정 저장 |

### 개발 도구

| 도구 | 용도 |
|------|------|
| **Xcode Projects** | 모듈 관리 |
| **SwiftLint** | 코드 스타일 검사 |
| **Fastlane** | 빌드 및 배포 자동화 |

### AI / ML

| 기술 | 용도 |
|------|------|
| **Foundation Models** (iOS 26+) | 자연어 일정 파싱 |

### 기술 스택 요약

| 카테고리 | 주요 기술 |
|----------|-----------|
| **UI** | SwiftUI, @Observable |
| **아키텍처** | Clean Architecture, MVVM |
| **DI** | Swinject |
| **AI** | Foundation Models |
| **네트워킹** | 작성 필요 |
| **보안** | Keychain Services |
| **모듈 관리** | Xcode Projects (xcodeproj) |

---
