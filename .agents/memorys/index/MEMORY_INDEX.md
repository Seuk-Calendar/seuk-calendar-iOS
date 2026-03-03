# 메모리 인덱스(Memory Index)

## 사용 방법(How to Use)
- 새 메모리를 추가하면 아래 표에 한 줄을 추가합니다.
- 키워드는 쉼표로 구분합니다.

| 날짜(Date) | 파일(File) | 제목(Title) | 핵심 키워드(Keywords) |
|---|---|---|---|
| 2026-03-03 | `entries/2026-03-03-branch-context-mismatch.md` | 브랜치 컨텍스트 혼선으로 범위 외 변경이 섞인 사례 | workflow:branch, failure:scope-creep, verify:diff-check |
| 2026-03-03 | `entries/2026-03-03-mock-location-testsupport.md` | MockRepository를 테스트 파일 내부에 두어 TestSupport 규칙을 놓친 사례 | workflow:review, failure:convention-miss, target:dir:SeukCalendar/Domain/CalendarDomainTestSupport |
| 2026-03-03 | `entries/2026-03-03-viewmodel-action-model-separation.md` | ViewModel 내 Action/보조 enum을 분리 파일 규칙으로 관리하지 않아 사용자 교정을 받은 사례 | workflow:feature, action:split-file, failure:convention-miss |
| 2026-03-03 | `entries/2026-03-03-calendar-viewmodel-mandatory-injection.md` | CalendarView에서 ViewModel 기본값/옵셔널 주입을 허용해 DI 구조가 흐려진 사례 | workflow:di, action:inject, failure:optional-injection |
| 2026-03-03 | `entries/2026-03-03-factory-inline-viewmodel-before-dicontainer.md` | DIContainer 도입 전 단계에서 Factory를 과도하게 추상화한 사례 | workflow:factory, action:simplify, failure:premature-abstraction |
