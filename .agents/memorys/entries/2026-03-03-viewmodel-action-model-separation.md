## 제목(Title)
- ViewModel 내 Action/보조 enum을 분리 파일 규칙으로 관리하지 않아 사용자 교정을 받은 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:feature
- workflow:refactor
- action:split-file
- failure:convention-miss
- target:file:SeukCalendar/Feature/CalendarFeature/Calendar/CalendarViewModel.swift
- target:file:SeukCalendar/Feature/CalendarFeature/Calendar/CalendarViewModel+Action.swift
- target:file:SeukCalendar/Feature/CalendarFeature/Calendar/CalendarViewModel+Model.swift
- risk:medium
- verify:diff-check
- verify:module-doc

## 컨텍스트(Context)
- CalendarFeature 구현 중 `CalendarViewModel` 파일 하나에 `Action`, `ViewMode`, `PermissionState`를 함께 선언했습니다.

## 문제 행동(Bad Action)
- 프로젝트 팀 규칙(`SomeViewModel+Action.swift`, `SomeViewModel+Model.swift`) 확인 없이 ViewModel 내부에 enum을 직접 작성했습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `ViewModel의 Action은 SomeViewModel+Action.swift`, `추가 enum은 SomeViewModel+Model.swift`.

## 원인(Root Cause)
- ViewModel 파일 분리 컨벤션을 구현 전 체크리스트에 포함하지 않았습니다.

## 예방 규칙(Prevention Rule)
- ViewModel 신규/수정 시 먼저 `+Action`, `+Model` 파일 존재를 확인하고, enum 선언은 해당 파일에 우선 배치합니다.

## 사전 점검(Pre-Command Check)
- ViewModel에 `enum Action`이 직접 선언되어 있지 않은가?
- ViewModel 관련 enum이 `*ViewModel+Model.swift`에 위치하는가?
- `Feature/Module.md` 파일 구조 설명이 실제 코드와 일치하는가?

## 금지 동작(Do Not Do)
- 빠른 구현을 이유로 `*ViewModel.swift` 내부에 Action/보조 enum을 임시 선언한 채 유지하지 않습니다.

## 안전 대안(Safe Alternative)
- `CalendarViewModel.swift`는 상태/로직만 유지하고, enum은 `CalendarViewModel+Action.swift`, `CalendarViewModel+Model.swift`로 분리합니다.

## 검증 단계(Verification Step)
- `rg -n "enum Action|enum ViewMode|enum PermissionState" SeukCalendar/Feature/CalendarFeature -g "*.swift"`
- `git diff --name-only`
- `sed -n '1,120p' SeukCalendar/Feature/Module.md`

## 적용 범위(Scope)
- Feature 레이어의 모든 `*ViewModel` 파일 구조 작업

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `CalendarViewModel.swift` 내부에 `enum Action`, `enum ViewMode` 직접 선언
- 좋은 예(Good): `CalendarViewModel+Action.swift`, `CalendarViewModel+Model.swift`로 선언 분리

## 관련 메모리(Related Memories)
- `entries/2026-03-03-branch-context-mismatch.md`
