# Feature Module

UI 레이어 모듈로, 6개의 Feature 타겟으로 구성되어 있습니다.

## 역할

- SwiftUI View 구현
- ViewModel (@Observable) 구현
- 사용자 인터랙션 처리
- 화면별 프레젠테이션 로직

## 디렉토리 구조

```
Feature/
├── Package.swift
├── Module.md
├── Sources/
│   ├── BaseFeature/
│   │   ├── ViewFactory/
│   │   │   └── ViewFactory.swift
│   │   └── Utils/
│   │       └── ViewModelProtocol.swift
│   ├── CalendarFeature/
│   │   ├── View/
│   │   │   ├── CalendarView.swift
│   │   │   ├── MonthView.swift
│   │   │   ├── WeekView.swift
│   │   │   └── DayView.swift
│   │   ├── ViewModel/
│   │   │   ├── CalendarViewModel.swift
│   │   │   └── EventDetailViewModel.swift
│   │   └── Components/
│   │       ├── EventCell.swift
│   │       └── CalendarHeader.swift
│   ├── InputFeature/
│   │   ├── View/
│   │   │   ├── InputView.swift
│   │   │   ├── VoiceInputView.swift
│   │   │   └── EventConfirmView.swift
│   │   ├── ViewModel/
│   │   │   ├── InputViewModel.swift
│   │   │   └── VoiceInputViewModel.swift
│   │   └── Components/
│   │       └── InputField.swift
│   ├── RecapFeature/
│   │   ├── View/
│   │   │   ├── DailyPreviewView.swift
│   │   │   ├── WeeklyRecapView.swift
│   │   │   └── MonthlyRecapView.swift
│   │   ├── ViewModel/
│   │   │   ├── DailyPreviewViewModel.swift
│   │   │   ├── WeeklyRecapViewModel.swift
│   │   │   └── MonthlyRecapViewModel.swift
│   │   └── Components/
│   │       └── RecapCard.swift
│   ├── WidgetFeature/
│   │   ├── Widget/
│   │   │   ├── TodayEventsWidget.swift
│   │   │   └── EventsWidgetProvider.swift
│   │   └── Components/
│   │       └── WidgetEventRow.swift
│   └── SettingsFeature/
│       ├── View/
│       │   ├── SettingsView.swift
│       │   ├── NotificationSettingsView.swift
│       │   └── AppIconSettingsView.swift
│       ├── ViewModel/
│       │   └── SettingsViewModel.swift
│       └── Components/
│           └── SettingsRow.swift
└── Tests/
    └── FeatureTests/
```

## 타겟 구성

### 1. BaseFeature

모든 Feature의 기본 프로토콜 및 유틸리티 제공.

**ViewFactory**: `Sources/BaseFeature/ViewFactory/`
- ViewFactory.swift: View 생성 팩토리 프로토콜

**Utils**: `Sources/BaseFeature/Utils/`
- ViewModelProtocol.swift: ViewModel 공통 프로토콜

### 2. CalendarFeature

캘린더 화면 및 일정 관리 UI.

**View**: `Sources/CalendarFeature/View/`
- CalendarView.swift: 메인 캘린더 화면
- MonthView.swift: 월간 뷰
- WeekView.swift: 주간 뷰
- DayView.swift: 일간 뷰

**ViewModel**: `Sources/CalendarFeature/ViewModel/`
- CalendarViewModel.swift: 캘린더 상태 관리
- EventDetailViewModel.swift: 일정 상세 화면

**Components**: `Sources/CalendarFeature/Components/`
- EventCell.swift: 일정 셀
- CalendarHeader.swift: 캘린더 헤더

### 3. InputFeature

일정 입력 화면 (자연어, 음성).

**View**: `Sources/InputFeature/View/`
- InputView.swift: 텍스트 입력 화면
- VoiceInputView.swift: 음성 입력 화면
- EventConfirmView.swift: 파싱 결과 확인 화면

**ViewModel**: `Sources/InputFeature/ViewModel/`
- InputViewModel.swift: 입력 로직 관리
- VoiceInputViewModel.swift: 음성 입력 로직

**Components**: `Sources/InputFeature/Components/`
- InputField.swift: 입력 필드 컴포넌트

### 4. RecapFeature

데일리 프리뷰, 주간/월간 리캡 화면.

**View**: `Sources/RecapFeature/View/`
- DailyPreviewView.swift: 데일리 프리뷰 화면
- WeeklyRecapView.swift: 주간 리캡 화면
- MonthlyRecapView.swift: 월간 리캡 화면

**ViewModel**: `Sources/RecapFeature/ViewModel/`
- DailyPreviewViewModel.swift: 데일리 프리뷰 로직
- WeeklyRecapViewModel.swift: 주간 리캡 로직
- MonthlyRecapViewModel.swift: 월간 리캡 로직

**Components**: `Sources/RecapFeature/Components/`
- RecapCard.swift: 리캡 카드 컴포넌트

### 5. WidgetFeature

WidgetKit 위젯 구현.

**Widget**: `Sources/WidgetFeature/Widget/`
- TodayEventsWidget.swift: 오늘의 일정 위젯
- EventsWidgetProvider.swift: TimelineProvider 구현

**Components**: `Sources/WidgetFeature/Components/`
- WidgetEventRow.swift: 위젯 일정 행

### 6. SettingsFeature

설정 화면.

**View**: `Sources/SettingsFeature/View/`
- SettingsView.swift: 설정 메인 화면
- NotificationSettingsView.swift: 알림 설정
- AppIconSettingsView.swift: 앱 아이콘 설정

**ViewModel**: `Sources/SettingsFeature/ViewModel/`
- SettingsViewModel.swift: 설정 로직 관리

**Components**: `Sources/SettingsFeature/Components/`
- SettingsRow.swift: 설정 행 컴포넌트

## 의존성

- **Core**: 공통 유틸리티
- **DesignSystem**: UI 컴포넌트 및 디자인 리소스
- **Navigation**: 네비게이션 시스템
- **BaseFeature**: 모든 Feature가 BaseFeature에 의존
- **Domain**: 각 Feature는 필요한 Domain에만 의존
  - CalendarFeature → CalendarDomain
  - InputFeature → ParsingDomain
  - RecapFeature → RecapDomain
  - WidgetFeature → WidgetDomain

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 18+
- 의존성: Core, DesignSystem, Navigation, Domain
- Products: BaseFeature, CalendarFeature, InputFeature, RecapFeature, WidgetFeature, SettingsFeature

## 사용 가이드

### View 구현

**참고**: `Sources/{Feature}/View/` 디렉토리의 각 View 파일

### ViewModel 구현

**참고**: `Sources/{Feature}/ViewModel/` 디렉토리의 각 ViewModel 파일

### Components 사용

**참고**: `Sources/{Feature}/Components/` 디렉토리의 각 Component 파일
