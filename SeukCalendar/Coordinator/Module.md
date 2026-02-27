# Coordinator Module

의존성 조립 및 화면 라우팅을 담당하는 모듈입니다.

## 역할

- Destination → View 매핑 (Coordinator)
- DI Container (향후 구현)
- ViewFactory 통합 및 화면 생성

## 디렉토리 구조

```
Coordinator/
├── Coordinator.xcodeproj
├── Coordinator/
│   ├── Coordinator.swift
│   └── DIContainer.swift (향후)
└── CoordinatorTests/
```

## 주요 구성요소

### Coordinator (화면 생성자)

Destination을 실제 View로 변환하는 책임.

**위치**: `Coordinator/Coordinator.swift`

**주요 메서드**:
- `view(for:)`: Destination → View 변환
- 타입별 분기: Tab/Push/Sheet/FullScreen별로 처리
- ViewFactory 통합: 각 Feature의 ViewFactory 사용

**구현 참고**:
- TabDestination → View: `view(for: TabDestination)`
- PushDestination → View: `view(for: PushDestination)`
- SheetDestination → View: `view(for: SheetDestination)`
- FullScreenDestination → View: `view(for: FullScreenDestination)`

### DIContainer (향후 구현)

중앙 집중식 의존성 관리.

**위치**: `Coordinator/DIContainer.swift` (향후)

**계획**:
- Swinject 기반 DI Container
- Repository, UseCase, Service 등록
- ViewFactory 의존성 주입

## 의존성

- **Core**: 공통 유틸리티
- **Navigation**: Router, Destination
- **Feature**: 모든 ViewFactory (실제로는 App에서 주입)
- **Domain**: 각 도메인 (DI 등록용)

## Xcode 프로젝트 설정

**위치**: `Coordinator.xcodeproj`

**주요 설정**:
- 플랫폼: iOS 18+
- 프레임워크 타입: Dynamic Framework
- 의존성: Core.framework, Navigation.framework
- 타겟: Coordinator (Framework), CoordinatorTests (Unit Test)

## 사용 가이드

### Coordinator 사용

**참고**: SeukCalendar 앱의 `SeukCalendar/ContentView.swift`에서 Coordinator 초기화 및 사용 예시

### 새로운 화면 추가

1. Navigation/Destination.swift에 Destination 추가
2. Coordinator/Coordinator.swift에 `view(for:)` 케이스 추가
3. 해당 Feature의 ViewFactory 호출
