# 메모리 인덱스(Memory Index)

## 사용 방법(How to Use)
- 새 메모리를 추가하면 아래 표에 한 줄을 추가합니다.
- 키워드는 쉼표로 구분합니다.

| 날짜(Date) | 파일(File) | 제목(Title) | 핵심 키워드(Keywords) |
|---|---|---|---|
| 2026-03-03 | `entries/2026-03-03-mainactor-task-capture-cycle.md` | @MainActor ViewModel에서 deinit 격리 오류와 Task 강한 캡처 순환 참조가 발생한 사례 | workflow:review, failure:actor-isolation-error, failure:retain-cycle, action:weak-capture |
| 2026-03-03 | `entries/2026-03-03-relative-date-assertion-in-tests.md` | 자연어 파싱 테스트에서 절대 날짜 하드코딩 기대값을 사용한 사례 | workflow:test, action:relative-date-assertion, failure:hardcoded-date, verify:dynamic-reference-date |
| 2026-03-03 | `entries/2026-03-03-foundation-models-flaky-date-location.md` | Foundation Models 출력 변동을 그대로 신뢰해 날짜/장소 테스트가 플레이키해진 사례 | workflow:test, action:normalize-fm-result, failure:flaky-output, verify:repeated-only-testing |
| 2026-03-03 | `entries/2026-03-03-core-safe-index-regex-capture.md` | 정규식 캡처 배열 인덱스를 직접 접근해 테스트 크래시가 발생한 사례 | workflow:test, action:safe-index, failure:index-out-of-range, verify:ai-test |
| 2026-03-03 | `entries/2026-03-03-skill-sync-claude-agents.md` | 스킬 추가 시 `.claude`와 `.agents` 동시 반영을 누락한 사례 | workflow:skill, failure:location-miss, verify:dual-path-check |
| 2026-03-03 | `entries/2026-03-03-branch-context-mismatch.md` | 브랜치 컨텍스트 혼선으로 범위 외 변경이 섞인 사례 | workflow:branch, failure:scope-creep, verify:diff-check |
| 2026-03-03 | `entries/2026-03-03-mock-location-testsupport.md` | MockRepository를 테스트 파일 내부에 두어 TestSupport 규칙을 놓친 사례 | workflow:review, failure:convention-miss, target:dir:SeukCalendar/Domain/CalendarDomainTestSupport |
| 2026-03-03 | `entries/2026-03-03-viewmodel-action-model-separation.md` | ViewModel 내 Action/보조 enum을 분리 파일 규칙으로 관리하지 않아 사용자 교정을 받은 사례 | workflow:feature, action:split-file, failure:convention-miss |
| 2026-03-03 | `entries/2026-03-03-calendar-viewmodel-mandatory-injection.md` | CalendarView에서 ViewModel 기본값/옵셔널 주입을 허용해 DI 구조가 흐려진 사례 | workflow:di, action:inject, failure:optional-injection |
| 2026-03-03 | `entries/2026-03-03-factory-inline-viewmodel-before-dicontainer.md` | DIContainer 도입 전 단계에서 Factory를 과도하게 추상화한 사례 | workflow:factory, action:simplify, failure:premature-abstraction |
| 2026-03-03 | `entries/2026-03-03-test-annotation-korean-and-compile-safety.md` | 테스트 코드 컴파일 안정성과 `@Test` 한글 설명 규칙을 누락해 사용자 교정을 받은 사례 | workflow:test, failure:compile-errors, action:test-annotation |
| 2026-03-03 | `entries/2026-03-03-reuse-testsupport-mock-before-inline.md` | 기존 TestSupport Mock 존재 여부를 확인하지 않고 Feature 테스트 파일에 중복 Mock를 선언한 사례 | workflow:test, failure:duplicate-mock, action:reuse |
