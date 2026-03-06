## 제목(Title)
- 사용자가 스킬 경로나 이름을 직접 제공한 경우 즉시 해당 스킬을 우선 확인해야 하는 사례

## 날짜(Date)
- 2026-03-06

## 유형(Type)
- mistake

## 키워드(Keywords)
- workflow:skill
- workflow:issue-to-pr
- action:read-explicit-skill-path
- failure:ignored-user-provided-skill
- target:file:.agents/skills/create-rule/SKILL.md
- risk:medium
- verify:explicit-skill-open-first

## 컨텍스트(Context)
- 사용자가 `create Rule`을 요청했고, 이후 `/.agents/skills/create-rule` 경로를 직접 언급하며 해당 스킬을 확인했는지 물었습니다.

## 문제 행동(Bad Action)
- `Available skills` 목록에 보이지 않는다는 이유로 사용자가 직접 제공한 스킬 경로를 즉시 확인하지 않았습니다.

## 사용자 피드백(User Feedback)
- 사용자가 "이 스킬을 확인한거야?"라고 물으며, 지정한 스킬 파일을 실제로 읽었는지 확인을 요청했습니다.

## 원인(Root Cause)
- 자동 매칭 가능한 스킬 목록을 우선시하면서, 사용자가 명시적으로 지정한 파일 경로/스킬명을 별도 우선순위로 처리하지 않았습니다.

## 예방 규칙(Prevention Rule)
- 사용자가 스킬 이름이나 스킬 파일 경로를 직접 제공하면 `Available skills` 목록과 무관하게 해당 `SKILL.md`를 먼저 열어 확인합니다.
- 자동 매칭 목록에 없더라도 사용자가 지정한 경로가 유효하면 그 스킬 절차를 현재 턴에 적용합니다.

## 사전 점검(Pre-Command Check)
- 사용자가 스킬 이름 또는 스킬 파일 경로를 직접 제공했는가?
- 제공된 경로에 `SKILL.md`가 실제로 존재하는가?
- 자동 매칭 목록에 없더라도 사용자 지시 우선으로 읽었는가?

## 금지 동작(Do Not Do)
- 사용자가 직접 지정한 스킬을 확인하지 않은 상태에서 스킬 기준을 반영했다고 가정하지 않습니다.

## 안전 대안(Safe Alternative)
- 먼저 지정된 스킬 파일을 열고, 적용 가능한 단계만 요약한 뒤 작업을 이어갑니다.

## 검증 단계(Verification Step)
- `ls -la <사용자가 제공한 스킬 디렉토리>`
- `sed -n '1,260p' <사용자가 제공한 스킬 경로>/SKILL.md`

## 적용 범위(Scope)
- 사용자가 스킬 이름, 슬래시 커맨드, 절대 경로를 직접 지정하는 모든 작업

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): 목록에 없다는 이유로 사용자 제공 스킬 경로를 읽지 않고 일반 흐름으로 응답
- 좋은 예(Good): 사용자 제공 스킬 경로 확인 -> `SKILL.md` 읽기 -> 해당 스킬 절차를 현재 작업에 반영

## 관련 메모리(Related Memories)
- `entries/2026-03-03-skill-sync-claude-agents.md`
