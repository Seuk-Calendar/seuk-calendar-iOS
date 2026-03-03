## 제목(Title)
- 기존 TestSupport Mock 존재 여부를 확인하지 않고 Feature 테스트 파일에 중복 Mock를 선언한 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:test
- workflow:review
- action:reuse
- action:mock-location
- failure:duplicate-mock
- failure:convention-miss
- target:dir:SeukCalendar/Domain/CalendarDomainTestSupport
- target:file:SeukCalendar/Feature/CalendarFeatureTests/CalendarFeatureTests.swift
- risk:high
- verify:testsupport-search
- verify:target-link

## 컨텍스트(Context)
- `CalendarFeatureTests` 수정 중 테스트 파일 내부에 `MockScheduleRepository`를 다시 선언했습니다.
- 이후 사용자 피드백으로 `MockScheduleRepository`가 이미 Domain TestSupport에 있고, Mock은 TestSupport에 둬야 한다는 점을 재확인했습니다.

## 문제 행동(Bad Action)
- 테스트 더블 추가 전에 `CalendarDomainTestSupport` 내 기존 Mock 존재 여부를 확인하지 않았습니다.
- 결과적으로 동일 책임의 Mock가 Feature 테스트 파일과 Domain TestSupport에 중복되었습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `MockScheduleRepository는 이미 Domain 쪽에 있지 않아? 그리고 Mock은 TestSupport에 둬야해.`

## 원인(Root Cause)
- 테스트 작성 시 “새 Mock 작성”을 기본 경로로 선택했고, “기존 TestSupport 재사용” 검증 단계를 생략했습니다.
- TestSupport 모듈 import/link 확인을 코드 작성 후순위로 밀어 구조 규칙 위반을 사전에 차단하지 못했습니다.

## 예방 규칙(Prevention Rule)
- Mock/Stubs/Fakes가 필요하면 반드시 아래 순서로 진행합니다.
  1) `*TestSupport`에서 기존 타입 검색
  2) 기존 타입 확장 가능성 검토
  3) 부족할 때만 TestSupport에 타입 추가
- 테스트 파일 내부 Mock 선언은 예외 상황(명시 승인) 없이는 금지합니다.
- 테스트 타깃에서 TestSupport를 사용할 때 `import`와 프레임워크 링크를 함께 검증합니다.

## 사전 점검(Pre-Command Check)
- `rg -n "MockScheduleRepository|\\bclass\\s+Mock|\\bstruct\\s+Mock" SeukCalendar/Domain/*TestSupport -g '*.swift'` 검색을 수행했는가?
- 테스트 파일 내부에 새로운 Mock 타입 선언이 생기지 않는가?
- 테스트 타깃 Frameworks에 해당 TestSupport 프레임워크가 링크되어 있는가?

## 금지 동작(Do Not Do)
- 기존 TestSupport 검색 없이 테스트 파일 끝에 `Mock...` 타입을 바로 추가하지 않습니다.
- “일단 테스트부터 통과” 목적으로 Mock 위치 규칙을 임시로 무시하지 않습니다.

## 안전 대안(Safe Alternative)
- `CalendarDomainTestSupport/MockScheduleRepository.swift`를 확장해 Feature/Domain 테스트가 공통으로 사용하도록 유지합니다.
- Feature 테스트에서는 `import CalendarDomainTestSupport` 후 기존 Mock를 주입합니다.

## 검증 단계(Verification Step)
- `rg -n "\\b(class|struct|actor|enum)\\s+Mock" SeukCalendar/Feature -g '*Tests.swift'`
- `rg -n "import CalendarDomainTestSupport|MockScheduleRepository" SeukCalendar/Feature -g '*.swift'`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarDomainTestSupport -destination 'generic/platform=iOS Simulator' build`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarFeature -destination 'generic/platform=iOS Simulator' build`

## 적용 범위(Scope)
- Feature/Domain/Data 전 영역의 테스트 더블(Mock/Stubs/Fakes) 추가 및 리팩터링 작업

## 심각도(Severity)
- high

## 예시(Examples)
- 나쁜 예(Bad): `CalendarFeatureTests.swift` 내부에 `final class MockScheduleRepository` 직접 선언
- 좋은 예(Good): `CalendarDomainTestSupport.MockScheduleRepository`를 import해 재사용하고, 필요한 속성만 TestSupport에서 확장

## 관련 메모리(Related Memories)
- `entries/2026-03-03-mock-location-testsupport.md`
- `entries/2026-03-03-test-annotation-korean-and-compile-safety.md`
