## 제목(Title)
- Design-Spec 작업에서 현재 구현 기준으로 선수정해 사용자 의도 반영 순서를 어긴 사례

## 날짜(Date)
- 2026-03-04

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:docs
- workflow:issue-to-pr
- action:intent-first-edit
- failure:premature-spec-rewrite
- target:file:Design-Spec.md
- risk:medium
- verify:requirement-check-before-edit

## 컨텍스트(Context)
- 이슈 #40 문서 정합성 작업 중, 사용자의 상세 수정 포인트를 받기 전에 현재 구현 기준으로 `Design-Spec.md`를 크게 재작성했습니다.

## 문제 행동(Bad Action)
- 사용자 요구를 충분히 수집하기 전에 문서 전체를 선제적으로 수정했습니다.
- 이후 사용자가 “내가 수정해야할 부분을 알려줄거야”라고 명확히 교정했습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `현재 구현으로 문서를 바로 수정하는게 아니야. 내가 수정해야할 부분을 알려줄거야.`

## 원인(Root Cause)
- issue-to-pr 흐름을 빠르게 진행하려는 과정에서 문서 작업의 입력 순서(요구사항 확정 → 편집)를 생략했습니다.

## 예방 규칙(Prevention Rule)
- 문서 정합성/기획 문서 작업에서는 사용자의 수정 항목이 명시되기 전까지 대규모 편집을 시작하지 않습니다.
- 먼저 “반영할 항목 목록”을 사용자 발화에서 고정한 뒤, 해당 범위만 패치합니다.

## 사전 점검(Pre-Command Check)
- 사용자가 수정 포인트를 모두 제시했는가?
- 지금 편집이 사용자 요구 목록에 직접 매핑되는가?
- 범위 밖 대규모 재작성 요소가 섞여 있지 않은가?

## 금지 동작(Do Not Do)
- 사용자 요구 확정 전, 전체 문서를 현재 구현 기준으로 통째로 재작성하지 않습니다.

## 안전 대안(Safe Alternative)
- 요구사항을 번호 목록으로 먼저 재진술하고, 해당 번호별 섹션만 최소 변경으로 수정합니다.
- 잘못된 선행 수정이 발생하면 즉시 원복 후 사용자 지정 항목만 반영합니다.

## 검증 단계(Verification Step)
- `git diff --name-only`
- `git diff -- Design-Spec.md`
- 문서 변경 사항이 사용자 요구 번호(1,2,3)에 모두 대응되는지 항목 대조

## 적용 범위(Scope)
- Design-Spec/Architecture/Module 문서 업데이트, PR 본문 작성 등 요구사항 기반 문서 편집 전반

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad): 사용자 세부 요구 전 문서 전체를 구현 기준으로 재작성
- 좋은 예(Good): 사용자 요구 1,2,3 확정 후 해당 섹션만 순차 수정

## 관련 메모리(Related Memories)
- `entries/2026-03-03-branch-context-mismatch.md`
