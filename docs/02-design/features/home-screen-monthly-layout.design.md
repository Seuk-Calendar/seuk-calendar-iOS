# home-screen-monthly-layout - Design Document

> Version: 1.0.0 | Date: 2026-06-01 | Status: Ready for Implementation
> Level: Starter | Plan: docs/01-plan/features/home-screen-monthly-layout.plan.md

---

## 1. Overview

홈 화면을 월간 캘린더 전용 구조로 재설계한다. 주간/일간 모드 전환을 제거하고, 월간 그리드는 화면 가용 높이에 맞춰 확장한다. 날짜 셀 탭 또는 캘린더 영역 상하 스와이프로 선택 날짜 상세 패널을 열고, 상세 패널 안에서 일정 목록과 AI 일정 추가 진입점을 제공한다.

핵심 설계 방향은 다음과 같다.

- 도메인과 데이터 레이어는 변경하지 않는다.
- `CalendarViewModel`은 월간 전용 상태와 기존 파싱/저장 UseCase를 유지한다.
- `CalendarView`는 화면 전용 상태를 직접 관리한다.
- `HomeCalendarComponent`는 확장형 일정 막대 표시와 압축형 점 indicator 표시를 모두 지원한다.

## 2. Architecture

### 2.1 Layer Scope

| Layer | 변경 여부 | 설계 |
|-------|-----------|------|
| Presentation | 변경 | `CalendarView`, `CalendarViewModel`, CalendarFeature 내부 UI 컴포넌트 재구성 |
| DesignSystem | 변경 | `HomeCalendarComponent`에 표시 모드와 행 높이 옵션 추가 |
| Domain | 유지 | `ParseEventUseCase`, `CreateScheduleUseCase`, `ParsedEvent`, `Schedule` 재사용 |
| Data | 유지 | `ScheduleRepository` 기존 구현 재사용 |
| Navigation | 유지 | 기존 `NavigationStack`과 `ScheduleDetailView` 이동 유지 |

### 2.2 Data Flow

```text
날짜 셀 탭
  -> CalendarView: detailPanelState = .presented
  -> CalendarViewModel.send(.selectDate(date))
  -> 필요 시 월간 visibleRange reload
  -> 상세 패널에서 viewModel.events(on: selectedDate) 표시

좌우 스와이프
  -> CalendarView gesture 판정
  -> CalendarViewModel.send(.movePeriod(offset))
  -> 월간 visibleRange reload

AI 일정 추가
  -> 상세 패널 AI 일정 추가 버튼
  -> 자연어 입력 오버레이 표시
  -> 확인 탭
  -> CalendarViewModel.send(.updateNaturalLanguageInput(text))
  -> CalendarViewModel.send(.parseNaturalLanguage)
  -> parsedEventDraft 생성
  -> 일정 등록 시트 표시
  -> 사용자가 수정 후 저장
  -> CalendarViewModel.send(.saveParsedEvent)
  -> CreateScheduleUseCase.execute
  -> reloadVisibleEvents
```

## 3. Page Structure

### 3.1 Root Layout

`CalendarView`는 기존 전체 `ScrollView` 구조를 제거하고, `GeometryReader` 기반의 고정 화면 구조로 변경한다.

```text
NavigationStack
  ZStack(alignment: .bottom)
    VStack(spacing: 0)
      Header 영역
        - 월 타이틀
        - 이전/다음/오늘/새로고침 액션
        - 권한/동기화 메시지
      Calendar 영역
        - HomeCalendarComponent
        - 좌우/상하 스와이프 gesture
    if detailPanelState == .presented
      SelectedDateDetailPanel
    if aiInputState == .presented
      NaturalLanguageInputOverlay
  .sheet(isPresented: parsedEventEditorSheet)
    ParsedEventEditorSheet
```

### 3.2 Expanded State

기본 상태에서는 상세 패널이 닫혀 있고 캘린더가 헤더를 제외한 화면을 채운다.

- `HomeCalendarComponent.DisplayMode.expanded`
- 일정 제목 막대/배지 표시
- 5주/6주 월 모두 동일하게 가용 높이 안에서 균등 배치
- 날짜 셀 탭 시 선택 날짜 변경 후 상세 패널 열림

### 3.3 Detail State

상세 패널 열린 상태에서는 하단 50%를 상세 패널이 차지한다.

- 하단 패널 높이: `geometry.size.height * 0.5`
- 캘린더는 상단 50% 영역 안에서 압축 표시
- `HomeCalendarComponent.DisplayMode.compactIndicator`
- 일정 제목 막대는 숨김
- 날짜별 일정 존재 여부는 점 indicator로 표시
- 핸들바 영역은 고정
- 패널 컨텐츠 영역은 `ScrollView`

