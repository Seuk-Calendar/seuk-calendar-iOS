# Core Module

공통 기반 모듈로, 프로젝트 전체에서 사용되는 기본 타입, 유틸리티, Extension을 제공합니다.

## 역할

- 공통 유틸리티, Extension
- 에러 타입 정의 (SCError)
- 기본 타입 및 헬퍼 함수
- **의존성 없음**: 최하위 레이어

## 디렉토리 구조

```
Core/
├── Package.swift
├── Sources/
│   └── Core/
│       ├── Error/
│       │   └── SCError.swift
│       ├── Extensions/
│       │   ├── String+Extensions.swift
│       │   ├── Date+Extensions.swift
│       │   └── ...
│       └── Utilities/
└── Tests/
    └── CoreTests/
```

## 주요 구성요소

### SCError Protocol

모든 도메인 에러가 따라야 하는 프로토콜.

**위치**: `Sources/Core/Error/SCError.swift`

### Extensions

Foundation 타입에 대한 Extension.

**위치**: `Sources/Core/Extensions/`
- String 유틸리티
- Date 변환 및 포맷팅
- 기타 Foundation 타입 Extension

### Utilities

공통 헬퍼 함수 및 유틸리티 클래스.

**위치**: `Sources/Core/Utilities/`

## 의존성

- **외부 의존성 없음** (최하위 레이어)
- 모든 다른 모듈이 Core에 의존

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 26+
- 의존성: 없음
- 타겟: Core, CoreTests

## 사용 가이드

### 에러 정의

새로운 도메인 에러를 정의할 때 SCError를 채택.

**참고**: `Sources/Core/Error/SCError.swift`

### Extension 사용

**참고**: `Sources/Core/Extensions/` 디렉토리의 각 Extension 파일
