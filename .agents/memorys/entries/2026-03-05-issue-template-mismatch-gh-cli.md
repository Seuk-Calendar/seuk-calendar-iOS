## 제목(Title)
- `gh issue create --body-file` 사용 시 Issue Form 템플릿 구조를 반영하지 않아 이슈 본문 형식이 어긋난 사례

## 날짜(Date)
- 2026-03-05

## 유형(Type)
- mistake

## 키워드(Keywords)
- workflow:issue-to-pr
- action:gh-issue-create
- failure:template-mismatch
- target:file:.github/ISSUE_TEMPLATE/todo.yml
- risk:medium
- verify:issue-template-sections

## 컨텍스트(Context)
- `create-rule`, `design-guide`, `issue-to-pr-workflow` 작업을 각각 이슈로 생성하는 과정에서 CLI로 본문을 직접 작성했습니다.

## 문제 행동(Bad Action)
- `.github/ISSUE_TEMPLATE/todo.yml`의 필드 라벨(요약/배경/솔루션 제안/작업 완료 기준/원본 제안) 구조를 확인하지 않고 임의 섹션(`작업 내용`, `상세 설명`, `체크리스트`, `참고사항`)으로 등록했습니다.

## 사용자 피드백(User Feedback)
- 사용자가 "각 이슈들이 이슈 템플릿을 따르지 않은 것 같다"고 지적했고, 원인 파악/메모리 기록/템플릿 기준 수정을 요청했습니다.

## 원인(Root Cause)
- 이슈 생성 단계에서 템플릿 준수 검증을 생략했습니다.
- `gh issue create --body-file` 사용 시 템플릿이 자동 적용된다고 가정했습니다.

## 예방 규칙(Prevention Rule)
- 이슈 생성 전 반드시 `.github/ISSUE_TEMPLATE/*.yml`을 확인하고, 본문을 템플릿 라벨과 동일한 섹션명으로 작성합니다.
- 이슈 생성 후 `gh issue view <번호> --json body`로 섹션 라벨 정합성을 즉시 검증합니다.

## 사전 점검(Pre-Command Check)
- 대상 저장소가 Issue Form(`.yml`)을 사용하는가?
- 생성할 이슈 본문에 템플릿 라벨 5개가 모두 포함되는가?
- 템플릿 지정 라벨이 누락되지 않았는가?

## 금지 동작(Do Not Do)
- 템플릿 구조 확인 없이 임의 마크다운 섹션으로 이슈를 생성하지 않습니다.

## 안전 대안(Safe Alternative)
- `todo.yml` 라벨 순서를 그대로 사용해 본문을 구성하고, 생성 직후 템플릿 섹션/라벨 일치 여부를 재검증합니다.

## 검증 단계(Verification Step)
- `sed -n '1,260p' .github/ISSUE_TEMPLATE/todo.yml`
- `gh issue view <번호> --json body,labels`
- `gh issue edit <번호> --body-file <template-structured-body-file>`

## 적용 범위(Scope)
- GitHub 이슈를 CLI로 생성/수정하는 모든 작업

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): `## 작업 내용 / ## 상세 설명 / ## 체크리스트` 형태로 임의 섹션 작성
- 좋은 예(Good): `### 요약(Summary) / ### 배경(Background) / ### 솔루션 제안(Proposed Solution) / ### 작업 완료 기준(Acceptance Criteria) / ### 원본 제안(Original Suggestion)` 순서 준수

## 관련 메모리(Related Memories)
- `entries/2026-03-03-skill-sync-claude-agents.md`
