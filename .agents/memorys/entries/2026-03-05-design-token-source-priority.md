## 제목(Title)
- 디자인 토큰 작업에서 기존 예시 컬러를 기준으로 해석해 사용자 의도(펜슬 우선)를 놓칠 뻔한 사례

## 날짜(Date)
- 2026-03-05

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:issue-to-pr
- workflow:design-token
- action:token-source-priority
- failure:example-token-assumption
- target:file:SeukCalendar/DesignSystem/DesignSystem/ResourceSystem/ColorSystem/Color+DesignSystem.swift
- verify:pencil-variable-first

## 컨텍스트(Context)
- 이슈 #43(디자인 토큰 1차 추가) 구현 중 기존 컬러 에셋을 일부 유지한 상태로 작업을 진행했습니다.

## 문제 행동(Bad Action)
- 기존 컬러셋이 예시용인지 확정하기 전에 호환성 관점으로 일부 legacy 값을 계속 유지하려고 했습니다.

## 사용자 피드백(User Feedback)
- 사용자 교정: `기존에 있는 컬러들은 전부 예시용 컬러야. 무시해도돼.`

## 원인(Root Cause)
- 토큰 소스 우선순위를 초기에 고정하지 않고 "기존 코드 호환" 가정을 먼저 적용했습니다.

## 예방 규칙(Prevention Rule)
- 디자인 토큰 이슈는 시작 시점에 "정본(source of truth)"을 먼저 확정합니다.
- 사용자가 펜슬/피그마를 정본으로 지정하면 기존 코드/에셋 값은 모두 참고용으로 취급합니다.

## 사전 점검(Pre-Command Check)
- 이번 토큰 작업의 정본은 무엇인가?
- 기존 토큰은 실제 운영값인가, 예시값인가?
- 값 충돌 시 정본 기준으로 즉시 덮어쓸 수 있는가?

## 금지 동작(Do Not Do)
- 정본 확인 전 "기존 값 호환"을 우선 전략으로 두지 않습니다.

## 안전 대안(Safe Alternative)
- 이슈 시작 직후 정본/예시 구분을 한 줄로 재진술하고, 토큰 추출 표(이름/Light/Dark)를 먼저 만든 뒤 코드 반영합니다.

## 검증 단계(Verification Step)
- `jq '.variables' Pencil/Design.pen`
- 토큰 추출 표와 코드(`Color+DesignSystem.swift`, `Font+DesignSystem.swift`) 이름/값 대조
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme DesignSystem -destination 'generic/platform=iOS' build`

## 적용 범위(Scope)
- 디자인 토큰(컬러/폰트/스페이싱/라디우스) 반영 작업 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): 기존 컬러셋을 기본값으로 가정한 뒤 일부만 수정
- 좋은 예(Good): 정본(펜슬 변수) 먼저 확정 -> 전체 토큰 표 작성 -> 코드/에셋 일괄 반영

## 관련 메모리(Related Memories)
- `entries/2026-03-04-design-spec-user-intent-first.md`
- `entries/2026-03-04-pencil-mcp-unsaved-design-file.md`
