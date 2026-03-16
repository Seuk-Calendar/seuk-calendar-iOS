## 제목(Title)
- 유니코드가 섞인 유사 워크스페이스 경로에서 파일 생성 위치를 먼저 검증해야 하는 사례

## 날짜(Date)
- 2026-03-07

## 유형(Type)
- mistake

## 키워드(Keywords)
- workflow:issue-to-pr
- workflow:path-safety
- action:verify-workspace-root
- failure:wrong-unicode-path
- target:filesystem
- risk:out-of-repo-file-create
- verify:pwd-git-root-before-move

## 컨텍스트(Context)
- 한글이 포함된 유사한 디렉토리명 사이에서 Tier3 컴포넌트 파일 일부를 현재 저장소가 아닌 인접 경로에 잘못 생성했다.

## 문제 행동(Bad Action)
- 새 파일을 생성하거나 이동하기 전에 `pwd`와 저장소 루트를 확인하지 않고 경로 문자열만 보고 작업했다.

## 사용자 피드백(User Feedback)
- 직접 교정 요청은 없었지만, 잘못된 경로에 생성된 파일을 현재 저장소로 옮기고 불필요한 폴더를 정리해야 했다.

## 원인(Root Cause)
- 유니코드가 포함된 비슷한 프로젝트 경로를 육안으로만 구분했고, 파일 생성 직전 저장소 기준 검증 절차를 생략했다.

## 예방 규칙(Prevention Rule)
- 유니코드 또는 유사 프로젝트명이 포함된 경로에서 새 파일을 만들거나 이동할 때는 먼저 `pwd`와 `git rev-parse --show-toplevel`로 현재 작업 루트를 확인한다.

## 사전 점검(Pre-Command Check)
- 파일 생성/이동 직전에 현재 경로와 Git 루트가 사용자가 지정한 저장소와 정확히 일치하는지 확인했는가?

## 금지 동작(Do Not Do)
- 비슷해 보이는 한글/유니코드 경로를 육안 확인만으로 동일 저장소라고 가정하지 않는다.

## 안전 대안(Safe Alternative)
- 생성/이동 전에 절대 경로를 다시 확인하고, 필요하면 `git status --short`로 변경이 원하는 저장소에 반영되는지 즉시 검증한다.

## 검증 단계(Verification Step)
- 파일 생성 또는 이동 직후 `git status --short`에 기대한 파일이 나타나는지 확인한다.

## 적용 범위(Scope)
- 여러 한글 프로젝트 디렉토리나 유사한 워크스페이스 이름이 공존하는 모든 로컬 작업

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad):
  - 경로 문자열만 보고 다른 `seuk-calendar-*` 디렉토리에 새 파일을 생성한다.
- 좋은 예(Good):
  - `pwd`, `git rev-parse --show-toplevel`, `git status --short`로 저장소를 확인한 뒤 파일을 생성한다.

## 관련 메모리(Related Memories)
- `entries/2026-03-03-branch-context-mismatch.md`
