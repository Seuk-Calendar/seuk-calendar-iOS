# home-screen-monthly-layout - Do Tracking

> Date: 2026-06-01 | Phase: Do | Status: In Progress

## Implementation Checklist

- [x] `HomeCalendarComponent`에 `DisplayMode`와 `weekRowHeight` 옵션 추가
- [x] `HomeCalendarComponentDayCell`에 compact 점 indicator 표시 추가
- [x] `HomeCalendarComponentWeekView`에 표시 모드와 행 높이 전달
- [x] `CalendarViewModel`을 월간 전용으로 단순화
- [x] `CalendarView`에서 주간/일간 분기와 inline AI 파싱 섹션 제거
- [x] `CalendarView`에 GeometryReader 기반 월간 레이아웃 구성
- [x] 날짜 셀 탭 시 선택 날짜 변경 및 상세 패널 열기 연결
- [x] 캘린더 영역 좌우/상하 스와이프 처리
- [x] `SelectedDateDetailPanel` 추가
- [x] `NaturalLanguageInputOverlay` 추가
- [x] `ParsedEventEditorSheet` 추가
- [x] 저장 성공 후 시트 닫기 및 일정 목록 갱신 연결
- [x] Feature/DesignSystem 모듈 문서 업데이트
- [x] SwiftFormat 적용
- [x] 빌드 검증
- [x] Computer Use 기반 시뮬레이터 UI 확인

## Verification Target

- Workspace: `/Users/youngk/Documents/Developer/06_슥캘린더/seuk-calendar-iOS/SeukCalendar/SeukCalendar.xcworkspace`
- Scheme: `SeukCalendar`
- Simulator: `iPhone 16 Pro`, iOS `26.2`

## Notes

- 도메인/데이터 계층 계약은 변경하지 않았다.
- `CalendarViewModel`의 기존 AI 파싱/저장 액션은 오버레이와 시트 UI에서 재사용한다.
- 신규 Feature 컴포넌트는 Xcode 파일 시스템 동기화 그룹 구조에 따라 별도 pbxproj 편집 없이 포함된다.
- `xcodebuild -workspace`는 `./SeukCalendar/SeukCalendar.xcworkspace/`처럼 trailing slash가 있어야 워크스페이스로 인식되었다.
- Computer Use로 월/주/일 제거, 날짜 탭 상세 패널, AI 일정 추가 오버레이, 파싱 후 등록 시트 프리필, 핸들바 닫기 접근성 경로를 확인했다.
- Computer Use의 좌표 기반 drag/scroll 호출은 `noWindowsAvailable` 오류가 발생해 물리 스와이프는 도구로 직접 재현하지 못했다. 구현은 `DragGesture`로 유지하고, 접근 가능한 핸들바 닫기 동작을 추가로 보강했다.
