# Navigation Module

SwiftUI 기반의 선언적 네비게이션 시스템을 제공합니다.

## 역할

- Router, Destination 정의
- 계층적 네비게이션 관리
- 타입 안전한 화면 전환

## 디렉토리 구조

```
Navigation/
├── Package.swift
├── Sources/
│   └── Navigation/
│       ├── Destination.swift
│       ├── Router.swift
│       └── Extensions/
└── Tests/
    └── NavigationTests/
```

## 주요 구성요소

### Destination (화면 목적지)

모든 네비게이션 타입을 열거형으로 정의하여 타입 안전성 보장.

**위치**: `Sources/Navigation/Destination.swift`

**주요 타입**:
- `Destination`: 전체 네비게이션 타입
- `TabDestination`: 탭 목적지
- `PushDestination`: Push 네비게이션
- `SheetDestination`: Sheet 표시
- `FullScreenDestination`: 풀스크린 표시

### Router (네비게이션 라우터)

계층적 라우터 구조로 네비게이션 상태 관리.

**위치**: `Sources/Navigation/Router.swift`

**주요 기능**:
- `@Observable`: SwiftUI와 자동 바인딩
- 계층 구조: 부모-자식 관계로 상태 전파
- level 0 (루트): `selectedTab`, `presentedSheet`, `fullScreen` 관리
- level 1+ (자식): `navigationStackPath` 관리

**주요 메서드**:
- `navigate(to:)`: 통합 네비게이션
- `push(_:)`: Push 네비게이션
- `select(tab:)`: 탭 선택
- `presentSheet(_:)`: Sheet 표시
- `presentFullScreen(_:)`: 풀스크린 표시

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

## 의존성

- **Core**: 공통 유틸리티

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 26+
- 의존성: Core
- 타겟: Navigation, NavigationTests

## 사용 가이드

### Router를 통한 네비게이션

**참고**: `Sources/Navigation/Router.swift`의 `navigate(to:)` 메서드

### NavigationStack 설정

**참고**: SeukCalendar 앱의 `SeukCalendar/SeukCalendar/ContentView.swift`에서 NavigationContainer 사용 예시

### Destination 추가

새로운 화면을 추가할 때 `Sources/Navigation/Destination.swift`에 케이스 추가.
