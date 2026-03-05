# 메모리 인덱스(Memory Index)

## 사용 방법(How to Use)
- 새 메모리를 추가하면 아래 표에 한 줄을 추가합니다.
- 키워드는 쉼표로 구분합니다.

| 날짜(Date) | 파일(File) | 제목(Title) | 핵심 키워드(Keywords) |
|---|---|---|---|
| 2026-03-05 | `entries/2026-03-05-font-token-naming-from-pencil.md` | 폰트 토큰 작업에서 예시 네이밍(Heading1/Body1)을 유지해 펜슬 네이밍 기준을 놓친 사례 | workflow:issue-to-pr, workflow:design-token, action:font-token-rename, failure:example-font-naming, verify:line-height-ratio-rounding |
| 2026-03-05 | `entries/2026-03-05-design-token-source-priority.md` | 디자인 토큰 작업에서 기존 예시 컬러를 기준으로 해석해 사용자 의도(펜슬 우선)를 놓칠 뻔한 사례 | workflow:issue-to-pr, workflow:design-token, action:token-source-priority, failure:example-token-assumption, verify:pencil-variable-first |
| 2026-03-04 | `entries/2026-03-04-pencil-mcp-unsaved-design-file.md` | Pencil MCP 편집 후 Design.pen 파일 저장 반영을 확인하지 않아 Git 변경 누락 위험이 발생한 사례 | workflow:design, workflow:issue-to-pr, action:pencil-mcp-edit, failure:unsaved-design-file, verify:git-status-after-mcp |
| 2026-03-04 | `entries/2026-03-04-design-spec-user-intent-first.md` | Design-Spec 작업에서 현재 구현 기준으로 선수정해 사용자 의도 반영 순서를 어긴 사례 | workflow:docs, workflow:issue-to-pr, action:intent-first-edit, failure:premature-spec-rewrite, verify:requirement-check-before-edit |
| 2026-03-04 | `entries/2026-03-04-notification-permission-over-gating.md` | 알림 권한 부재를 캘린더 접근 실패로 과도하게 게이팅한 사례 | workflow:feature, failure:overstrict-permission-gate, action:permission-decoupling, verify:permission-flow |
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
