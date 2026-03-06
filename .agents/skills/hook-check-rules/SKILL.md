---
name: hook-check-rules
description: 사용자 요청 키워드에 맞는 규칙 문서를 찾아 요약하고 작업 체크리스트를 생성합니다.
---

# Hook Check Rules

Claude `UserPromptSubmit` 훅(`check-rules.sh`)의 동작을 Codex 스킬로 포팅한 버전입니다.

## 트리거 조건

다음 요청이 들어오면 이 스킬을 사용합니다.

- 커밋/commit
- PR/pull request/풀리퀘스트
- 브랜치/branch
- 아키텍처/architecture/모듈/module
- 디자인시스템/design system/designsystem
- 리뷰/review/code review/코드 리뷰

## 실행 단계

### 1. 사용자 요청에서 키워드 추출

최근 사용자 요청 텍스트에서 아래 매핑 기준으로 키워드를 탐지합니다.

- `(커밋|commit)` -> `.agents/rules/commit-convention.md`
- `(pr|pull request|풀리퀘스트|풀 리퀘스트)` -> `.agents/rules/pr-convention.md`
- `(브랜치|branch)` -> `.agents/rules/branch-convention.md`
- `(아키텍처|architecture|모듈|module)` -> `.agents/rules/Architecture.md`
- `(디자인시스템|디자인 시스템|design system|designsystem)` -> `.agents/rules/design-system-component-convention.md`
- `(리뷰|review|code review|코드 리뷰)` -> `.agents/rules/code-review-convention.md`

### 2. 관련 규칙 문서 로드

매칭된 규칙 파일만 읽습니다.

### 3. 작업 전 체크리스트 생성

규칙에서 바로 실행 가능한 항목만 추려서 체크리스트를 만듭니다.

- 네이밍/브랜치/커밋 포맷 준수 여부
- PR 본문/템플릿/베이스 브랜치 조건
- 아키텍처 변경 시 문서 업데이트 필요 여부
- 코드 리뷰 체크리스트(아키텍처/DI/에러 처리/테스트) 준수 여부

### 4. 사용자에게 요약 보고

아래 형식으로 간단히 보고합니다.

```markdown
## 적용 규칙
- {규칙 문서}: {핵심 포인트}

## 이번 작업 체크리스트
- [ ] ...
- [ ] ...
```

## 예외 처리

- 키워드가 전혀 매칭되지 않으면 규칙 주입을 생략하고 일반 흐름으로 진행합니다.
- 문서가 없으면 누락 파일 경로를 명시하고, 나머지 규칙으로 계속 진행합니다.
