## 제목(Title)
- 유사한 날짜 셀 이름이 있을 때 디자인시스템이 아니라 실제 타깃 모듈 경로를 먼저 확인해야 하는 사례

## 날짜(Date)
- 2026-03-19

## 유형(Type)
- mistake

## 키워드(Keywords)
- workflow:widget
- workflow:designsystem
- action:verify-target-module-before-edit
- failure:edited-similar-component-in-wrong-module
- target:dir:SeukCalendar/SeukCalendarWidget
- risk:wrong-scope-edit
- verify:rg-component-path-before-patch

## 컨텍스트(Context)
- 사용자는 위젯의 `WidgetDayCell` 폰트 분기를 요청했지만, 동일한 역할의 날짜 셀 컴포넌트가 디자인시스템에도 존재해 잘못된 파일을 먼저 수정했다.

## 문제 행동(Bad Action)
- 사용자 표현만 보고 디자인시스템 `DateWrapComponent`를 수정했고, 실제 위젯 타깃의 `SeukCalendarWidget/Components/WidgetDayCell.swift`를 먼저 확인하지 않았다.

## 사용자 피드백(User Feedback)
- "디자인 시스템에 있는 DateWrapComponent말고, App 모듈에 있는 위젯쪽에 WidgetDayCell을 말하는거야."

## 원인(Root Cause)
- 이름과 역할이 비슷한 컴포넌트가 여러 모듈에 있을 때 코드 검색 없이 익숙한 위치를 먼저 가정했다.

## 예방 규칙(Prevention Rule)
- 위젯, 앱, 디자인시스템처럼 모듈 경계가 중요한 요청은 수정 전에 `rg`로 실제 심볼 경로를 찾고, 대상 타깃 문서를 확인한 뒤 패치한다.

## 사전 점검(Pre-Command Check)
- `rg --files | rg 'WidgetDayCell|DateWrapComponent|Platform.swift'` 로 후보 경로를 먼저 확인했는가
- 사용자가 지칭한 모듈(`App`, `Widget`, `DesignSystem`)과 실제 파일 경로가 일치하는가
- 비슷한 이름의 컴포넌트가 여러 곳에 있으면 수정 전 대상 파일 경로를 답변에 명시했는가

## 금지 동작(Do Not Do)
- 비슷한 UI 역할이라는 이유만으로 디자인시스템 컴포넌트를 먼저 수정하지 않는다.

## 안전 대안(Safe Alternative)
- 먼저 타깃 모듈 파일을 찾아 수정하고, 공통화가 필요한 경우에만 디자인시스템 반영을 별도 판단한다.

## 검증 단계(Verification Step)
- 수정 후 위젯 스킴을 macOS와 iOS Simulator에서 각각 빌드해 대상 타깃이 실제로 컴파일되는지 확인한다.

## 적용 범위(Scope)
- 위젯 확장, 앱 모듈, 디자인시스템 사이에 유사 명칭 컴포넌트가 공존하는 모든 UI 수정 작업

## 심각도(Severity)
- medium

## 예시(Examples)
- 나쁜 예(Bad):
- "날짜 셀 폰트 수정" 요청을 보고 바로 `DesignSystem/.../DateWrapComponent.swift`를 변경한다.
- 좋은 예(Good):
- `rg 'struct WidgetDayCell|struct DateWrapComponent' -n` 로 실제 선언 위치를 찾은 뒤, `SeukCalendarWidget/.../WidgetDayCell.swift`를 수정한다.

## 관련 메모리(Related Memories)
- `entries/2026-03-03-branch-context-mismatch.md`
