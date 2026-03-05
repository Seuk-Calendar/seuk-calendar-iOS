# SeukCalendar 문서 인덱스

프로젝트의 모든 문서 위치와 사용 시점을 안내합니다.

## 문서 읽기 순서

```
1. Architecture.md → 전체 아키텍처 구조 파악
2. Module.md → 작업 대상 모듈의 구조 파악
3. 실제 코드 파일 → 구현 세부사항 확인
```

---

## 아키텍처

| 문서 | 사용 시점 | 위치 |
|------|-----------|------|
| **Architecture** | 프로젝트 전체 구조 파악 | `.agents/rules/Architecture.md` |

---

## 모듈별 가이드

| 문서 | 사용 시점 | 위치 |
|------|-----------|------|
| **Core** | 공통 유틸리티, Extension, 에러 작업 | `SeukCalendar/Core/Module.md` |
| **DesignSystem** | SwiftUI 컴포넌트, 디자인 리소스 작업 | `SeukCalendar/DesignSystem/Module.md` |
| **Navigation** | Router, Destination, 네비게이션 작업 | `SeukCalendar/Navigation/Module.md` |
| **Coordinator** | DI Container, Coordinator 작업 | `SeukCalendar/Coordinator/Module.md` |
| **Domain** | Entity, UseCase, Repository 인터페이스 작업 | `SeukCalendar/Domain/Module.md` |
| **Data** | Repository 구현, API Client 작업 | `SeukCalendar/Data/Module.md` |
| **AI** | AI 작업 | `SeukCalendar/AI/Module.md` |
| **Feature** | View, ViewModel, ViewFactory 작업 | `SeukCalendar/Feature/Module.md` |
| **SeukCalendar App** | 앱 진입점/위젯 Extension 작업 | `SeukCalendar/SeukCalendar/Module.md` |

---

## 컨벤션

| 문서 | 사용 시점 | 위치 |
|------|-----------|------|
| **커밋 컨벤션** | 커밋 메시지 작성 | `.agents/rules/commit-convention.md` |
| **PR 컨벤션** | Pull Request 작성 | `.agents/rules/pr-convention.md` |
| **브랜치 컨벤션** | 브랜치 생성 | `.agents/rules/branch-convention.md` |
| **코드 리뷰 컨벤션** | 코드 리뷰 | `.agents/rules/code-review-convention.md` |
| **ViewModel 컨벤션** | ViewModel 파일 구조/DI 규칙 확인 | `.agents/rules/viewmodel-convention.md` |
| **디자인 가이드** | 디자인 수정/컴포넌트 계층(Tier) 규칙 확인 | `.agents/rules/design-guide.md` |

---

## 메모리 시스템

| 문서 | 사용 시점 | 위치 |
|------|-----------|------|
| **Memory 시스템 컨텍스트** | 시스템 배경/운영 목적 파악 | `.agents/memorys/SYSTEM_CONTEXT.md` |
| **Memory 운영 가이드** | 메모리 작성/검색 절차 확인 | `.agents/memorys/README.md` |
| **Memory 템플릿** | 신규 memory 작성 | `.agents/memorys/templates/memory-template.md` |
| **키워드 분류** | 키워드 표준 작성 | `.agents/memorys/index/KEYWORD_TAXONOMY.md` |
| **메모리 인덱스** | 기존 memory 검색/참조 | `.agents/memorys/index/MEMORY_INDEX.md` |

---

## 프로젝트 설정

| 문서 | 사용 시점 | 위치 |
|------|-----------|------|
| **CLAUDE** | Claude Code 프로젝트 설정 확인 | `CLAUDE.md` |
| **AGENTS** | 크로스 툴 공용 설정 확인 | `AGENTS.md` |

---

## 작업별 문서 탐색 예시

### 새로운 Feature 추가

```
1. Architecture.md → 패키지 구성 섹션
2. Feature/Module.md → Feature 타겟 구조 파악
3. Domain/Module.md → 필요한 Domain 확인
4. Data/Module.md → Repository 구현 확인
5. AI/Module.md → AI 기능 구현 확인
6. Navigation/Module.md → Destination 추가 방법
7. 실제 코드 파일 참조
```

### UseCase 구현

```
1. Architecture.md → Domain Layer 섹션
2. Domain/Module.md → UseCase 구조 파악
3. Pool/Domain/Sources/{Domain}/UseCase/ → 기존 UseCase 참조
4. Pool/Domain/Sources/{Domain}/Repository/ → Repository Interface 확인
```

### Repository 구현

```
1. Architecture.md → Data Layer 섹션
2. Data/Module.md → Repository 구현 가이드
3. Pool/Data/Sources/{Data}/Repository/ → 기존 Repository 참조
4. Pool/Data/Sources/KeyChainData/ → 인증 관련 확인
```

### 네비게이션 추가

```
1. Architecture.md → 네비게이션 / 라우팅 섹션
2. Navigation/Module.md → Destination 추가 방법
3. SeukCalendar/Navigation/Sources/Navigation/Destination.swift → 실제 코드 확인
4. SeukCalendar/Coordinator/Sources/Coordinator/Coordinator.swift → Coordinator 업데이트
```

---
