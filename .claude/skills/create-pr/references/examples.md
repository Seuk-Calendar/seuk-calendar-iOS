# GitHub Pull Request Creation Examples

## 예시 1: 사용자가 명시적으로 PR 생성 요청

### 대화

```
사용자: PR 만들어줘

AI: Pull Request를 생성하겠습니다.

[현재 브랜치 확인]
브랜치: feature/user-profile

[원격 브랜치 확인]
원격에 푸시되지 않았습니다. 먼저 푸시하겠습니다.

[git push -u origin feature/user-profile 실행]

[커밋 확인]
develop과 비교:
- 3 commits
- 15 files changed

이 브랜치로 Pull Request를 생성할까요?

브랜치: feature/user-profile
베이스: develop
커밋 수: 3

사용자: 응

AI: [PR 생성 중...]

✅ Pull Request가 생성되었습니다!

📋 PR 정보:
- 번호: #315
- 제목: 사용자 프로필 기능 추가
- 베이스: develop
- URL: https://github.com/ES-Pool/pool-iOS/pull/315
```

---

## 예시 2: 작업 완료 후 자동 감지

### 대화

```
사용자: 로그인 기능 구현 완료했어. 이제 리뷰 받고 싶어

AI: 로그인 기능 구현이 완료되었군요.
Pull Request를 생성해서 리뷰를 받으시겠습니까?

[현재 브랜치 확인]
브랜치: feature/login

[커밋 확인]
develop과 비교:
- 5 commits
- 23 files changed

이 브랜치로 Pull Request를 생성할까요?

브랜치: feature/login
베이스: develop
커밋 수: 5

사용자: 네

AI: [PR 템플릿 확인]

[커밋 메시지 분석]
#250 feat :: 로그인 API 연동
#250 feat :: 로그인 UI 구현
#250 test :: 로그인 테스트 추가
#250 fix :: 토큰 저장 로직 수정
#250 docs :: 로그인 문서 업데이트

[PR 본문 구성]

## 주요 작업 내용

### 로그인 API 연동
- OAuth 2.0 인증 플로우 구현
- 토큰 저장 및 갱신 로직 추가

### 로그인 UI 구현
- 로그인 화면 레이아웃 구성
- 입력 유효성 검증

### 테스트 및 문서화
- 단위 테스트 추가
- API 문서 업데이트

## 참고사항

토큰 저장은 Keychain을 사용하여 보안성을 강화했습니다.

[PR 생성]

✅ Pull Request가 생성되었습니다!

📋 PR 정보:
- 번호: #316
- 제목: 로그인 기능 구현
- 베이스: develop
- URL: https://github.com/ES-Pool/pool-iOS/pull/316
```

---

## 예시 3: 이미 PR이 존재하는 경우

### 대화

```
사용자: PR 만들어줘

AI: Pull Request를 생성하겠습니다.

[현재 브랜치 확인]
브랜치: feature/settings

[기존 PR 확인]
gh pr list --head feature/settings

이미 이 브랜치에 대한 PR이 존재합니다:
- #300: 설정 화면 개선 (open)
- URL: https://github.com/ES-Pool/pool-iOS/pull/300

새로운 PR을 생성하시겠습니까?

사용자: 아니, 기존 PR 사용할게

AI: 알겠습니다. 기존 PR #300을 사용합니다.
```

---

## 예시 4: 베이스 브랜치 선택

### 대화

```
사용자: main으로 PR 만들어줘

AI: Pull Request를 생성하겠습니다.

[현재 브랜치 확인]
브랜치: hotfix/critical-bug

[커밋 확인]
main과 비교:
- 2 commits
- 3 files changed

이 브랜치로 Pull Request를 생성할까요?

브랜치: hotfix/critical-bug
베이스: main
커밋 수: 2

사용자: 응

AI: [PR 생성 중...]

gh pr create \
  --title "긴급 버그 수정" \
  --body "..." \
  --base main \
  --assignee "@me"

✅ Pull Request가 생성되었습니다!

📋 PR 정보:
- 번호: #317
- 제목: 긴급 버그 수정
- 베이스: main
- URL: https://github.com/ES-Pool/pool-iOS/pull/317
```

