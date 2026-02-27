# Skill Standards

스킬 작성 시 따라야 하는 표준입니다.

---

## 파일 구조

```
~/.claude/skills/{name}/SKILL.md    # 유저 스코프 (전역)
.claude/skills/{name}/SKILL.md      # 프로젝트 스코프
```

스킬 이름이 곧 호출명입니다: `/commit` → `skills/commit/SKILL.md`

### 디렉토리 구성

```
skills/{name}/
├── SKILL.md           # 메인 스킬 파일 (500줄 이하 권장)
└── references/        # 상세 가이드 분리 (선택)
    ├── conventions.md
    └── examples.md
```

### 진입점 vs 재사용 스킬

| 유형 | 네이밍 | user-invocable | 용도 |
|-----|--------|----------------|------|
| 진입점 | `skills/{name}/` | `true` | 사용자 직접 호출 |
| 재사용 | `skills/_name/` | `false` | 다른 스킬에서 참조 |

---

## Frontmatter

```yaml
---
name: skill-name           # 호출명 (/skill-name)
description: 스킬 설명      # 자동 매칭에 사용
user-invocable: true       # 사용자 직접 호출 가능 여부 (기본: true)
---
```

**필수 필드**: `name`, `description`
**선택 필드**: `user-invocable` (기본값: `true`)

---

## 스킬 구조 템플릿

```markdown
---
name: example
description: 스킬에 대한 한 줄 설명
user-invocable: true
---

# 스킬 제목

{스킬에 대한 설명}

## 실행 단계

### 1. {단계명}

{상세 설명}

### 2. {단계명}

{상세 설명}

## 엣지 케이스

### Case: {케이스 설명}
→ {처리 방법}
```

---

## 스크립트 위임 패턴

결정적 로직은 스크립트로 분리합니다.

### 스크립트 호출

```markdown
### 2. 브랜치명 생성

스크립트로 브랜치명 생성:

\`\`\`bash
branch_name=$(.agent/scripts/branch-name.sh "$type" "$issue_id" "$title")
\`\`\`

→ 결과를 `$branch_name` 변수로 사용
```

### 스크립트화 대상

| 대상 | 스크립트 |
|-----|----------|
| 브랜치명 생성 | `scripts/branch-name.sh` |
| 이슈 ID 추출 | `scripts/extract-issue.sh` |
| 경로 계산 | `scripts/worktree-path.sh` |

---

## 에이전트 위임 패턴

복잡한 분석/계획 작업은 에이전트에게 위임합니다.

```markdown
### 3. 구현 계획 수립

→ Task 도구로 **planner** 에이전트에게 위임:

\`\`\`
## 목적
{작업 목적}

## 요청
{구체적 요청}
\`\`\`
```

---

## 문법 패턴

### 조건 분기

```markdown
**IF** 조건:
→ 처리 방법

**ELSE IF** 다른 조건:
→ 다른 처리

**ELSE**:
→ 기본 처리
```

### 사용자 질문

```markdown
**사용자에게 질문**:
\`\`\`
{질문 내용}

1. 옵션 1
2. 옵션 2

선택:
\`\`\`
```

### 체크리스트

```markdown
**체크리스트**:
- [ ] 항목 1
- [ ] 항목 2
```

### 결과 보고

```markdown
**사용자에게 보고**:
\`\`\`
✅ 작업 완료!

📋 결과:
- 항목: {값}
\`\`\`
```

### 다른 스킬 참조

```markdown
→ **other-skill** 참조하여 실행
```

### 서브에이전트 위임

```markdown
→ Task 도구로 **{agent-type}** 에이전트에게 위임
```

---

## 크기 가이드라인

| 항목 | 권장 |
|-----|------|
| SKILL.md 전체 | 500줄 이하 |
| 단일 단계 | 50줄 이하 |
| 엣지 케이스 | 10개 이하 |

**500줄 초과 시**:
- 상세 가이드를 `references/`로 분리
- 공통 절차를 재사용 스킬로 추출
- 복잡한 로직을 에이전트에게 위임

---

## 체크리스트

스킬 작성 완료 전 확인:

- [ ] frontmatter에 name, description 있는가?
- [ ] user-invocable 값이 올바른가?
- [ ] 실행 단계가 순차적으로 번호 매겨져 있는가?
- [ ] 엣지 케이스가 정의되어 있는가?
- [ ] 결과 보고 형식이 있는가?
- [ ] 결정적 로직이 스크립트로 분리되었는가?
- [ ] 500줄 이하인가?
