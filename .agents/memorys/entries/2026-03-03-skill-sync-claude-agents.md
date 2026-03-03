## 제목(Title)
- 스킬 추가 시 `.claude`와 `.agents` 동시 반영을 누락한 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:skill
- action:sync
- failure:location-miss
- target:dir:.claude/skills
- target:dir:.agents/skills
- risk:medium
- verify:dual-path-check

## 컨텍스트(Context)
- 통합 워크플로우 스킬을 추가하면서 `.claude/skills`에만 생성하고, `.agents/skills` 동기화를 누락했습니다.

## 문제 행동(Bad Action)
- 스킬 반영 경로를 단일 디렉터리로 가정해 작업 완료로 판단했습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `.claude`뿐 아니라 Codex 사용을 위해 `.agents`에도 추가해야 한다고 명시했습니다.

## 원인(Root Cause)
- 스킬 생성 후 적용 대상 경로 체크리스트가 없었습니다.

## 예방 규칙(Prevention Rule)
- 스킬 신규/수정 작업 시 항상 아래 두 경로를 함께 점검합니다.
  1) `.claude/skills/<skill>/SKILL.md`
  2) `.agents/skills/<skill>/SKILL.md`

## 사전 점검(Pre-Command Check)
- 이번 요청이 스킬 생성/수정인가?
- `.claude/skills`와 `.agents/skills`에 동일 스킬이 존재하는가?
- 두 파일의 핵심 워크플로우 단계가 일치하는가?

## 금지 동작(Do Not Do)
- 한쪽 경로만 수정한 뒤 완료로 보고하지 않습니다.

## 안전 대안(Safe Alternative)
- 한 번 수정하면 즉시 반대 경로로 복제/동기화하고, `diff`로 최종 동일성을 검증합니다.

## 검증 단계(Verification Step)
- `ls -la .claude/skills/<skill> .agents/skills/<skill>`
- `diff -u .claude/skills/<skill>/SKILL.md .agents/skills/<skill>/SKILL.md`

## 적용 범위(Scope)
- 프로젝트 내 모든 스킬 신규 생성/수정 작업

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `.claude/skills/issue-to-pr-workflow/SKILL.md`만 생성
- 좋은 예(Good): 두 경로 모두 생성 후 내용 동일성 검증까지 수행

## 관련 메모리(Related Memories)
- 없음
