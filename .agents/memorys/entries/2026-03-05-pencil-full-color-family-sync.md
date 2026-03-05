## 제목(Title)
- 펜슬 컬러 토큰 작업에서 캘린더 일부만 반영해 전체 디자인 시스템 컬러 계층 동기화를 놓칠 뻔한 사례

## 날짜(Date)
- 2026-03-05

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:issue-to-pr
- workflow:design-token
- action:pencil-color-family-sync
- failure:partial-color-registration
- target:file:Pencil/Design.pen
- verify:color-designsystem-full-coverage

## 컨텍스트(Context)
- 캘린더 칩 컬러를 변수화하는 작업을 진행하던 중, 사용자로부터 "칩만이 아니라 Primitives/Core 등 전체를 등록해야 한다"는 교정을 받았습니다.

## 문제 행동(Bad Action)
- 이슈의 예시(칩 색상)에 집중해 컬러 변수 등록 범위를 캘린더 일부로 축소 해석했습니다.

## 사용자 피드백(User Feedback)
- 사용자 교정: `캘린더 칩에 사용된 컬러만 등록하는게 아니라, Primitives, Core 등 모든 디자인시스템 컬러를 다 등록해야 하는거 알지? Color+DesignSystem.swift 파일에 등록되어 있는 것처럼 말이야.`

## 원인(Root Cause)
- 디자인 시스템 동기화 작업에서 "부분 수정"을 먼저 적용하고, 기준 파일(`Color+DesignSystem.swift`)의 전체 범위 대조를 선행하지 않았습니다.

## 예방 규칙(Prevention Rule)
- 펜슬 컬러 토큰 작업 시작 시 `Color+DesignSystem.swift`의 컬러 계층(Primitives/Core/Semantic/SemanticExtensions/Calendar)을 체크리스트로 먼저 고정합니다.
- 특정 컴포넌트 이슈(예: 칩 컬러)도 항상 전체 계층 누락 여부를 함께 검증합니다.

## 사전 점검(Pre-Command Check)
- 이번 변경이 특정 컴포넌트 수정인가, 디자인 시스템 전역 동기화인가?
- `Color+DesignSystem.swift`의 전체 컬러 계층 개수와 `Design.pen` 변수 개수를 대조했는가?
- 신규/변경 토큰이 어느 계층(Primitives/Core/Semantic/SemanticExtensions/Calendar)에 속하는지 분류했는가?

## 금지 동작(Do Not Do)
- 컴포넌트 예시 컬러만 반영하고 전체 컬러 계층 동기화를 생략하지 않습니다.

## 안전 대안(Safe Alternative)
- 코드 기준 토큰 목록을 먼저 추출하고, 그 목록을 기준으로 펜슬 변수 등록/검증을 일괄 수행합니다.

## 검증 단계(Verification Step)
- `rg -n 'public static let ' SeukCalendar/DesignSystem/DesignSystem/ResourceSystem/ColorSystem/Color+DesignSystem.swift`
- `jq -r '.variables | keys[]' Pencil/Design.pen | rg '^(Primitives|Core|Semantic|SemanticExtensions|Calendar)\.'`
- 토큰명/값 대조 스크립트로 누락·불일치 0건 확인

## 적용 범위(Scope)
- Pencil 기반 컬러 토큰 등록/동기화 작업 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `calendar-chip-*`만 등록하고 `Core/Semantic` 누락
- 좋은 예(Good): `Color+DesignSystem.swift` 전체 계층 추출 -> `Design.pen` 변수 1:1 등록 -> 자동 대조

## 관련 메모리(Related Memories)
- `entries/2026-03-05-design-token-source-priority.md`
- `entries/2026-03-05-font-token-naming-from-pencil.md`
