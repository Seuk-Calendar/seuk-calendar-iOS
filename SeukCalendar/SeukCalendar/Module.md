# SeukCalendar App Module

앱 실행 진입점과 Widget Extension 연동을 담당하는 모듈입니다.

## 역할

- 앱 진입점(App life cycle) 관리
- CalendarFeature 화면 생성 및 의존성 조립
- Widget 딥링크 처리(`seukcalendar://schedule?...`)
- App Groups 기반 위젯 데이터 동기화

## 디렉토리 구조

```
SeukCalendar/
├── SeukCalendar.xcodeproj
├── SeukCalendar/
│   ├── SeukCalendarApp.swift
│   ├── ContentView.swift
│   └── App/
│       ├── Resources/
│       │   ├── Info.plist
│       │   └── SeukCalendar.entitlements
│       └── Widget/
│           ├── WidgetSharedConstants.swift
│           ├── WidgetScheduleSnapshotStore.swift
│           └── WidgetSyncingScheduleRepository.swift
└── SeukCalendarWidget/
    ├── Components/
    │   ├── WidgetBadge.swift
    │   ├── WidgetBadge+Configuration.swift
    │   ├── WidgetCalendarGrid.swift
    │   ├── WidgetCalendarGrid+Configuration.swift
    │   ├── WidgetCalendarWeekdayHeader.swift
    │   ├── WidgetCalendarWeekdayHeader+Configuration.swift
    │   ├── WidgetDayCell.swift
    │   ├── WidgetDayCell+Configuration.swift
    │   ├── WidgetSmallEvent.swift
    │   └── WidgetSmallEvent+Configuration.swift
    ├── SeukCalendarWidgetBundle.swift
    ├── SeukCalendarWidget+Calculate.swift
    ├── SeukCalendarWidget.swift
    ├── Info.plist
    ├── SeukCalendarWidget.entitlements
    └── SeukCalendarWidgetiOS.entitlements
```

## 타겟 구성

### 1. SeukCalendar (Application)

앱 본체 타겟.

- `ContentView.swift`
  - `WidgetSyncingScheduleRepository`를 사용해 일정 변경 시 위젯 스냅샷 동기화
  - `.onOpenURL`로 위젯 딥링크를 받아 초기 날짜/일정으로 진입
- `App/Resources/SeukCalendar.entitlements`
  - App Group 공유 저장소 사용
  - macOS sandbox에서 캘린더 접근을 위해 `com.apple.security.personal-information.calendars` entitlement 포함
- `App/Widget/WidgetScheduleSnapshotStore.swift`
  - App Group UserDefaults(`group.com.youngkyu.SeukCalendar`)에 위젯 스냅샷 저장
  - 저장 직후 `WidgetCenter.reloadTimelines` 호출

### 2. SeukCalendarWidget (Widget Extension)

WidgetKit extension 타겟.

- 지원 플랫폼
  - iOS
  - macOS
- 지원 패밀리
  - iOS: `systemSmall`, `systemMedium`, `systemLarge`, `accessoryCircular`, `accessoryRectangular`, `accessoryInline`
  - macOS: `systemSmall`, `systemMedium`, `systemLarge`
- TimelineProvider
  - App Group UserDefaults에서 스냅샷 로드
  - 일정 변경 시 앱에서 트리거된 reloadTimelines 반영
- 위젯 전용 컴포넌트
  - `Components/WidgetBadge.swift`, `Components/WidgetBadge+Configuration.swift`에서 일정 뱃지 레이아웃과 tinted/clear 대응 컬러를 관리
  - `Components/WidgetCalendarGrid.swift`, `Components/WidgetCalendarGrid+Configuration.swift`에서 5주 x 7일 캘린더 그리드와 divider 컬러를 관리
  - `Components/WidgetCalendarWeekdayHeader.swift`, `Components/WidgetCalendarWeekdayHeader+Configuration.swift`에서 locale 기반 요일 헤더와 tinted/clear 대응 컬러를 관리
  - `Components/WidgetDayCell.swift`, `Components/WidgetDayCell+Configuration.swift`에서 날짜 셀 상태와 today/더보기 컬러 계층을 관리
  - `Components/WidgetSmallEvent.swift`, `Components/WidgetSmallEvent+Configuration.swift`에서 small 위젯 일정 row 레이아웃과 컬러 계층을 관리
  - `SeukCalendarWidget+Calculate.swift`에서 위젯 날짜 계산과 large/medium 셀 매핑 로직을 분리 관리
- 딥링크
  - 일정 row 탭 시 `seukcalendar://schedule?date=yyyy-MM-dd&id=<schedule-id>` 오픈
- macOS 빌드 설정
  - `CODE_SIGN_ENTITLEMENTS[sdk=macosx*] = SeukCalendarWidget/SeukCalendarWidget.entitlements`
  - macOS sandbox + App Group 권한을 함께 사용

## 의존성

- App 타겟: AI, CalendarData, CalendarDomain, CalendarFeature
- Widget 타겟: WidgetKit, SwiftUI, Foundation
- 공유 저장소: App Groups (`group.com.youngkyu.SeukCalendar`)

## Xcode 프로젝트 설정

**위치**: `SeukCalendar/SeukCalendar.xcodeproj`

**주요 설정**:
- 타겟
  - `SeukCalendar` (Application)
  - `SeukCalendarWidget` (App Extension)
- App Group Entitlements
  - `SeukCalendar/App/Resources/SeukCalendar.entitlements`
  - `SeukCalendarWidget/SeukCalendarWidget.entitlements`
    - macOS widget extension sandbox와 App Group 공유 저장소 entitlement 포함
  - `SeukCalendarWidget/SeukCalendarWidgetiOS.entitlements`
    - iOS widget extension App Group entitlement 포함
