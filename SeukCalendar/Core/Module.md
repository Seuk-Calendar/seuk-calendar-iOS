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
├── Core.xcodeproj
├── Core/
│   ├── AdaptiveLayout/
│   │   └── AdaptiveLayout.swift
│   ├── Error/
│   │   └── SCError.swift
│   ├── Extensions/
│   │   ├── Collection+Safe.swift
│   │   ├── Double+UnixTime.swift
│   │   └── ...
│   └── Utils/
└── CoreTests/
```

## 주요 구성요소

### SCError Protocol

모든 도메인 에러가 따라야 하는 프로토콜.

**위치**: `Core/Error/SCError.swift`

### Extensions

Foundation 타입에 대한 Extension.

**위치**: `Core/Extensions/`
- String 유틸리티
- Date 변환 및 포맷팅
- Date 상대 시간 오프셋(`Date+Offset.swift`, `TimeOffset`)
- 기타 Foundation 타입 Extension

### AdaptiveLayout

SwiftUI 적응형 레이아웃 판단 헬퍼.

**위치**: `Core/AdaptiveLayout/AdaptiveLayout.swift`

### Utils

공통 헬퍼 함수 및 유틸리티 클래스.

**위치**: `Core/Utils/`

## 의존성

- **외부 의존성 없음** (최하위 레이어)
- 모든 다른 모듈이 Core에 의존

## Xcode 프로젝트 설정

**위치**: `Core.xcodeproj`

**주요 설정**:
- 플랫폼: iOS 18+
- 프레임워크 타입: Dynamic Framework
- 의존성: 없음
- 타겟: Core (Framework), CoreTests (Unit Test)

## 사용 가이드

### 에러 정의

새로운 도메인 에러를 정의할 때 SCError를 채택.

**참고**: `Core/Error/SCError.swift`

### Extension 사용

**참고**: `Core/Extensions/` 디렉토리의 각 Extension 파일