## 4. UI Components

### 4.1 CalendarView

변경 책임:

- 월/주/일 분기 제거
- `modePicker`, `weekContent`, `dayContent`, `modeBinding` 제거
- `aiParsingSection` inline 영역 제거
- 상세 패널, AI 입력 오버레이, 일정 등록 시트 상태 관리
- 캘린더 영역 전용 제스처 처리

권장 상태:

```swift
private enum DetailPanelState: Equatable {
  case hidden
  case presented
}

private enum AIInputOverlayState: Equatable {
  case hidden
  case presented
}

@State private var detailPanelState: DetailPanelState = .hidden
@State private var aiInputOverlayState: AIInputOverlayState = .hidden
@State private var isParsedEventEditorPresented = false
@State private var aiInputDraft = ""
```

### 4.2 SelectedDateDetailPanel

위치 후보:

- `SeukCalendar/Feature/CalendarFeature/Calendar/Components/SelectedDateDetailPanel.swift`

역할:

- 선택 날짜 제목 표시
- `AI 일정 추가` 버튼 표시
- 선택 날짜 일정 목록 표시
- 빈 상태 표시
- 일정 카드 탭 시 `openScheduleDetail(_:)` 호출
- 패널 상단 핸들바와 닫기 드래그 처리

입력:

```swift
struct SelectedDateDetailPanel: View {
  let selectedDate: Date
  let events: [CalendarEvent]
  let height: CGFloat
  let onClose: () -> Void
  let onTapAIAdd: () -> Void
  let onTapEvent: (CalendarEvent) -> Void
}
```

구조:

```text
VStack(spacing: 0)
  HandleBar 영역
    - Capsule handle
    - drag down gesture
  ScrollView
    Header
      - "M. d. E" 날짜
    AI 일정 추가 Button
    Event list or empty state
```

### 4.3 NaturalLanguageInputOverlay

위치 후보:

- `SeukCalendar/Feature/CalendarFeature/Calendar/Components/NaturalLanguageInputOverlay.swift`

역할:

- 전체 화면 딤 처리
- 자연어 일정 입력
- 취소/확인 버튼
- 파싱 오류 메시지 표시
- 확인 중 로딩 상태 표시

입력:

```swift
struct NaturalLanguageInputOverlay: View {
  @Binding var text: String
  let isLoading: Bool
  let errorMessage: String?
  let onCancel: () -> Void
  let onConfirm: () -> Void
}
```

요구 placeholder:

```text
예: 다음주 화요일 오후 2시에 강남역에서 클라이언트 미팅
```

동작:

- 취소: `aiInputDraft = ""`, `viewModel.send(.clearParsedEvent)`, overlay 닫기
- 확인: 입력이 비어 있으면 비활성화
- 파싱 성공: overlay 닫기, 일정 등록 시트 열기
- 파싱 실패: overlay 유지, 오류 메시지 표시

### 4.4 ParsedEventEditorSheet

위치 후보:

- `SeukCalendar/Feature/CalendarFeature/Calendar/Components/ParsedEventEditorSheet.swift`

역할:

- 기존 `parsedEventEditorCard`를 시트 전용 UI로 이동
- AI 분석 결과를 수정 가능한 폼으로 표시
- 저장 성공 시 시트 닫기

입력:

```swift
struct ParsedEventEditorSheet: View {
  let draft: CalendarViewModel.ParsedEventDraft?
  let isSaving: Bool
  let errorMessage: String?
  let onUpdateTitle: (String) -> Void
  let onUpdateDateString: (String) -> Void
  let onUpdateStartTime: (String) -> Void
  let onUpdateDurationMinutes: (String) -> Void
  let onUpdateLocation: (String) -> Void
  let onUpdateNotes: (String) -> Void
  let onUpdateIsAllDay: (Bool) -> Void
  let onAddAlarm: (CalendarViewModel.AlarmPreset) -> Void
  let onRemoveAlarm: (Int) -> Void
  let onCancel: () -> Void
  let onSave: () -> Void
}
```

저장 후 닫기 판정:

- `await viewModel.send(.saveParsedEvent).value`
- 저장 성공 시 `viewModel.parsedEventDraft == nil`
- 이 조건이면 `isParsedEventEditorPresented = false`
- 실패 시 `parseErrorMessage`를 시트에 표시하고 시트는 유지

## 5. DesignSystem Design

### 5.1 HomeCalendarComponent DisplayMode

`HomeCalendarComponent`에 표시 모드를 추가한다.

