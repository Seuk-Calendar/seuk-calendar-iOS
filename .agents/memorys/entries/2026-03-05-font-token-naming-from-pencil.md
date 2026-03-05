## 제목(Title)
- 폰트 토큰 작업에서 예시 네이밍(Heading1/Body1)을 유지해 펜슬 네이밍 기준을 놓친 사례

## 날짜(Date)
- 2026-03-05

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:issue-to-pr
- workflow:design-token
- action:font-token-rename
- failure:example-font-naming
- target:file:SeukCalendar/DesignSystem/DesignSystem/ResourceSystem/FontSystem/Font+DesignSystem.swift
- verify:line-height-ratio-rounding

## 컨텍스트(Context)
- 이슈 #43에서 폰트 토큰을 추가할 때 기존 예시 네이밍(`Heading1`, `Heading2`)을 먼저 반영했습니다.

## 문제 행동(Bad Action)
- 펜슬에 정의된 실제 타이포 네이밍(`Display/Heading/Label/Paragraph`)보다 기존 예시 네이밍을 우선 사용했습니다.

## 사용자 피드백(User Feedback)
- 사용자 교정: `기존에 Heading1, Heading2 와 같이 네이밍을 사용했던건 예시였어. 펜슬에 있는 네이밍으로 바꾸고, lineHeightRatio가 소숫점이라면 소숫점 2자리까지만 사용해.`

## 원인(Root Cause)
- 타이포 토큰 명세를 코드 구현 전에 정규화하지 않고, 기존 코드 구조를 그대로 재사용했습니다.

## 예방 규칙(Prevention Rule)
- 폰트 토큰 구현 전 `Design.pen`에서 `Typography / Category / Size` 목록을 먼저 추출하고 그대로 코드 네이밍에 반영합니다.
- `lineHeightRatio`는 소수점이 필요한 경우 최대 2자리로 제한합니다.

## 사전 점검(Pre-Command Check)
- 현재 네이밍이 펜슬 토큰명과 1:1로 대응되는가?
- 예시 네이밍(heading1/body1 등)이 남아 있지 않은가?
- `lineHeightRatio` 값이 소수점 2자리 이내인가?

## 금지 동작(Do Not Do)
- 예시 네이밍을 실제 디자인 토큰 네이밍으로 간주하지 않습니다.

## 안전 대안(Safe Alternative)
- `jq`로 토큰 목록을 먼저 추출한 뒤, 추출 결과를 enum/category 이름으로 직접 사용합니다.

## 검증 단계(Verification Step)
- `jq`로 `Signed by Base (Typography / ... )` 토큰 목록 추출
- `rg "Heading[1-9]|Body[1-9]|Caption[1-9]"`로 예시 네이밍 잔존 여부 확인
- `rg "1\.[0-9]{3,}" Font+DesignSystem.swift`로 `lineHeightRatio` 소수점 자리수 확인
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme SeukCalendar -destination 'generic/platform=iOS' build`

## 적용 범위(Scope)
- DesignSystem 폰트 토큰 정의/리네이밍 작업 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `Heading1`, `Body2` 중심으로 토큰 네이밍 구성
- 좋은 예(Good): `Display`, `Heading`, `Label`, `Paragraph` + size tier로 구성

## 관련 메모리(Related Memories)
- `entries/2026-03-05-design-token-source-priority.md`
