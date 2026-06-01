# home-screen-monthly-layout - Plan Document

> Version: 1.0.0 | Date: 2026-06-01 | Status: Ready for Design
> Level: Starter

---

## 1. Overview

### 1.1 Purpose

홈 화면의 캘린더를 월간 레이아웃 중심으로 재구성한다. 주간/일간 레이아웃 전환을 제거하고, 월간 캘린더 영역을 상단 타이틀 및 요일 헤더를 제외한 가용 화면에 맞게 확장한다. 선택 날짜의 일정 상세 정보는 날짜 셀 탭 또는 캘린더 영역의 상하 스와이프 제스처로 열고 닫을 수 있게 한다.

### 1.2 Background

현재 `CalendarView`는 `CalendarViewModel.ViewMode`를 기준으로 월/주/일 레이아웃을 분기하며, 월간 화면에서는 `HomeCalendarComponent` 아래에 선택 날짜 일정 목록과 AI 파싱 섹션이 이어지는 스크롤 구조를 사용한다.

요구사항은 홈 화면을 월간 캘린더 고정 경험으로 단순화하고, 이미지 레퍼런스처럼 다음 두 상태를 지원하는 방향이다.

- 기본 상태: 월간 캘린더가 화면 대부분을 채우고, 날짜별 일정은 막대/배지 형태로 표시된다.
- 상세 상태: 선택된 날짜의 일정 상세 패널이 하단에 표시되고, 캘린더는 상단에 압축되어 날짜별 일정 존재 여부를 점으로 표현한다.

## 2. Goals

### 2.1 Primary Goals

- [ ] 주간/일간 레이아웃 전환 UI와 관련 분기 로직을 제거한다.
- [ ] 홈 화면은 월간 레이아웃만 표시한다.
- [ ] 월간 캘린더 영역은 상단 타이틀 및 요일 헤더를 제외한 화면 높이를 채우도록 구성한다.
- [ ] 캘린더 영역에서 좌우 스와이프로 이전/다음 월 이동을 지원한다.
- [ ] 날짜 셀을 탭하면 해당 날짜가 선택되고 선택 날짜 일정 상세 패널이 열린다.
- [ ] 캘린더 영역에서 상하 스와이프로 선택 날짜 일정 상세 패널을 열고 닫는다.
- [ ] 상세 패널이 열린 상태에서는 레퍼런스 이미지처럼 선택 날짜와 일정 목록/빈 상태를 표시한다.
- [ ] 상세 패널 내 일정 목록 위에 `AI 일정 추가` 버튼을 제공한다.
- [ ] `AI 일정 추가` 버튼으로 자연어 입력 오버레이를 열고, 분석 결과를 일정 등록 시트에 프리필한다.
- [ ] 기존 일정 조회, 선택 날짜 변경, 일정 상세 진입 기능은 유지한다.

### 2.2 Non-Goals

- 캘린더 권한 요청, iCloud 동기화, EventKit 저장 로직을 변경하지 않는다.
- 자연어 AI 파싱 모델 자체의 품질 개선은 포함하지 않는다.
- 새로운 아키텍처 레이어나 외부 라이브러리를 도입하지 않는다.

## 3. Scope

### 3.1 In Scope

- `CalendarView` 홈 화면 레이아웃 재구성
- `CalendarViewModel.ViewMode` 제거 또는 월간 전용 상태로 축소
- `CalendarViewModel.Action.changeMode` 제거
- `visibleRange()`, `moveReferenceDate(by:)`, `titleText`의 월간 전용 단순화
- 월간 캘린더 좌우 스와이프 제스처 범위 조정
- 선택 날짜 상세 패널 표시 상태 추가
- 날짜 셀 탭 시 선택 날짜 변경 및 상세 패널 열기
- 하단 상세 패널 50% 높이 고정 상태 정의
- 상세 패널 핸들바 고정 및 컨텐츠 스크롤 구조 정의
- 상세 패널 내 선택 날짜 일정 목록/빈 상태 표시
- 상세 패널 내 `AI 일정 추가` 버튼 추가
- 자연어 입력 전체화면 딤 오버레이 추가
- AI 분석 결과 기반 일정 등록 시트 프리필 연결
- `HomeCalendarComponent`의 확장형/압축형 표현 지원 검토
- 기존 `ScheduleDetailView` 진입 유지

