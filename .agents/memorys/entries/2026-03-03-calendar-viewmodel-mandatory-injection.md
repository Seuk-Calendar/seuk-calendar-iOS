## 제목(Title)
- CalendarView에서 ViewModel 기본값/옵셔널 주입을 허용해 DI 구조가 흐려진 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:feature
- workflow:di
- action:inject
- failure:optional-injection
- target:file:SeukCalendar/Feature/CalendarFeature/Calendar/CalendarView.swift
- target:file:SeukCalendar/Feature/CalendarFeature/CalendarViewFactory.swift
- target:file:SeukCalendar/SeukCalendar/ContentView.swift
- risk:medium
- verify:factory-injection
- verify:build

## 컨텍스트(Context)
- Calendar 화면 구현 중 `CalendarView` 초기화자가 `CalendarViewModel? = nil`을 받아 내부에서 기본 ViewModel을 생성하고 있었습니다.

## 문제 행동(Bad Action)
- View 계층에서 fallback ViewModel 생성을 허용해, DI 진입점이 View/Factory로 이중화되었습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `nil일 필요 없어. ViewModel을 항상 주입받는 구조, 그리고 팩토리에서 ViewModel을 주입해주는 구조로 변경`.

## 원인(Root Cause)
- 빠른 동작 구현을 우선하면서 생성 책임(View vs Factory) 분리를 엄격히 지키지 못했습니다.

## 예방 규칙(Prevention Rule)
- `SomeView`는 ViewModel을 필수 인자로만 받고, 기본 생성/선택적 주입은 금지합니다.
- ViewModel 생성 책임은 `SomeViewFactory`에서 단일하게 담당합니다.

## 사전 점검(Pre-Command Check)
- View 초기화자 시그니처에 `ViewModel? = nil` 또는 `ViewModel = ...` 기본값이 있는가?
- Factory가 실제로 ViewModel을 생성해 View에 전달하고 있는가?
- App/Coordinator 진입점이 View 직접 생성 대신 Factory를 사용하고 있는가?

## 금지 동작(Do Not Do)
- View 내부에서 `viewModel ?? SomeViewModel()` 형태로 fallback 인스턴스를 만들지 않습니다.

## 안전 대안(Safe Alternative)
- `init(viewModel: SomeViewModel)`로 강제 주입하고, `SomeViewFactory.makeView()`에서만 `SomeViewModel()`을 생성합니다.

## 검증 단계(Verification Step)
- `rg -n "ViewModel\\?\\s*=\\s*nil|\\?\\?\\s*[A-Za-z]+ViewModel\\(" SeukCalendar/Feature -g "*.swift"`
- `rg -n "make.*View\\(|ViewFactory" SeukCalendar/Feature SeukCalendar/SeukCalendar -g "*.swift"`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarFeature -configuration Debug -destination 'generic/platform=iOS Simulator' build`

## 적용 범위(Scope)
- Feature 레이어 View/ViewFactory 작성 및 리팩토링 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `public init(viewModel: CalendarViewModel? = nil) { _viewModel = State(initialValue: viewModel ?? CalendarViewModel()) }`
- 좋은 예(Good): `public init(viewModel: CalendarViewModel) { ... }` + `CalendarViewFactory.makeCalendarView()`에서 생성 주입

## 관련 메모리(Related Memories)
- `entries/2026-03-03-viewmodel-action-model-separation.md`
