## 제목(Title)
- DIContainer 도입 전 단계에서 Factory를 과도하게 추상화한 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:feature
- workflow:factory
- action:simplify
- failure:premature-abstraction
- target:file:SeukCalendar/Feature/CalendarFeature/CalendarViewFactory.swift
- risk:low
- verify:factory-structure
- verify:build

## 컨텍스트(Context)
- CalendarFeature Factory를 `makeViewModel` 클로저 주입 구조로 확장했지만, 아직 DIContainer가 없는 단계였습니다.

## 문제 행동(Bad Action)
- 현재 단계 요구사항보다 앞서 Factory 확장 포인트를 도입해 코드 복잡도를 증가시켰습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `Factory에서 makeFactory까지 만들 필요없어. DIContainer 도입 전까지는 makeView에서 ViewModel 인스턴스를 생성해서 바로 넣어주면돼.`

## 원인(Root Cause)
- 미래 DI 도입을 과도하게 선반영하면서 현 시점 설계 단순성을 놓쳤습니다.

## 예방 규칙(Prevention Rule)
- DIContainer 도입 전에는 Factory를 단순 유지하고 `makeView()`에서 ViewModel을 직접 생성/주입합니다.
- 확장 포인트는 실제 도입 시점에 추가합니다.

## 사전 점검(Pre-Command Check)
- 현재 프로젝트에 DIContainer가 실제 존재하는가?
- Factory가 현재 요구 범위 대비 과한 생성 추상화를 포함하는가?
- `makeView()` 한 메서드로 충분한 구조인가?

## 금지 동작(Do Not Do)
- DIContainer 미도입 상태에서 `makeXxx` 클로저/빌더를 미리 추가하지 않습니다.

## 안전 대안(Safe Alternative)
- `CalendarViewFactory.makeCalendarView()` 안에서 `CalendarViewModel()`을 생성해 `CalendarView(viewModel:)`에 바로 전달합니다.

## 검증 단계(Verification Step)
- `sed -n '1,120p' SeukCalendar/Feature/CalendarFeature/CalendarViewFactory.swift`
- `rg -n \"makeViewModel|builder|factory\" SeukCalendar/Feature/CalendarFeature/CalendarViewFactory.swift`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarFeature -configuration Debug -destination 'generic/platform=iOS Simulator' build`

## 적용 범위(Scope)
- DIContainer 미도입 상태의 Feature ViewFactory 구현 전반

## 심각도(Severity)
- low

## 예시(Examples)
- 나쁜 예(Bad): Factory에 `makeViewModel` 주입 초기화자를 미리 추가
- 좋은 예(Good): `makeCalendarView()`에서 `CalendarViewModel()` 직접 생성

## 관련 메모리(Related Memories)
- `entries/2026-03-03-calendar-viewmodel-mandatory-injection.md`
