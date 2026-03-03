## 제목(Title)
- 정규식 캡처 배열 인덱스를 직접 접근해 테스트 크래시가 발생한 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:test
- workflow:review
- action:safe-index
- action:core-extension
- failure:index-out-of-range
- target:file:SeukCalendar/AI/AI/FoundationModels/FoundationModelsParser.swift
- risk:high
- verify:ai-test

## 컨텍스트(Context)
- `AITests` 실행 중 `FoundationModelsParser.resolveTime(from:)`에서 정규식 매칭 결과 배열을 고정 인덱스로 접근하여 `SIGTRAP` 크래시가 발생했습니다.

## 문제 행동(Bad Action)
- 정규식 캡처 그룹 배열에 대해 `match[1]`, `match[2]`처럼 직접 인덱싱했습니다.
- 프로젝트에 이미 존재하는 Core 안전 인덱스 확장(`Collection[safe:]`)을 활용하지 않았습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `컬렉션에 인덱스로 접근 시 안전하게 처리하는 익스텐션이 Core모듈에 있어. 인덱스 접근 시 이를 활용하고, 메모리에 기록해`

## 원인(Root Cause)
- 캡처 그룹의 optional 매칭 누락 가능성을 고려하지 않고 직접 접근 패턴을 사용했습니다.
- Core 공통 확장 재사용 체크를 사전 점검에 넣지 않았습니다.

## 예방 규칙(Prevention Rule)
- 정규식/파싱 결과 배열 인덱스 접근은 항상 `Collection[safe:]`를 우선 사용합니다.
- `Core`에 이미 존재하는 안전 유틸리티가 있으면 로컬 구현보다 공통 확장을 재사용합니다.
- 테스트에서 크래시 발생 시 `.xcresult`의 crash attachment까지 확인해 정확한 실패 라인(파일/라인)을 원인으로 기록합니다.

## 사전 점검(Pre-Command Check)
- 배열/컬렉션 인덱스 접근 코드에 `safe` 접근이 적용되어 있는가?
- 동일 기능의 Core 확장이 이미 존재하는지 먼저 확인했는가?
- 파싱 로직 변경 후 대상 모듈 테스트(`AI` 스킴)가 실제 시뮬레이터에서 통과했는가?

## 금지 동작(Do Not Do)
- 정규식 캡처 배열에 직접 인덱싱(`match[n]`)을 고정 사용하지 않습니다.
- 안전 확장을 무시하고 파일 내부에서 임시 우회 구현만 추가하지 않습니다.

## 안전 대안(Safe Alternative)
- 예: `let minute = Int(match[safe: 3] ?? "") ?? 0`
- 예: `guard let year = Int(match[safe: 1] ?? "") else { return nil }`

## 검증 단계(Verification Step)
- `rg -n "match\\[[0-9]+\\]" SeukCalendar/AI/AI/FoundationModels/FoundationModelsParser.swift`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme AI -destination 'platform=iOS Simulator,id=D76E7868-D294-42A9-BA46-DD23BF6C8B9C' test`
- 필요 시 `xcresulttool export attachments --only-failures`로 crash log 확인

## 적용 범위(Scope)
- AI/Feature/Domain 포함 파싱/정규식 처리 로직 전반

## 심각도(Severity)
- high

## 예시(Examples)
- 나쁜 예(Bad): `let minute = Int(match[3] ?? "") ?? 0`
- 좋은 예(Good): `let minute = Int(match[safe: 3] ?? "") ?? 0`

## 관련 메모리(Related Memories)
- `entries/2026-03-03-test-annotation-korean-and-compile-safety.md`
