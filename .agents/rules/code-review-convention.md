# Code Review Convention

코드 리뷰 시 확인해야 할 체크리스트입니다.

## 기본 체크리스트

- [ ] **아키텍처 준수**: Clean Architecture 레이어 분리
- [ ] **DI 적용**: 의존성 주입 사용 (하드코딩 X)
- [ ] **에러 처리**: SCError 프로토콜 사용
- [ ] **테스트 작성**: 주요 로직에 Unit Test 작성
- [ ] **네이밍**: 컨벤션 준수
- [ ] **주석**: 복잡한 로직에 주석 추가
- [ ] **SwiftLint**: 린트 경고 없음

## 아키텍처

### 레이어 분리

- [ ] Presentation Layer는 Domain Layer에만 의존
- [ ] Domain Layer는 Data Layer에 의존하지 않음
- [ ] Repository Interface는 Domain에 정의
- [ ] Repository Implementation은 Data에 위치

### 의존성 주입

- [ ] View/ViewModel에서 직접 Repository/UseCase 생성 금지
- [ ] DI Container 또는 ViewFactory를 통한 의존성 주입
- [ ] 하드코딩된 의존성 없음

## 코드 품질

### 네이밍

- [ ] 타입: PascalCase (`FeedViewModel`, `Shorts`)
- [ ] 변수/함수: camelCase (`fetchShorts`, `playlist`)
- [ ] 프로토콜: PascalCase + 형용사/명사 (`ShortsRepository`, `Buildable`)
- [ ] 의미 있는 이름 사용 (약어 지양)

### 접근 제어

- [ ] 기본은 `private`, 필요한 경우에만 `internal`, `public`
- [ ] Interface는 `public`, Implementation은 `internal` 기본
- [ ] `fileprivate` 최소한 사용

### 에러 처리

- [ ] SKError 프로토콜을 채택한 에러 타입 사용
- [ ] 에러 메시지는 사용자 친화적
- [ ] try/catch로 적절히 에러 처리
- [ ] 강제 언래핑(!) 최소화

### 주석

- [ ] 복잡한 비즈니스 로직에 주석 추가
- [ ] MARK 주석으로 코드 섹션 구분
- [ ] 불필요한 주석 제거 (코드로 설명 가능한 경우)

## 테스트

- [ ] 주요 로직에 Unit Test 작성
- [ ] UseCase, ViewModel에 테스트 작성
- [ ] Mock 객체를 사용한 독립적 테스트
- [ ] 테스트 커버리지: Domain 80%+, Presentation 70%+

## SwiftUI

### View

- [ ] View는 비즈니스 로직 없음 (순수 UI)
- [ ] .send()로 Action 전달
- [ ] 복잡한 View는 Component로 분리

### ViewModel

- [ ] @Observable 매크로 사용
- [ ] Action 기반 상태 관리
- [ ] 비동기 작업은 async/await 사용

## Package 구조

- [ ] 올바른 패키지에 파일 위치
- [ ] Package.swift에 의존성 명확히 정의
- [ ] 순환 의존성 없음

## SwiftLint

- [ ] 린트 경고 없음
- [ ] line_length: 120자 제한
- [ ] force_cast, force_unwrapping 금지

## PR 전 체크리스트

- [ ] 빌드 성공
- [ ] 테스트 통과
- [ ] SwiftLint 경고 없음
- [ ] 커밋 메시지 컨벤션 준수
- [ ] PR 템플릿 작성 완료

## 참고 문서

- 커밋 컨벤션: `.agents/rules/commit-convention.md`
- PR 컨벤션: `.agents/rules/pr-convention.md`
- 브랜치 컨벤션: `.agents/rules/branch-convention.md`
- 아키텍처: `.agents/rules/Architecture.md`
