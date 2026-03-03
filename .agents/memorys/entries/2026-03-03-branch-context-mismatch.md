## 제목(Title)
- 브랜치 컨텍스트 혼선으로 범위 외 변경이 섞인 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- mistake

## 키워드(Keywords)
- workflow:branch
- workflow:rebase
- action:restore
- failure:scope-creep
- target:file:SeukCalendar/Feature/BaseFeature/View/ToolBar/ToolBar.swift
- target:file:SeukCalendar/Feature/BaseFeature/View/Tab/ScrollableTabView.swift
- risk:medium
- verify:diff-check

## 컨텍스트(Context)
- 이슈 #1 작업 중 브랜치 전환/리베이스 과정에서 의도하지 않은 다른 작업 브랜치 컨텍스트가 섞였습니다.

## 문제 행동(Bad Action)
- 작업 범위 확인 없이 변경 파일을 기준으로 바로 커밋/푸시를 진행했습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `feat/#1-implement-eventkit-crud 로 옮겨서 진행`, `2번 브랜치는 무시`.

## 원인(Root Cause)
- 현재 브랜치/작업 범위 점검 절차가 누락되었습니다.

## 예방 규칙(Prevention Rule)
- 커밋 전 반드시 `git diff --name-only origin/develop...HEAD`로 범위를 검증합니다.

## 사전 점검(Pre-Command Check)
- 현재 브랜치가 요청 브랜치와 일치하는가?
- 포함 파일이 이슈 범위를 벗어나지 않는가?
- 리뷰 지적 대응 커밋이 의도치 않은 파일을 되살리지 않는가?

## 금지 동작(Do Not Do)
- 브랜치 혼선 상태에서 전체 `git add -A`를 먼저 실행하지 않습니다.

## 안전 대안(Safe Alternative)
- 먼저 브랜치 확인 후 파일 단위 `git add <path>`로 스테이징합니다.

## 검증 단계(Verification Step)
- `git status --short --branch`
- `git diff --name-only origin/develop...HEAD`

## 적용 범위(Scope)
- 브랜치 전환/리베이스 후 후속 커밋 전 공통 적용

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): 브랜치 확인 없이 변경사항 전체 커밋
- 좋은 예(Good): 브랜치 확인 -> 범위 검증 -> 파일 단위 스테이징

## 관련 메모리(Related Memories)
- 없음
