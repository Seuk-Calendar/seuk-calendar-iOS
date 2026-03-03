---
name: check-memory
description: 사용자 요청 직후 memory 문서를 검색해 사전 점검 체크리스트를 주입합니다. 브랜치/리베이스/커밋/PR/리뷰/빌드 등 실행 전 실수 재발 방지가 필요한 작업에서 사용합니다.
---

# Check Memory

사용자 명령 직후 과거 `memory`를 검색해 재발 방지 컨텍스트를 제공합니다.

## 실행 위치(Where It Runs)
- 기본 실행: `.claude/hooks/check-memory.sh` (UserPromptSubmit)
- 보조 실행: 필요 시 수동 검색

## 실행 단계(Execution Steps)
1. 사용자 입력에서 키워드를 추출합니다.
2. `.agents/memorys/entries/*.md`를 검색합니다.
3. 관련 메모리의 `사전 점검(Pre-Command Check)`를 우선 요약합니다.
4. 관련 메모리가 없으면 아무 내용도 주입하지 않습니다.

## 검색 규칙(Search Rules)
- 기본 검색 도구는 `rg`를 사용합니다.
- 검색 결과는 최대 5개 파일까지만 사용합니다.
- 출력은 짧은 체크리스트 중심으로 제한합니다.

## 출력 형식(Output)
```markdown
🧠 관련 메모리(Memory) 사전 검색
- 입력 키워드: ...
- 사전 점검: ...
- 참고 파일: ...
```

## 예외 처리(Exceptions)
- `memorys` 디렉토리가 없거나 비어있으면 조용히 종료합니다.
- 키워드가 유효하지 않으면 결과를 출력하지 않습니다.
