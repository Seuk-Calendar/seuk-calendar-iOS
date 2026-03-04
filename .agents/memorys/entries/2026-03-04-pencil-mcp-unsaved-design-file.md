## 제목(Title)
- Pencil MCP 편집 후 Design.pen 파일 저장 반영을 확인하지 않아 Git 변경 누락 위험이 발생한 사례

## 날짜(Date)
- 2026-03-04

## 유형(Type)
- mistake

## 키워드(Keywords)
- workflow:design
- workflow:issue-to-pr
- action:pencil-mcp-edit
- failure:unsaved-design-file
- target:file:Pencil/Design.pen
- verify:git-status-after-mcp

## 컨텍스트(Context)
- 이슈 #27 리디자인 작업에서 Pencil MCP로 캔버스 편집을 진행했습니다.

## 문제 행동(Bad Action)
- MCP 편집 성공 응답만 신뢰하고 `Pencil/Design.pen`의 실제 파일 변경 여부를 즉시 확인하지 않았습니다.

## 사용자 피드백(User Feedback)
- 직접적인 교정 요청은 없었지만, 이슈-PR 워크플로우에서 Git 추적 가능한 결과가 필수입니다.

## 원인(Root Cause)
- MCP 에디터 상태와 로컬 파일 시스템 반영 시점을 동일하다고 가정했습니다.

## 예방 규칙(Prevention Rule)
- Pencil MCP 작업 직후 반드시 `git status --short`와 파일 해시(`git hash-object`)로 디스크 반영 여부를 검증합니다.

## 사전 점검(Pre-Command Check)
- MCP 편집 후 파일이 실제로 수정되었는가?
- `git status --short`에 대상 `.pen` 파일이 표시되는가?
- 표시되지 않으면 저장/동기화 경로를 먼저 해결했는가?

## 금지 동작(Do Not Do)
- MCP 응답 성공만으로 커밋 단계로 바로 넘어가지 않습니다.

## 안전 대안(Safe Alternative)
- 파일 반영이 누락되면 `.pen` JSON을 직접 수정하거나 저장 동기화 후 다시 검증합니다.

## 검증 단계(Verification Step)
- `git status --short`
- `git diff --stat -- Pencil/Design.pen`
- `git hash-object Pencil/Design.pen` vs `git rev-parse HEAD:Pencil/Design.pen`

## 적용 범위(Scope)
- Pencil MCP 기반 디자인 작업 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): MCP 편집 성공 확인 후 바로 PR 생성
- 좋은 예(Good): MCP 편집 -> Git 변경 확인 -> 미반영 시 저장/파일 수정 -> 재검증 후 커밋

## 관련 메모리(Related Memories)
- entries/2026-03-03-branch-context-mismatch.md