```swift
public extension HomeCalendarComponent {
  enum DisplayMode: Hashable, Sendable {
    case expanded
    case compactIndicator
  }
}
```

생성자 확장:

```swift
public init(
  month: Date,
  selectedDate: Date,
  eventsByDay: [Date: [CalendarEvent]],
  calendar: Calendar = .current,
  showsMonthBar: Bool = true,
  displayMode: DisplayMode = .expanded,
  weekRowHeight: CGFloat? = nil,
  today: Date = Date(),
  eventListener: EventListener? = nil
)
```

설계 원칙:

- 기본값은 `.expanded`로 두어 기존 호출부 호환성을 유지한다.
- `weekRowHeight == nil`이면 기존 intrinsic layout을 유지한다.
- `CalendarView`만 가용 높이를 계산해 `weekRowHeight`를 전달한다.

### 5.2 Compact Indicator

압축형에서는 `HomeCalendarComponentDayCell`이 일정 막대 대신 점을 표시한다.

점 개수:

```swift
let eventCount = day.badges.count + day.hiddenBadgeCount
let dotCount = min(eventCount, 3)
```

표시 규칙:

- 일정이 없으면 점을 표시하지 않는다.
- 점은 날짜 숫자 아래 중앙 정렬한다.
- 현재 월 외 날짜는 기존 흐림 색상 규칙을 따른다.
- 선택 날짜와 오늘 표시 규칙은 기존 DateCell 규칙을 최대한 유지한다.

### 5.3 Week Row Height

`HomeCalendarComponentWeekView`는 표시 모드에 따라 높이를 결정한다.

```swift
let resolvedHeight: CGFloat? = weekRowHeight
```

설계:

- expanded + `weekRowHeight`: 날짜 행, 배지 행, hidden count 영역을 지정 높이에 맞춰 배치
- compactIndicator + `weekRowHeight`: 날짜 숫자와 점 indicator를 지정 높이에 맞춰 중앙 위주로 배치
- 기존 고정 높이 계산은 `weekRowHeight == nil`인 경우 fallback으로 유지

## 6. ViewModel Design

### 6.1 ViewMode 제거

삭제 대상:

- `CalendarViewModel.ViewMode`
- `viewMode` 저장 프로퍼티
- `init(viewMode:)` 파라미터
- `Action.changeMode`
- `handleChangeMode(_:)`
- `shouldReloadAfterSelectingDate`의 주/일 분기

월간 전용으로 단순화:

```swift
public var titleText: String {
  let formatter = DateFormatter()
  formatter.locale = Locale.current
  formatter.dateFormat = "yyyy. M."
  return formatter.string(from: selectedDate)
}
```

월간 범위:

```swift
func visibleRange() -> DateInterval {
  guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate),
        let start = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)?.start,
        let monthEndMinusOne = calendar.date(byAdding: .second, value: -1, to: monthInterval.end),
        let end = calendar.dateInterval(of: .weekOfYear, for: monthEndMinusOne)?.end
  else {
    return DateInterval(start: selectedDate, duration: 0)
  }
  return DateInterval(start: start, end: end)
}
```

월 이동:

```swift
func moveReferenceDate(by offset: Int) {
  guard offset != 0 else { return }
  selectedDate = calendar.date(byAdding: .month, value: offset, to: selectedDate)
    .map(calendar.startOfDay(for:)) ?? selectedDate
}
```

날짜 선택 후 reload 조건:

```swift
func shouldReloadAfterSelectingDate(from previousDate: Date, to currentDate: Date) -> Bool {
  !calendar.isDate(previousDate, equalTo: currentDate, toGranularity: .month)
}
```

### 6.2 AI Flow Reuse

기존 상태를 유지한다.

- `naturalLanguageInput`
- `parsedEventDraft`
- `parseErrorMessage`
- `parserStatusMessage`
- `isParsingNaturalLanguage`
- `isSavingParsedEvent`

기존 액션을 유지한다.

- `updateNaturalLanguageInput`
- `parseNaturalLanguage`
- `clearParsedEvent`
- `updateParsedTitle`
- `updateParsedDateString`
- `updateParsedStartTime`
- `updateParsedDurationMinutes`
- `addParsedAlarm`
- `removeParsedAlarm`
- `clearParsedAlarms`
- `updateParsedLocation`
- `updateParsedNotes`
- `updateParsedIsAllDay`
- `saveParsedEvent`

변경점:

- 기존 inline `aiParsingSection`에서 사용하던 상태와 액션을 오버레이/시트에서 사용한다.
- 파싱 reference date는 계속 `selectedDate`를 사용한다.
- 저장 성공 후 `reloadVisibleEvents()`를 유지한다.

