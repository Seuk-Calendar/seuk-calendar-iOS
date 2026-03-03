# Memorys 운영 가이드

## 목적(Purpose)
`memory` 문서를 누적하여 에이전트가 사용자 명령 전에 과거 실수/안티 패턴/사용자 피드백을 검색하고 재발을 줄이기 위한 시스템입니다.

## 디렉토리 구조(Directory Structure)
- `SYSTEM_CONTEXT.md`: 시스템 배경/의사결정 컨텍스트
- `templates/memory-template.md`: 메모리 작성 템플릿
- `entries/*.md`: 실제 메모리 기록
- `index/*.md`: 키워드 체계 및 인덱스 문서

## 포맷 규칙(Format Rules)
- 메모리 단위는 `memory` 입니다.
- 각 메모리는 `.md` 파일 1개입니다.
- 모든 섹션은 `##` 로 시작합니다.
- 섹션명은 `한글(English)` 형식으로 작성합니다.
- `## 키워드(Keywords)` 와 `## 사전 점검(Pre-Command Check)`는 필수입니다.

## 운영 정책(Policies)
- 노이즈 방지: 재발 가능성/영향이 낮은 사안은 기록하지 않습니다.
- 사용자 알림: `write-memory`로 기록 완료 시 사용자에게 반드시 알립니다.

## 자동 검색 동작(Automatic Lookup)
- 사용자 명령 제출 시 `.claude/hooks/check-memory.sh`가 항상 호출됩니다.
- 훅은 입력 키워드를 기준으로 `entries/`를 우선 검색합니다.
- 관련 메모리가 있으면 사전 점검 체크리스트를 주입합니다.

## 작성 절차(Authoring Flow)
1. `templates/memory-template.md` 복사
2. 파일명: `YYYY-MM-DD-short-slug.md`
3. 필수 섹션 작성
4. `index/MEMORY_INDEX.md`에 항목 추가
5. 사용자에게 기록 완료 알림
