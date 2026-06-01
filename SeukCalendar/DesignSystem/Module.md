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
│   │   │   ├── BadgeSegmentComponent/
│   │   │   ├── DateWrapComponent/
│   │   │   ├── MoreWrapComponent/
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
│   │   │           ├── HomeCalendarComponentWeekView.swift
│   │   │           ├── HomeCalendarComponentDayCell.swift
│   │   │           └── HomeCalendarComponentBadge.swift
│   │   ├── Tier2/
│   │   │   ├── WidgetTitleComponent/
│   │   │   └── WidgetWeekdayRowComponent/
│   │   └── Tier3/
│   │       ├── WidgetDayCellComponent/
│   │       ├── WidgetMediumComponent/
│   │       └── WidgetLargeComponent/
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
- BadgeSegmentComponent: 위젯/월간 셀에 사용하는 일정 막대 조각, start/startAndEnd/middle/end variant를 단일 API로 제공
- DateWrapComponent: 일반 날짜 텍스트와 오늘 날짜 원형 배지를 공통 렌더링
- MoreWrapComponent: `+N` overflow 표기를 전담하는 초소형 텍스트 컴포넌트
- HomeCalendarComponent: Pencil `Home Calendar Component` 디자인을 반영한 홈 카드형 월간 캘린더
- HomeCalendarComponent.DisplayMode: 홈 월간 캘린더의 확장형 일정 막대(`expanded`)와 상세 패널 상태용 점 indicator(`compactIndicator`) 표시 모드 제공
- HomeCalendarComponent `weekRowHeight`: 홈 화면처럼 가용 높이를 꽉 채워야 하는 화면에서 주 행 높이를 외부에서 지정할 수 있는 옵션
- HomeCalendarComponent+Calculate: 월간 그리드/이벤트 칩 구성을 `HomeCalendarComponent` 설정으로 변환하며, 다일 일정은 주 단위 spanning row로 계산한다
- HomeCalendarComponentWeekView: 날짜 행과 주 단위 이벤트 막대 행을 합성해 다일 일정이 하나의 막대처럼 이어지도록 렌더링한다
- CalendarWeekView, CalendarDayView, DateCell, ScheduleCard, CalendarEvent: 캘린더 관련 공개 타입을 `HomeCalendarComponent` 디렉토리 아래로 통합 관리

**Tier2** (조합 컴포넌트, 복수 개의 Tier1 컴포넌트)
**위치**: `DesignSystem/Components/Tier2/`
- SearchBar, Card 등 조합 요소
- WidgetTitleComponent: medium/large 위젯이 공통으로 사용하는 제목 컴포넌트
- WidgetWeekdayRowComponent: locale 기반 요일 문자열과 주말 색상 규칙을 캡슐화한 위젯 요일 행

**Tier3** (복잡한 UI, 복수 개의 Tier2 컴포넌트)
**위치**: `DesignSystem/Components/Tier3/`
- Header, Footer 등 복잡한 UI
- WidgetDayCellComponent: `DateWrap + BadgeSegment x2 + MoreWrap` 조합으로 월간 셀 상태를 렌더링
- WidgetMediumComponent: 위젯 1주 뷰 조합 컴포넌트, empty state를 configuration 상태로 흡수
- WidgetLargeComponent: 5주 월간 그리드를 렌더링하는 대형 위젯 조합 컴포넌트

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
