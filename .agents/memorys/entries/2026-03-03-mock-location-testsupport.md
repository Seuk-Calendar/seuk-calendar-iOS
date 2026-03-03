## 제목(Title)
- MockRepository를 테스트 파일 내부에 두어 TestSupport 규칙을 놓친 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:review
- workflow:test
- action:move
- failure:convention-miss
- target:dir:SeukCalendar/Domain/CalendarDomainTestSupport
- target:file:SeukCalendar/Domain/CalendarDomainTests/CalendarDomainTests.swift
- risk:medium
- verify:diff-check
- verify:build

## 컨텍스트(Context)
- Domain 테스트 코드에서 `MockScheduleRepository`를 테스트 파일 내부에 private 타입으로 정의한 상태였습니다.

## 문제 행동(Bad Action)
- Mock 타입을 TestSupport 모듈로 분리하지 않고 테스트 파일 내부에 직접 선언했습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `MockScheduleRepository는 TestSupport에 위치해야해.`

## 원인(Root Cause)
- TestSupport 규칙 확인 없이 테스트 코드 구현 편의성 기준으로만 배치했습니다.

## 예방 규칙(Prevention Rule)
- 새 Mock 타입을 만들거나 수정할 때는 먼저 `{Domain}TestSupport` 배치를 기준으로 설계하고 테스트 타깃은 import/의존성만 추가합니다.

## 사전 점검(Pre-Command Check)
- 새로 추가되는 Mock 타입이 테스트 파일 내부에 선언되어 있지 않은가?
- Mock 파일 경로가 `*TestSupport/` 하위인가?
- 테스트 타깃이 해당 TestSupport 프레임워크를 import/링크하고 있는가?

## 금지 동작(Do Not Do)
- 테스트 파일 끝에 `private Mock...` 타입을 즉시 추가하지 않습니다.

## 안전 대안(Safe Alternative)
- `CalendarDomainTestSupport/MockScheduleRepository.swift`처럼 TestSupport 파일로 분리하고 테스트에서는 import로 사용합니다.

## 검증 단계(Verification Step)
- `rg -n "\\b(class|struct|actor|enum)\\s+Mock" SeukCalendar -g '*.swift'`
- `rg -n "import CalendarDomainTestSupport|MockScheduleRepository" SeukCalendar/Domain -g '*.swift'`
- `git diff --name-only`로 테스트 파일 내부 Mock 선언 잔존 여부 확인

## 적용 범위(Scope)
- Domain/Feature/Data 등 테스트 더블(Mock/Stubs/Fakes) 추가/수정 작업 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `CalendarDomainTests.swift` 내부에 `private final class MockScheduleRepository` 선언
- 좋은 예(Good): `CalendarDomainTestSupport/MockScheduleRepository.swift`에 public 타입으로 분리 후 테스트에서 import

## 관련 메모리(Related Memories)
- `entries/2026-03-03-branch-context-mismatch.md`
