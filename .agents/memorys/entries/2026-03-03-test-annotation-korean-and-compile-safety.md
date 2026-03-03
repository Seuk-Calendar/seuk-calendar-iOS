## 제목(Title)
- 테스트 코드 컴파일 안정성과 `@Test` 한글 설명 규칙을 누락해 사용자 교정을 받은 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:test
- workflow:review
- action:test-annotation
- action:compile-check
- failure:compile-errors
- failure:convention-miss
- target:file:SeukCalendar/Feature/CalendarFeatureTests/CalendarFeatureTests.swift
- risk:high
- verify:test-build
- verify:test-name-format

## 컨텍스트(Context)
- CalendarFeature 테스트 코드를 수정하는 과정에서 컴파일 에러가 다수 남아 있었고, `@Test` 설명 문자열 규칙을 반영하지 못했습니다.

## 문제 행동(Bad Action)
- 테스트 코드 변경 후 컴파일 검증을 충분히 수행하지 않았습니다.
- `@Test`를 함수명 중심으로 작성하고, 한글 설명 문자열을 명시하지 않았습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `테스트 코드에 컴파일 에러가 많고, @Test("테스트 내용_ 한글로_작성합니다") 이런식으로 설명을 작성해야해.`

## 원인(Root Cause)
- 테스트 코드 컨벤션(`@Test` 설명 형식)과 테스트 빌드 검증 단계를 사전 체크리스트에 고정하지 않았습니다.

## 예방 규칙(Prevention Rule)
- 모든 테스트는 `@Test("테스트_내용을_한글로_작성합니다")` 형태의 설명 문자열을 기본으로 사용합니다.
- 테스트 코드 변경 시 PR 전 `build-for-testing` 또는 `test` 기준으로 컴파일 오류 0건을 확인합니다.
- 테스트 이름 규칙과 빌드 결과를 확인하기 전에는 테스트 관련 커밋/푸시를 진행하지 않습니다.

## 사전 점검(Pre-Command Check)
- `@Test` 애노테이션에 한글 설명 문자열이 포함되어 있는가?
- 변경한 테스트 파일이 속한 스킴에서 테스트 빌드가 성공하는가?
- 테스트 코드 변경분에 컴파일 에러/경고가 남아 있지 않은가?

## 금지 동작(Do Not Do)
- `@Test`에 설명 문자열 없이 함수명만으로 테스트 의도를 전달하지 않습니다.
- 테스트 코드 변경 후 컴파일 검증 없이 PR 리뷰 단계로 넘기지 않습니다.

## 안전 대안(Safe Alternative)
- 예: `@Test("onAppear_권한_허용시_일정을_로드합니다")`
- 예: `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarFeature -destination 'generic/platform=iOS Simulator' build-for-testing`

## 검증 단계(Verification Step)
- `rg -n '@Test\\("' SeukCalendar/Feature -g '*Tests.swift'`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarFeature -destination 'generic/platform=iOS Simulator' build-for-testing`
- `swiftlint lint SeukCalendar/Feature/CalendarFeatureTests/CalendarFeatureTests.swift`

## 적용 범위(Scope)
- Feature/Domain/Data 포함 전체 `*Tests.swift` 파일 작성 및 수정 작업

## 심각도(Severity)
- high

## 예시(Examples)
- 나쁜 예(Bad): `@Test func onAppear_loadsVisibleEvents_whenPermissionGranted() async { ... }`
- 좋은 예(Good): `@Test("onAppear_권한_허용시_일정을_로드합니다") func onAppear_loadsVisibleEvents_whenPermissionGranted() async { ... }`

## 관련 메모리(Related Memories)
- `entries/2026-03-03-mock-location-testsupport.md`