---

## 예시 5: 드래프트 PR 생성

### 대화

```
사용자: 아직 작업 중인데 드래프트 PR 만들어줘

AI: 드래프트 Pull Request를 생성하겠습니다.

[현재 브랜치 확인]
브랜치: feature/experimental

[커밋 확인]
develop과 비교:
- 7 commits
- 42 files changed

이 브랜치로 드래프트 Pull Request를 생성할까요?

브랜치: feature/experimental
베이스: develop
커밋 수: 7

사용자: 네

AI: [PR 생성 중...]

gh pr create \
  --title "실험적 기능 추가 (WIP)" \
  --body "..." \
  --base develop \
  --assignee "@me" \
  --draft

✅ 드래프트 Pull Request가 생성되었습니다!

📋 PR 정보:
- 번호: #318
- 제목: 실험적 기능 추가 (WIP)
- 베이스: develop
- 상태: Draft
- URL: https://github.com/ES-Pool/pool-iOS/pull/318
```

---

## 예시 6: 리뷰어 지정

### 대화

```
사용자: PR 만들어줘. 리뷰어는 @johndoe로

AI: Pull Request를 생성하겠습니다.

[현재 브랜치 확인]
브랜치: feature/notification

[커밋 확인]
develop과 비교:
- 4 commits
- 18 files changed

이 브랜치로 Pull Request를 생성할까요?

브랜치: feature/notification
베이스: develop
커밋 수: 4
리뷰어: @johndoe

사용자: 응

AI: [PR 생성 중...]

gh pr create \
  --title "알림 기능 구현" \
  --body "..." \
  --base develop \
  --assignee "@me" \
  --reviewer "johndoe"

✅ Pull Request가 생성되었습니다!

📋 PR 정보:
- 번호: #319
- 제목: 알림 기능 구현
- 베이스: develop
- 리뷰어: @johndoe
- URL: https://github.com/ES-Pool/pool-iOS/pull/319
```

---

## 예시 7: 단일 커밋에서 PR 제목 자동 생성

### 대화

```
사용자: PR 만들어줘

AI: Pull Request를 생성하겠습니다.

[현재 브랜치 확인]
브랜치: fix/typo

[커밋 확인]
develop과 비교:
- 1 commit: #289 fix :: 오타 수정

이 브랜치로 Pull Request를 생성할까요?

브랜치: fix/typo
베이스: develop
커밋 수: 1

사용자: 응

AI: [PR 생성 중...]

커밋이 1개이므로 커밋 메시지를 PR 제목으로 사용합니다.

gh pr create \
  --title "#289 fix :: 오타 수정" \
  --body "..." \
  --base develop \
  --assignee "@me"

✅ Pull Request가 생성되었습니다!

📋 PR 정보:
- 번호: #320
- 제목: #289 fix :: 오타 수정
- 베이스: develop
- URL: https://github.com/ES-Pool/pool-iOS/pull/320
```

---

## 주의사항

1. **원격 푸시 확인**: PR 생성 전 브랜치가 원격에 푸시되었는지 확인
2. **중복 PR 확인**: 같은 브랜치에 이미 PR이 있는지 확인
3. **템플릿 우선**: PR 템플릿이 있으면 반드시 사용
4. **커밋 분석**: 커밋 메시지를 분석하여 PR 본문 자동 구성
5. **베이스 브랜치**: 기본은 develop, 필요시 사용자에게 확인
6. **자동 assignee**: 기본적으로 작성자(@me)가 담당자로 할당됨
7. **리뷰어**: 필요시 사용자가 리뷰어를 지정할 수 있음
