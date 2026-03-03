## 제목(Title)
- @MainActor ViewModel에서 deinit 격리 오류와 Task 강한 캡처 순환 참조가 발생한 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- mistake

## 키워드(Keywords)
- workflow:review
- workflow:test
- action:weak-capture
- failure:actor-isolation-error
- failure:retain-cycle
- target:file:SeukCalendar/Feature/CalendarFeature/Calendar/CalendarViewModel.swift
- risk:medium
- verify:calendarfeature-test

## 컨텍스트(Context)
- 캘린더 동기화 모니터링 Task를 ViewModel 내부에 추가하는 과정에서 `deinit`에서 MainActor 격리 프로퍼티를 직접 참조했고, 동시에 `self`를 강하게 캡처하는 무한 스트림 Task를 `self`가 보관하도록 구현했다.

## 문제 행동(Bad Action)
- `@MainActor` 클래스의 `deinit`에서 actor-isolated 프로퍼티를 직접 접근했다.
- `self -> Task -> self` 강한 참조 고리를 만들 수 있는 캡처 패턴을 사용했다.

## 사용자 피드백(User Feedback)
- 없음 (로컬 빌드/테스트에서 컴파일 오류와 구조적 결함을 직접 확인 후 수정)

## 원인(Root Cause)
- Swift 6 actor 격리 규칙(`deinit` nonisolated)과 장수명 비동기 Task 캡처 규칙을 구현 전에 체크리스트로 고정하지 않았다.

## 예방 규칙(Prevention Rule)
- `@MainActor` 타입의 `deinit`에서는 actor-isolated 상태 접근을 직접 수행하지 않는다.
- 장수명 Task를 프로퍼티로 저장할 때는 Task 클로저가 `self`를 강하게 유지하지 않도록 `weak self` + 외부 의존성 캡처 패턴을 사용한다.

## 사전 점검(Pre-Command Check)
- `deinit`에서 actor-isolated 프로퍼티를 직접 참조하고 있지 않은가?
- `self`가 보유하는 Task가 `self`를 다시 강하게 캡처하고 있지 않은가?
- 무한/장수명 AsyncStream 루프에서 `weak self` 해제 시 루프 종료 조건이 있는가?

## 금지 동작(Do Not Do)
- `deinit { pendingTask?.cancel() }`처럼 actor 격리 문맥 검증 없이 템플릿 코드를 복붙하지 않는다.
- `Task { [weak self] in guard let self else { return }; for await ... }` 형태로 초기에 강한 self를 고정하지 않는다.

## 안전 대안(Safe Alternative)
- `deinit` 정리 로직이 필요하면 actor-safe한 설계를 먼저 정하고(예: 명시적 stop 메서드), 즉시 컴파일 검증한다.
- `let repository = self.repository`처럼 필요한 의존성만 캡처하고, 루프 내부에서 `guard let self else { break }`로 안전하게 self를 사용한다.

## 검증 단계(Verification Step)
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarFeature -destination 'platform=iOS Simulator,id=D76E7868-D294-42A9-BA46-DD23BF6C8B9C' test`
- `git diff -- SeukCalendar/Feature/CalendarFeature/Calendar/CalendarViewModel.swift`

## 적용 범위(Scope)
- Feature/ViewModel 계층에서 Notification/Stream 관찰 Task를 추가하는 모든 작업

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `changeObservationTask = Task { [weak self] in guard let self else { return }; for await _ in stream { ... } }`
- 좋은 예(Good): `let streamProvider = dependency; changeObservationTask = Task { [weak self] in for await _ in streamProvider.stream() { guard let self else { break }; ... } }`

## 관련 메모리(Related Memories)
- `entries/2026-03-03-test-annotation-korean-and-compile-safety.md`
