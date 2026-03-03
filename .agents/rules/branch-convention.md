# Branch Convention

## 형식

```
<타입>/#<이슈번호>-<간단한-설명>
```

## 타입

| 타입 | 설명 |
|------|------|
| feat | 새로운 기능 추가 |
| fix | 버그 수정 |
| env | 환경 설정, 빌드, CI/CD 관련 변경 |
| chore | 코드 변경 없는 잡무 (파일 정리, 설정 변경 등) |
| refactor | 기능 변경 없는 코드 리팩토링 |
| docs | 문서 추가 및 수정 |
| test | 테스트 추가 및 수정 |
| style | 코드 스타일 변경 (포맷팅, 세미콜론 등) |

## 예시

```
feat/#312-add-commit-rules
feat/#999-implement-home-feed
fix/#100-fix-login-crash
refactor/#200-improve-network-layer
env/#312-setup-ai-agent-environment
docs/#150-update-architecture-guide
```

## 규칙

- 브랜치명은 영어 소문자로 작성한다.
- 단어는 하이픈(-)으로 구분한다.
- 이슈번호는 반드시 포함한다.
- 간단한 설명은 2-4 단어로 간결하게 작성한다.
- 설명은 동사로 시작하여 작업 내용을 명확히 전달한다.
- 메인 브랜치는 `main` 또는 `develop`을 사용한다.
- 작업 완료 후 브랜치는 삭제한다.

## 추가 브랜치 타입

| 타입 | 설명 | 형식 |
|------|------|------|
| hotfix | 긴급한 프로덕션 버그 수정 | `hotfix/#<이슈번호>-<설명>` |
| release | 릴리즈 준비 브랜치 | `release/<버전>` |

## 브랜치 수명 주기

1. **브랜치 생성**: 이슈 할당 후 해당 이슈번호로 브랜치 생성
2. **작업 진행**: 해당 브랜치에서 커밋 작업 수행
3. **PR 생성**: 작업 완료 후 develop 브랜치로 PR 생성
4. **머지 및 삭제**: PR 머지 후 브랜치 삭제
