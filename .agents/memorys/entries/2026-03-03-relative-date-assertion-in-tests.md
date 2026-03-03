## 제목(Title)
- 자연어 파싱 테스트에서 절대 날짜 하드코딩 기대값을 사용한 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:test
- action:relative-date-assertion
- failure:hardcoded-date
- target:AI/AITests
- risk:time-dependent-failure
- verify:dynamic-reference-date

## 컨텍스트(Context)
- 일정 파싱 테스트에서 `2026-03-13` 같은 절대 날짜를 기대값으로 고정해 두어, 기준일/실행 시점이 바뀌면 테스트 의도가 흐려질 수 있었다.

## 문제 행동(Bad Action)
- 상대 날짜 의미("내일", "다음주")를 검증하면서 기대값은 절대 날짜 문자열로 박아 두었다.

## 사용자 피드백(User Feedback)
- "테스트 코드들을 보면 날짜가 하드코딩으로 박혀있는데 상대적 날짜를 적용해야 할 것 같다"

## 원인(Root Cause)
- 테스트 시나리오의 핵심(상대 날짜 해석)을 검증하면서도 기대값 계산을 고정값으로 둬서, 입력 의미와 검증 방식이 분리됐다.

## 예방 규칙(Prevention Rule)
- "내일/다음주" 같은 상대 날짜 테스트는 `referenceDate`를 기준으로 기대 날짜를 동적으로 계산한다.
- 시간 계산은 공통 유틸(`Date.after/before`, `TimeOffset`)을 우선 사용한다.

## 사전 점검(Pre-Command Check)
- 테스트 기대값에 `yyyy-MM-dd` 리터럴이 직접 들어가 있는가?
- 같은 로직을 `referenceDate` + 오프셋 계산으로 바꿀 수 있는가?

## 금지 동작(Do Not Do)
- 상대 날짜 시나리오에서 절대 날짜 문자열을 상수로 단정하지 않는다.

## 안전 대안(Safe Alternative)
- `referenceDate`를 테스트 시작 시점에 고정하고, helper 함수로 기대 날짜 문자열을 계산해 비교한다.

## 검증 단계(Verification Step)
- AI 스킴 테스트 전체 실행 후 상대 날짜 케이스가 모두 통과하는지 확인

## 적용 범위(Scope)
- AI 자연어 파싱 테스트 및 날짜 기대값 계산이 있는 테스트 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `#expect(parsed.dateString == "2026-03-13")`
- 좋은 예(Good): `#expect(parsed.dateString == nextWeekdayDateString(from: referenceDate, weekday: 6))`

## 관련 메모리(Related Memories)
- entries/2026-03-03-foundation-models-flaky-date-location.md