## 7. Gesture Design

### 7.1 Calendar Area Gesture

캘린더 영역에만 드래그 제스처를 연결한다. 전체 화면에 연결하지 않아 상세 패널 스크롤과 충돌을 줄인다.

판정 기준:

```swift
let dx = value.translation.width
let dy = value.translation.height
let horizontal = abs(dx)
let vertical = abs(dy)

if horizontal > vertical, horizontal > 70 {
  moveMonth(dx < 0 ? 1 : -1)
}

if vertical > horizontal, vertical > 60 {
  if dy < 0 {
    openDetailPanel()
  } else {
    closeDetailPanel()
  }
}
```

### 7.2 Detail Panel Gesture

상세 패널 닫기 드래그는 핸들바 영역에 우선 적용한다.

- 핸들바 아래 드래그가 40pt 이상이면 닫기
- 컨텐츠 ScrollView에는 닫기 제스처를 직접 붙이지 않는다.
- 사용자가 컨텐츠를 스크롤하는 동작과 패널 닫기 동작을 분리한다.

## 8. Data Model

### 8.1 Existing Domain Models

새 도메인 모델은 추가하지 않는다.

| Model | 사용 목적 |
|-------|-----------|
| `CalendarEvent` | 캘린더 표시 및 상세 이동 |
| `ParsedEvent` | AI 분석 결과 |
| `CalendarViewModel.ParsedEventDraft` | 사용자가 수정 가능한 일정 초안 |
| `Schedule` | 저장 대상 도메인 일정 |
| `ScheduleAlarm` | 일정 알림 |

### 8.2 UI State Models

UI 전용 상태는 `CalendarView` 또는 Feature 내부 컴포넌트에 둔다.

```swift
private enum DetailPanelState: Equatable {
  case hidden
  case presented
}

private enum AIInputOverlayState: Equatable {
  case hidden
  case presented
}
```

이 상태는 도메인 의미가 없으므로 `CalendarViewModel`에 넣지 않는다.

## 9. API Spec

### 9.1 External API

외부 API 변경 없음.

### 9.2 Repository

`ScheduleRepository` 계약 변경 없음.

사용되는 기존 메서드:

- `fetchSchedules(in:)`
- `create(schedule:)`
- `fetchAuthorizationStatus()`
- `requestAccess()`
- `observeScheduleChanges()`
- `hasICloudCalendar()`

### 9.3 DesignSystem Public API

변경 대상:

- `HomeCalendarComponent.DisplayMode` 추가
- `HomeCalendarComponent` 생성자에 `displayMode`, `weekRowHeight` 파라미터 추가

기존 호출부는 기본값으로 동작해야 한다.

## 10. Accessibility

- 날짜 셀 accessibility label에는 날짜와 일정 개수를 포함한다.
- 예: `6월 3일, 일정 2개`
- 상세 패널 핸들바에는 `일정 상세 닫기` 라벨을 제공한다.
- `AI 일정 추가` 버튼은 명확한 button trait를 유지한다.
- 자연어 입력 오버레이가 열리면 입력 필드로 포커스 이동을 고려한다.
- 로딩 중에는 확인/저장 버튼을 비활성화한다.
- 파싱 실패 메시지는 `.accessibilityLiveRegion` 또는 동등한 방식으로 읽히도록 검토한다.

## 11. Implementation Order

1. `HomeCalendarComponent`에 `DisplayMode`와 `weekRowHeight` 옵션을 추가한다.
2. `HomeCalendarComponentDayCell`에 compact indicator 점 표시를 추가한다.
3. `HomeCalendarComponentWeekView`가 표시 모드와 행 높이를 전달받도록 변경한다.
4. `CalendarViewModel`에서 `ViewMode`와 `changeMode` 흐름을 제거하고 월간 전용으로 단순화한다.
5. `CalendarView`에서 전체 `ScrollView`, mode picker, week/day content, inline AI 파싱 섹션을 제거한다.
6. `CalendarView`에 `GeometryReader` 기반 월간 캘린더 레이아웃을 구성한다.
7. 날짜 셀 탭 시 `selectDate`와 상세 패널 열림을 동시에 처리한다.
8. 캘린더 영역 좌우/상하 스와이프 판정 로직을 적용한다.
9. `SelectedDateDetailPanel`을 추가하고 50% 높이, 고정 핸들바, 스크롤 컨텐츠를 구현한다.
10. `NaturalLanguageInputOverlay`를 추가한다.
11. `ParsedEventEditorSheet`를 추가하고 기존 `parsedEventEditorCard` 바인딩 로직을 시트로 이동한다.
12. 저장 성공 후 시트 닫기와 선택 날짜 일정 목록 갱신 흐름을 연결한다.
13. `SeukCalendar/Feature/Module.md`를 업데이트한다.
14. DesignSystem 공개 API 변경 시 `SeukCalendar/DesignSystem/Module.md`를 업데이트한다.