### 3.2 Out of Scope

- EventKit Repository/API 변경
- 자연어 AI 파싱 품질 개선
- 위젯 UI 변경
- 신규 알림 프리셋 추가
- 앱 전체 네비게이션 구조 변경

## 4. Functional Requirements

### 4.1 월간 레이아웃 고정

- 홈 화면에서 월/주/일 세그먼트 컨트롤을 제거한다.
- `CalendarWeekView`, `CalendarDayView`를 홈 화면 본문에서 더 이상 사용하지 않는다.
- 날짜 선택은 월간 그리드에서 수행한다.
- 날짜 셀을 탭하면 해당 날짜를 `selectedDate`로 변경하고 상세 패널을 연다.
- 월 이동은 기존 `movePeriod(_:)` 의미를 월 단위 이동으로 고정한다.

### 4.2 화면 채움 레이아웃

- 홈 화면은 상단 네비게이션/월 타이틀/요일 헤더를 제외한 영역을 캘린더 본문으로 채운다.
- 기본 상태에서는 캘린더가 5~6주 월간 그리드를 가용 높이에 균등 배분한다.
- 하단 상세 패널과 Safe Area를 고려해 컨텐츠가 잘리지 않도록 한다.
- 기존처럼 `ScrollView` 안에 전체 홈 화면을 넣는 구조는 재검토한다. 월간 캘린더 고정 + 하단 패널 구조에는 `GeometryReader`, `ZStack`, 명시적 높이 계산이 더 적합하다.

### 4.3 좌우 스와이프

- 캘린더 영역에서 수평 이동량이 수직 이동량보다 크고 임계값을 넘으면 이전/다음 월로 이동한다.
- 좌측 스와이프는 다음 월, 우측 스와이프는 이전 월로 이동한다.
- 상세 패널이 열린 상태에서도 캘린더 영역의 좌우 스와이프는 월 이동으로 동작한다.
- 스와이프 충돌을 피하기 위해 수평/수직 제스처 판정 임계값을 분리한다.

### 4.4 날짜 선택 및 상세 패널

- 날짜 셀을 누르면 해당 날짜가 선택되고 상세 패널을 연다.
- 선택 날짜가 있는 상태에서 캘린더 영역을 위로 스와이프하면 상세 패널을 연다.
- 아래로 스와이프하면 상세 패널을 닫는다.
- 상세 패널은 화면 하단 50% 높이로 고정한다.
- 패널 상단에는 고정된 핸들바 영역을 표시한다.
- 패널 컨텐츠 영역은 스크롤 가능해야 한다.
- 핸들바 영역 또는 패널 상단 드래그로 닫을 수 있어야 한다.
- 패널에는 선택 날짜와 일정 목록 또는 빈 상태를 표시한다.
- 일정 항목 탭 시 기존 `ScheduleDetailView`로 진입한다.

### 4.5 월간 캘린더 표현 상태

- 기본 상태는 일정 제목 막대/배지를 보여주는 확장형 월간 캘린더를 사용한다.
- 상세 패널 열린 상태는 날짜별 일정 존재 여부를 점으로 보여주는 압축형 월간 캘린더를 검토한다.
- 압축형은 일정 제목을 모두 노출하지 않고, 일정 개수/종류를 점 또는 간단한 indicator로 축약한다.

### 4.6 AI 일정 추가 플로우

