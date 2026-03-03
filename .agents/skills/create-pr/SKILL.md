---
name: create-pr
description: GitHub Pull Request를 자동으로 생성합니다. PR 템플릿을 기반으로 본문을 구성하고 사용자 확인 후 PR을 생성합니다.
user-invocable: true
---

# GitHub Pull Request Creation

GitHub Pull Request를 자동으로 생성하는 스킬입니다.

## 트리거 조건

다음 상황에서 이 스킬을 **자동으로** 실행:

1. 사용자가 명시적으로 PR 생성 요청 ("PR 만들어줘", "풀리퀘 생성해줘")
2. 작업이 완료되고 리뷰를 받아야 할 때

## 실행 단계

### 1. PR 템플릿 확인

`.github/PULL_REQUEST_TEMPLATE.md` 존재 여부 확인:

```bash
ls -la .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null
```

**IF** 템플릿 존재:
→ 템플릿 내용을 읽어서 PR 본문 구성에 사용

**IF** 템플릿 없음:
→ 기본 PR 형식 사용

### 2. 현재 브랜치 및 커밋 확인

현재 브랜치와 베이스 브랜치 확인:

```bash
# 현재 브랜치 확인
git branch --show-current

# 원격 추적 브랜치 확인
git status

# 베이스 브랜치와의 커밋 차이 확인 (보통 develop)
git log develop..HEAD --oneline

# 변경사항 확인
git diff develop...HEAD --stat
```

**IF** 브랜치가 원격에 푸시되지 않음:
→ `git push -u origin <branch>` 실행

### 3. 사용자 확인

**사용자에게 질문**:
```
이 브랜치로 Pull Request를 생성할까요?

브랜치: {현재 브랜치}
베이스: {베이스 브랜치}
커밋 수: {커밋 개수}
```

**IF** 사용자가 거부:
→ PR 생성 중단

**IF** 사용자가 동의:
→ 다음 단계 진행

### 4. PR 본문 구성

**IF** 템플릿 존재:
→ 템플릿을 기반으로 본문 작성

**ELSE**:
→ 기본 형식:
```markdown
## Changes

{변경사항 요약}

## Testing

{테스트 방법}
```

### 5. PR 제목 생성

커밋 메시지를 기반으로 PR 제목 생성:

**IF** 커밋이 1개:
→ 해당 커밋 메시지를 PR 제목으로 사용

**IF** 커밋이 여러 개:
→ 브랜치명 또는 주요 작업 내용으로 요약

### 6. PR 생성

GitHub CLI로 PR 생성:

```bash
gh pr create \
  --title "{제목}" \
  --body "{본문}" \
  --base develop \
  --assignee "@me"
```

**선택 사항**:
- 리뷰어 지정: `--reviewer "username"`
- 라벨 추가: `--label "feature"`
- 드래프트: `--draft`

### 7. 생성 완료 보고

**사용자에게 보고**:
```
✅ Pull Request가 생성되었습니다!

📋 PR 정보:
- 번호: #{PR번호}
- 제목: {제목}
- 베이스: {베이스 브랜치}
- URL: {PR URL}
```

## 엣지 케이스

### Case: 원격 브랜치에 푸시되지 않음
→ 자동으로 `git push -u origin <branch>` 실행

### Case: GitHub CLI 인증 안 됨
→ `gh auth status` 확인 후 사용자에게 인증 요청

### Case: 베이스 브랜치 지정 필요
→ AskUserQuestion 도구로 베이스 브랜치 선택 (develop, main 등)

### Case: 변경사항이 없는 경우
→ 사용자에게 경고 후 PR 생성 여부 재확인

### Case: 이미 PR이 존재하는 경우
→ 기존 PR URL 제공하고 새 PR 생성 중단

### Case: 커밋 메시지가 컨벤션을 따르지 않음
→ 그대로 사용하되, 사용자에게 제목 수정 제안

## 참고

상세 예시는 `references/examples.md` 참조