## 12. Test Plan

### 12.1 Unit Level

- `CalendarViewModel.titleText`가 월간 타이틀 형식으로 반환되는지 검증한다.
- `movePeriod(1)`이 다음 월로 이동하는지 검증한다.
- `movePeriod(-1)`이 이전 월로 이동하는지 검증한다.
- 다른 월 날짜 선택 시 `reloadVisibleEvents()`가 호출되는지 검증한다.
- 같은 월 날짜 선택 시 불필요한 reload가 발생하지 않는지 검증한다.
- 파싱 성공 시 `parsedEventDraft`가 생성되는지 검증한다.
- 저장 성공 시 `parsedEventDraft`가 nil이 되고 일정 목록 reload가 수행되는지 검증한다.

### 12.2 Component Level

- expanded 모드에서 일정 막대/배지가 표시되는지 확인한다.
- compactIndicator 모드에서 일정 점 indicator가 표시되는지 확인한다.
- `weekRowHeight` 전달 시 5주/6주 월 모두 가용 높이에 맞게 배치되는지 확인한다.
- 날짜 셀 tap action이 기존처럼 전달되는지 확인한다.

### 12.3 Manual QA

- 홈 화면에 월/주/일 세그먼트가 보이지 않는다.
- 기본 상태에서 월간 캘린더가 헤더 아래 영역을 채운다.
- 좌우 스와이프가 월 이동으로 동작한다.
- 날짜 셀 탭 시 상세 패널이 열린다.
- 캘린더 위로 스와이프 시 상세 패널이 열린다.
- 캘린더 아래로 스와이프 시 상세 패널이 닫힌다.
- 상세 패널 높이가 화면 하단 50% 수준으로 유지된다.
- 상세 패널 컨텐츠는 스크롤되고 핸들바는 고정된다.
- 상세 패널 일정 카드 탭 시 기존 상세 화면으로 이동한다.
- `AI 일정 추가` 버튼으로 딤 오버레이가 열린다.
- 취소 버튼으로 오버레이가 닫히고 입력이 폐기된다.
- 확인 버튼으로 분석 후 일정 등록 시트가 열린다.
- 시트 필드가 AI 분석 결과로 프리필된다.
- 저장 성공 후 시트가 닫히고 일정 목록이 갱신된다.
- 파싱 실패 시 오버레이가 닫히지 않고 오류가 표시된다.

### 12.4 Build Verification

권장 검증:

```bash
xcodebuild -project SeukCalendar/Feature/Feature.xcodeproj -scheme CalendarFeature -destination 'platform=iOS Simulator,name=iPhone 16' build
```

프로젝트 scheme 또는 Simulator 이름이 환경과 다르면 사용 가능한 scheme/destination 확인 후 조정한다.

## 13. Documentation Updates

구현 시 문서 업데이트가 필요하다.

- `SeukCalendar/Feature/Module.md`: CalendarFeature가 월간 전용 홈 화면, 상세 패널, AI 일정 추가 플로우를 가진다는 설명으로 갱신
- `SeukCalendar/DesignSystem/Module.md`: `HomeCalendarComponent`의 `DisplayMode`, `weekRowHeight`, compact indicator 옵션 추가 설명

아키텍처 레이어 또는 의존성 변경은 없으므로 `.agents/rules/Architecture.md` 업데이트는 필요하지 않다.

## 14. Risks

| Risk | Mitigation |
|------|------------|
| 캘린더 행 높이 계산이 DesignSystem 내부 고정 높이와 충돌 | `weekRowHeight` nil fallback을 유지하고 홈 화면에서만 명시 높이를 전달 |
| 상세 패널 ScrollView와 닫기 제스처 충돌 | 닫기 제스처는 핸들바 영역 위주로 제한 |
| 파싱 오버레이와 등록 시트가 동시에 표시됨 | 파싱 성공 후 overlay를 먼저 닫고 다음 run loop에서 sheet를 연다 |
| 기존 inline AI 파싱 UI 제거 중 바인딩 누락 | 기존 binding helper를 시트 컴포넌트 입력으로 이동 |
| ViewMode 제거 후 남은 참조로 빌드 실패 | `rg "ViewMode|changeMode|modePicker|weekContent|dayContent"`로 제거 검증 |