- 상세 패널 내 일정 목록 위에 `AI 일정 추가` 버튼을 표시한다.
- `AI 일정 추가` 버튼을 누르면 전체화면 딤 처리 오버레이를 표시한다.
- 오버레이에는 취소 버튼, 확인 버튼, 자연어 텍스트 입력 영역을 제공한다.
- 텍스트 입력 placeholder는 `예: 다음주 화요일 오후 2시에 강남역에서 클라이언트 미팅`으로 표시한다.
- 취소를 누르면 입력 내용을 폐기하고 오버레이를 닫는다.
- 확인을 누르면 자연어 입력을 AI 분석하고, 분석 결과를 기반으로 일정 등록 시트를 연다.
- 일정 등록 시트는 제목, 날짜, 시간, 장소, 메모, 알림 등 기존 저장에 필요한 값을 프리필한다.
- 사용자가 최종 수정 후 저장하면 일정이 등록되고 시트가 닫힌다.
- 저장 성공 후 선택 날짜 일정 목록을 갱신한다.

## 5. Non-Functional Requirements

- iOS 18+ SwiftUI에서 동작해야 한다.
- 기존 Clean Architecture와 MVVM 구조를 유지한다.
- 디자인 수정은 `DesignSystem` 컴포넌트/토큰 사용 원칙을 따른다.
- VoiceOver 접근성 라벨을 날짜 선택, 월 이동, 상세 패널 열림/닫힘에 제공한다.
- 월 이동 및 패널 스와이프 애니메이션은 끊김 없이 동작해야 한다.
- 월간 이벤트 데이터 로딩 범위는 기존 월간 범위를 유지해 불필요한 EventKit 호출을 늘리지 않는다.

## 6. Success Criteria

- [ ] 홈 화면에서 주간/일간 레이아웃 변경 UI가 보이지 않는다.
- [ ] 홈 화면은 항상 월간 캘린더 레이아웃으로 렌더링된다.
- [ ] 상단 타이틀/요일 헤더 아래 캘린더 본문이 화면 높이를 채운다.
- [ ] 좌우 스와이프로 월 이동이 가능하다.
- [ ] 날짜 셀 탭 시 해당 날짜가 선택되고 상세 패널이 열린다.
- [ ] 상하 스와이프로 선택 날짜 일정 상세 패널을 열고 닫을 수 있다.
- [ ] 상세 패널은 화면 하단 50% 높이로 표시된다.
- [ ] 상세 패널 핸들바는 고정되고 컨텐츠는 스크롤된다.
- [ ] 상세 패널의 빈 상태가 "일정이 없습니다."로 표시된다.
- [ ] 상세 패널의 `AI 일정 추가` 버튼으로 자연어 입력 오버레이가 열린다.
- [ ] 자연어 입력 확인 후 일정 등록 시트가 분석 결과로 프리필된다.
- [ ] 일정 저장 후 시트가 닫히고 선택 날짜 일정 목록이 갱신된다.
- [ ] 일정 항목 탭 시 기존 일정 상세 화면으로 이동한다.
- [ ] 권한 거부/로딩/동기화 상태 메시지가 기존보다 숨겨지거나 접근 불가능해지지 않는다.
- [ ] iPhone 세로 화면에서 레퍼런스 이미지와 동일한 정보 구조를 가진다.

## 7. Architecture Considerations

### 7.1 Presentation Layer

- 주요 변경 대상은 `SeukCalendar/Feature/CalendarFeature/Calendar/CalendarView.swift`와 `CalendarViewModel` 계열 파일이다.
- `CalendarView`는 월간 전용 화면으로 단순화한다.
- 상세 패널 열림 상태는 UI-only 상태이므로 우선 `CalendarView`의 `@State`로 보유한다.
- AI 일정 추가 오버레이 표시 상태와 일정 등록 시트 표시 상태도 UI-only 상태로 시작한다.
- 월 이동/날짜 선택/일정 로딩은 기존 `CalendarViewModel`의 책임으로 유지한다.
- 자연어 파싱과 일정 저장은 기존 `CalendarViewModel`의 파싱/저장 액션을 재사용하되, 입력 오버레이와 등록 시트 흐름에 맞게 UI 상태를 분리한다.

### 7.2 DesignSystem

