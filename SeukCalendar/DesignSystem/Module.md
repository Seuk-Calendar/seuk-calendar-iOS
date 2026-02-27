# DesignSystem Module

SwiftUI 기반의 공통 UI 컴포넌트와 디자인 리소스를 제공합니다.

## 역할

- SwiftUI 공통 컴포넌트 (Atomic Design)
- 폰트, 색상, 아이콘 등 디자인 리소스
- 일관된 UI/UX 제공

## 디렉토리 구조

```
DesignSystem/
├── Package.swift
├── Module.md
├── Sources/
│   └── DesignSystem/
│       ├── Components/
│       │   ├── Atoms/        # 기본 컴포넌트
│       │   ├── Molecules/    # 조합 컴포넌트
│       │   └── Organisms/    # 복잡한 컴포넌트
│       ├── Resources/
│       │   ├── Fonts/
│       │   ├── Colors/
│       │   └── Images/
│       └── Utilities/
│           └── FontManager.swift
└── Tests/
    └── DesignSystemTests/
```

## 주요 구성요소

### Atomic Design 구조

**Atoms** (기본 컴포넌트)
**위치**: `Sources/DesignSystem/Components/Atoms/`
- Button, Text, Icon 등 기본 요소

**Molecules** (조합 컴포넌트)
**위치**: `Sources/DesignSystem/Components/Molecules/`
- SearchBar, Card 등 조합 요소

**Organisms** (복잡한 UI)
**위치**: `Sources/DesignSystem/Components/Organisms/`
- Header, Footer 등 복잡한 UI

### 디자인 리소스

**Fonts**
**위치**: `Sources/DesignSystem/Resources/Fonts/`
**관리**: `Sources/DesignSystem/Utilities/FontManager.swift`

**Colors**
**위치**: `Sources/DesignSystem/Resources/Colors/`

**Images**
**위치**: `Sources/DesignSystem/Resources/Images/`

## 의존성

- **Core**: 공통 유틸리티 및 Extension

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 18+
- 의존성: Core
- 리소스: Resources 디렉토리

## 사용 가이드

### 컴포넌트 사용

**참고**: `Sources/DesignSystem/Components/` 디렉토리의 각 컴포넌트 파일

### 색상 사용

**참고**: `Sources/DesignSystem/Resources/Colors/`

### 폰트 사용

**참고**: `Sources/DesignSystem/Utilities/FontManager.swift`
