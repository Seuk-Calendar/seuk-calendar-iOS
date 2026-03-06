# DesignSystem Module

SwiftUI 기반의 공통 UI 컴포넌트와 디자인 리소스를 제공합니다.

## 역할

- SwiftUI 공통 컴포넌트 (Atomic Design)
- 폰트, 색상, 아이콘 등 디자인 리소스
- 일관된 UI/UX 제공

## 디렉토리 구조

```
DesignSystem/
├── DesignSystem.xcodeproj
├── DesignSystem/
│   ├── Components/
│   │   ├── Tier1/
│   │   │   └── HomeCalendarComponent/
│   │   │       ├── CalendarEvent.swift
│   │   │       ├── CalendarDayView.swift
│   │   │       ├── CalendarWeekView.swift
│   │   │       ├── DateCell.swift
│   │   │       ├── ScheduleCard.swift
│   │   │       ├── HomeCalendarComponent.swift
│   │   │       ├── HomeCalendarComponent+Configuration.swift
│   │   │       ├── HomeCalendarComponent+Event.swift
│   │   │       ├── HomeCalendarComponent+Calculate.swift
│   │   │       └── Components/
│   │   │           ├── HomeCalendarComponentMonthBar.swift
│   │   │           ├── HomeCalendarComponentWeekdayBar.swift
│   │   │           ├── HomeCalendarComponentDayCell.swift
│   │   │           └── HomeCalendarComponentBadge.swift
│   │   ├── Tier2/    # 복수 개의 Tier1 컴포넌트
│   │   └── Tier3/    # 복수 개의 Tier2 컴포넌트
│   ├── Resources/
│   │   ├── Fonts/
│   │   ├── Colors/
│   │   └── Images/
│   └── ResourceSystem/
│       ├── ColorSystem/
│       ├── FontSystem/
│       └── ImageSystem/
└── DesignSystemTests/
```

## 주요 구성요소

### Atomic Design 구조

**Tier1** (기본 컴포넌트)
**위치**: `DesignSystem/Components/Tier1/`
- Button, Text, Icon 등 기본 요소
- HomeCalendarComponent: Pencil `Home Calendar Component` 디자인을 반영한 홈 카드형 월간 캘린더
- HomeCalendarComponent+Calculate: 월간 그리드/이벤트 칩 구성을 `HomeCalendarComponent` 설정으로 변환하며, `HomeCalendarComponent`의 월간 캘린더용 공개 초기화가 이를 사용
- CalendarWeekView, CalendarDayView, DateCell, ScheduleCard, CalendarEvent: 캘린더 관련 공개 타입을 `HomeCalendarComponent` 디렉토리 아래로 통합 관리

**Tier2** (조합 컴포넌트, 복수 개의 Tier1 컴포넌트)
**위치**: `DesignSystem/Components/Tier2/`
- SearchBar, Card 등 조합 요소

**Tier3** (복잡한 UI, 복수 개의 Tier2 컴포넌트)
**위치**: `DesignSystem/Components/Tier3/`
- Header, Footer 등 복잡한 UI

### 디자인 리소스

**Fonts**
**위치**: `DesignSystem/Resources/Fonts/`
**관리**: `DesignSystem/ResourceSystem/FontSystem.swift`

**Colors**
**위치**: `DesignSystem/Resources/Colors/`

**Images**
**위치**: `DesignSystem/Resources/Images/`

## 의존성

- **Core**: 공통 유틸리티 및 Extension

## Xcode 프로젝트 설정

**위치**: `DesignSystem.xcodeproj`

**주요 설정**:
- 플랫폼: iOS 18+
- 프레임워크 타입: Dynamic Framework
- 의존성: Core.framework
- 리소스: Resources 디렉토리 포함
- 타겟: DesignSystem (Framework), DesignSystemTests (Unit Test)

## 사용 가이드

### 컴포넌트 사용

**참고**: `DesignSystem/Components/` 디렉토리의 각 컴포넌트 파일

### 색상 사용

**참고**: `DesignSystem/ResourceSystem/ColorSystem.swift`

### 폰트 사용

**참고**: `DesignSystem/ResourceSystem/FontSystem.swift`