- `HomeCalendarComponent`가 확장형/압축형 월간 표현을 모두 담당할지, 홈 화면 전용 wrapper에서 압축형을 구현할지 설계 단계에서 결정한다.
- 재사용성이 필요한 경우 `HomeCalendarComponent.Configuration`에 표시 밀도 또는 display mode를 추가한다.
- 단발성 홈 전용 표현이면 `CalendarFeature` 내부 컴포넌트로 시작해 DesignSystem 확장을 최소화한다.

### 7.3 Documentation

- `CalendarViewModel.ViewMode` 제거 및 홈 화면 구조 변경이 확정되면 `SeukCalendar/Feature/Module.md`의 CalendarFeature 설명 업데이트가 필요하다.
- DesignSystem 공개 API를 변경하면 `SeukCalendar/DesignSystem/Module.md` 업데이트가 필요하다.
- 아키텍처 레이어/의존성 변경은 없으므로 현재 계획만으로 `.agents/rules/Architecture.md` 업데이트는 필요하지 않다.

## 8. Schedule

| Phase | Target Date | Status |
|-------|-------------|--------|
| Plan | 2026-06-01 | Done |
| Design | TBD | Pending |
| Implementation | TBD | Pending |
| Review | TBD | Pending |

## 9. Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| 수평/수직 스와이프 충돌 | 월 이동 또는 패널 열림이 오작동할 수 있음 | Medium | translation 축 우선순위와 임계값을 명확히 분리 |
| 5주/6주 월 높이 차이 | 월별 레이아웃 흔들림 발생 | Medium | 주 수와 관계없이 가용 높이에 균등 배치하거나 최소/최대 높이 정의 |
| 상세 패널 내부 스크롤과 닫기 제스처 충돌 | 컨텐츠 스크롤 중 패널이 의도치 않게 닫힐 수 있음 | Medium | 핸들바 중심 닫기 제스처와 컨텐츠 스크롤 영역을 분리 |
| AI 입력 오버레이와 등록 시트 상태 충돌 | 오버레이/시트가 중첩되거나 입력이 유실될 수 있음 | Medium | 오버레이 닫힘 후 시트 열림 순서를 명시하고 단일 상태 enum 검토 |
| DesignSystem API 과확장 | 재사용성 낮은 옵션이 공용 컴포넌트에 누적 | Medium | 홈 전용 wrapper 우선 검토 후 공용화 |
| 기존 주/일 뷰 제거 범위 누락 | 죽은 코드 또는 테스트 실패 발생 | Low | `ViewMode`, `changeMode`, `CalendarWeekView`, `CalendarDayView` 참조를 `rg`로 검증 |

## 10. Resolved Decisions

- 상세 패널 열린 상태의 캘린더는 일정 제목 막대 대신 점 indicator 중심의 압축형으로 전환한다.
- 기존 홈 화면의 `AI 일정 파싱` 섹션은 제거하고, 상세 패널 내 `AI 일정 추가` 버튼으로 진입한다.
- 상세 패널 높이는 화면 하단 50%로 고정한다.
- 상세 패널의 핸들바 영역은 고정하고, 컨텐츠 영역은 스크롤 가능하게 한다.
- 날짜 셀 탭은 날짜 선택과 상세 패널 열기를 동시에 수행한다.

## 11. References

- User-provided reference image 1: 월간 캘린더 확장 상태
- User-provided reference image 2: 선택 날짜 상세 패널 열린 상태 및 점 indicator 압축형 캘린더
- `.agents/rules/Architecture.md`
- `.agents/rules/design-guide.md`
- `SeukCalendar/Feature/Module.md`
- `SeukCalendar/DesignSystem/Module.md`
- `SeukCalendar/Feature/CalendarFeature/Calendar/CalendarView.swift`
- `SeukCalendar/Feature/CalendarFeature/Calendar/CalendarViewModel.swift`
- `SeukCalendar/DesignSystem/DesignSystem/Components/Tier1/HomeCalendarComponent/HomeCalendarComponent.swift`
