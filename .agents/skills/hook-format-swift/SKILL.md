---
name: hook-format-swift
description: Swift 파일 수정 후 swiftformat을 실행해 포맷을 정리하고 결과를 보고합니다.
---

# Hook Format Swift

Claude `PostToolUse` 훅(`format-swift.sh`)의 동작을 Codex 스킬로 포팅한 버전입니다.

## 트리거 조건

다음 상황에서 이 스킬을 사용합니다.

- Swift 파일을 수정한 직후
- 커밋 전 코드 스타일 정리를 하고 싶을 때

## 실행 단계

### 1. 대상 파일 결정

기본값은 "변경된 `.swift` 파일 전체"입니다.

- `git diff --name-only -- '*.swift'`
- `git diff --cached --name-only -- '*.swift'`
- `git ls-files --others --exclude-standard -- '*.swift'`

사용자가 파일 경로를 지정하면 지정 경로만 포맷합니다.

### 2. swiftformat 실행

스크립트를 실행합니다.

```bash
bash .agents/skills/hook-format-swift/scripts/format-swift-files.sh [optional-swift-files...]
```

### 3. 결과 확인 및 보고

- 포맷한 파일 목록
- 실패한 파일/실패 원인
- 후속 권장 작업(`git diff` 확인)

## 예외 처리

- `swiftformat`이 없으면 설치 필요 메시지를 출력하고 중단합니다.
- 대상 파일이 없으면 "포맷 대상 없음"을 보고하고 종료합니다.
