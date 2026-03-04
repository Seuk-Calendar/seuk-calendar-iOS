# Feature Module

UI 레이어를 담당하는 모듈입니다. 여러 개의 Feature 타겟으로 구성되어 있습니다.

## 역할

- SwiftUI View 구현
- ViewModel을 통한 프레젠테이션 로직
- ViewFactory를 통한 화면 생성
- 사용자 인터랙션 처리

## 디렉토리 구조

```
Feature/
├── Feature.xcodeproj
├── BaseFeature/
│   ├── View/
│   └── Utility/
├── CalendarFeature/
│   ├── Calendar/
│   │   ├── CalendarView.swift
│   │   ├── CalendarViewModel.swift
│   │   ├── CalendarViewModel+Action.swift
│   │   ├── CalendarViewModel+Model.swift
│   │   └── Components/
│   │       └── ScheduleDetailView.swift
│   └── CalendarViewFactory.swift
└── FeatureTests/
```

## 타겟 구성

### 1. BaseFeature

Feature 관련 유틸리티(모든 Feature가 의존).

**위치**: `BaseFeature/`
- BaseView, BaseViewModel 등 공통 기반


### 2. CalendarFeature

캘린더 화면.

**Calendar**: `CalendarFeature/Calendar/`
- CalendarView.swift: Calendar View
- CalendarViewModel.swift: Calendar ViewModel (@Observable)
  - 캘린더 로드/권한/자연어 파싱 + 알림 프리셋 편집 + iCloud 변경 감지 기반 자동 새로고침 처리
- CalendarViewModel+Action.swift: ViewModel Action enum 분리 (`refreshSchedules` 포함)
- CalendarViewModel+Model.swift: ViewModel 보조 enum/모델(ViewMode/PermissionState/ParsedEventDraft/SyncStatusTone) 분리
- Components/ScheduleDetailView.swift: 일정 상세 화면

**ViewFactory**: `CalendarFeature/CalendarViewFactory.swift`
- 화면 생성 팩토리
- `CalendarViewModel` 생성/주입 책임 보유 (`CalendarView`는 필수 주입만 허용)
- DIContainer 도입 전까지 `makeCalendarView(initialSelectedDate:initialScheduleID:)` 내부에서 전달받은 `ScheduleRepository`와 `ScheduleNaturalLanguageParser`로 `CalendarViewModel`을 생성
- 위젯 딥링크 진입 시 초기 날짜/일정 ID를 전달받아 상세 화면까지 연결

**구현 참고**:
- ViewModel: `CalendarFeature/Calendar/CalendarViewModel.swift`
- View: `CalendarFeature/Calendar/CalendarView.swift`
- Action 패턴: ViewModel의 `send(_:)` 메서드
- ViewFactory: `CalendarFeature/CalendarViewFactory.swift`

## 파일 네이밍 규칙

| 타입 | 규칙 | 예시 |
|------|------|------|
| **View** | `{Name}View.swift` | `CalendarView.swift` |
| **ViewModel** | `{Name}ViewModel.swift` | `CalendarViewModel.swift` |
| **ViewFactory** | `{Feature}ViewFactory.swift` | `CalendarViewFactory.swift` |
| **Component** | `{Name}View.swift` | `CalendarCardView.swift` |

## 의존성

- **Core**: 공통 유틸리티
- **DesignSystem**: 공통 UI 컴포넌트
- **Domain**: 각 Feature가 필요한 Domain에 의존
  - CalendarFeature → CalendarDomain, UserDomain
- **Navigation**: Router, Destination
- **BaseFeature**: 모든 Feature가 BaseFeature에 의존

## Xcode 프로젝트 설정

**위치**: `Feature.xcodeproj`

**주요 설정**:
- 플랫폼: iOS 18+
- 프레임워크 타입: Dynamic Framework
- 의존성: Core.framework, DesignSystem.framework, CalendarDomain.framework, UserDomain.framework, Navigation.framework
- 타겟:
  - BaseFeature (Framework)
  - CalendarFeature (Framework)
  - FeatureTests (Unit Test)

## 사용 가이드

### MVVM 패턴

**ViewModel**: @Observable 매크로 사용

**참고**: `CalendarFeature/Calendar/CalendarViewModel.swift`

**주요 구성**:
- Properties: 의존성, 공개 상태, 비공개 상태
- Action: 캘린더 탐색 액션 + 자연어 파싱/저장 액션
- send(_:): Action 처리

**ViewModel 파일 구조 표준**:
- `SomeViewModel.swift`: 상태/비즈니스 로직/의존성 주입
- `SomeViewModel+Action.swift`: `Action` enum만 정의
- `SomeViewModel+Model.swift`: `ViewState`, `ViewMode` 등 보조 enum 정의
- View는 `init(viewModel: SomeViewModel)` 형태의 필수 주입만 허용
- Factory는 `makeView()`에서 ViewModel을 생성 후 View에 주입

**View**: SwiftUI View

**참고**: `CalendarFeature/Calendar/CalendarView.swift`

**주요 구성**:
- @State로 ViewModel 보유
- .send()로 Action 전달
- ViewModel의 공개 상태 구독
- 자연어 입력 필드 + 파싱 결과 편집 카드 + 저장 버튼 UI 포함
- 파싱 결과 편집 카드에서 기본 알림 옵션(없음/시작 시간/5·15·30·60분/1일 전) 추가·삭제 지원
- `initialScheduleID`가 전달된 경우 해당 일정 상세 화면을 자동 오픈

### ViewFactory

**참고**: `CalendarFeature/CalendarViewFactory.swift`

**역할**:
- 화면 생성 팩토리
- DI를 통한 의존성 주입

### Components

Feature 내부 서브뷰는 Components 디렉토리에 위치.

**참고**: `CalendarFeature/Calendar/Components/`

### 네비게이션

**참고**: ViewModel에서 `@Environment(Router.self)` 사용

**예시**:
```swift
@Environment(Router.self) private var router

router.navigate(to: .push(.detail))
```

### 새로운 Feature 추가

1. Feature.xcodeproj에 새 Framework 타겟 추가
2. {FeatureName}/ 디렉토리 생성
3. View, ViewModel, ViewFactory 작성
4. Coordinator에 ViewFactory 등록
5. Navigation/Destination에 화면 추가 (필요시)
