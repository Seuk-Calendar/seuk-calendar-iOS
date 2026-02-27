# Pool iOS

Pool iOS 프로젝트입니다.

## 구조

```
.agent/                  # 크로스 툴 공유
├── rules/               # 컨벤션 규칙 (커밋, PR)
└── scripts/             # 셸 스크립트

.claude/                 # Claude Code 전용
├── agents/              # 에이전트 정의 (planner, implementer, researcher, explorer)
├── rules/               # Claude 전용 규칙 (스킬 작성 표준 등)
└── skills/              # 슬래시 커맨드 스킬
```

## 규칙

작업 시 아래 규칙 파일들을 반드시 읽고 따릅니다.

- **커밋**: `.agent/rules/commit-convention.md` — `#<이슈번호> <타입> :: <제목>` 형식
- **PR**: `.agent/rules/pr-convention.md` — `(#<이슈번호>) <제목>` 형식, `.github/PULL_REQUEST_TEMPLATE.md` 템플릿 사용

## 코딩 원칙

- 최소한의 변경으로 목표 달성
- 불필요한 리팩터링/추상화 금지
- 기존 컨벤션과 코드 스타일 준수
- 한국어로 커밋 메시지, PR 제목/본문 작성
