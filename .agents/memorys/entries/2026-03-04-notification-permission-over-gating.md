## 제목(Title)
- 알림 권한 부재를 캘린더 접근 실패로 과도하게 게이팅한 사례

## 날짜(Date)
- 2026-03-04

## 유형(Type)
- rejection

## 키워드(Keywords)
- workflow:feature
- workflow:review
- action:permission-decoupling
- failure:overstrict-permission-gate
- target:file:SeukCalendar/Feature/CalendarFeature/Calendar/CalendarViewModel.swift
- target:file:SeukCalendar/Data/CalendarData/Repository/EventKitScheduleRepository.swift
- risk:high
- verify:calendarfeature-test
- verify:permission-flow

## 컨텍스트(Context)
- 기본 알림 기능 구현 후 앱 실행 시, 일정 화면 진입 직후 `알림 권한이 없어 리마인더를 표시할 수 없습니다.` 메시지가 노출되었습니다.

## 문제 행동(Bad Action)
- 알림 권한이 없으면 캘린더 권한 자체가 없는 것처럼 `permissionState = .denied`로 처리해 화면 로딩을 차단했습니다.
- `requestAccess()` 반환값에 알림 권한 결과를 포함해 캘린더 접근 허용 여부를 잘못 축소했습니다.

## 사용자 피드백(User Feedback)
- 사용자 요청: `앱을 실행해보니까 알림 권한이 없어 리마인더를 표시할 수 없습니다 라고 표시되고 있어. 해당 문제를 수정하고, 테스트코드에 추가해줘`

## 원인(Root Cause)
- “리마인더 품질 향상” 요구를 “일정 조회 필수 권한”으로 잘못 해석하여 권한 모델을 결합했습니다.

## 예방 규칙(Prevention Rule)
- 캘린더 접근 권한과 리마인더(알림) 권한은 분리 처리합니다.
- 알림 권한 부재는 기능 저하(warning)로 다루고, 일정 조회/표시는 차단하지 않습니다.
- 권한 게이팅 코드를 추가할 때는 “핵심 사용자 흐름 차단 여부”를 먼저 검토합니다.

## 사전 점검(Pre-Command Check)
- 새 권한 체크가 기존 핵심 기능(일정 조회/목록 표시)을 막지 않는가?
- 권한 실패 시 degrade 경로(경고/부분 기능)와 block 경로(접근 차단)가 구분되어 있는가?
- 권한 관련 테스트에 “권한 없음이어도 핵심 흐름 유지” 시나리오가 포함되어 있는가?

## 금지 동작(Do Not Do)
- 보조 권한(알림/마이크 등) 부재를 이유로 핵심 데이터 조회 화면 전체를 denied로 전환하지 않습니다.

## 안전 대안(Safe Alternative)
- 캘린더 권한만으로 일정 로딩을 허용하고, 알림 권한은 저장/알림 노출 품질에만 조건부 적용합니다.
- `requestAccess()`는 핵심 권한 성공 시 true를 유지하고, 보조 권한 요청은 부수 효과로 처리합니다.

## 검증 단계(Verification Step)
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarFeature -destination 'platform=iOS Simulator,id=D76E7868-D294-42A9-BA46-DD23BF6C8B9C' test`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme CalendarDomain -destination 'platform=iOS Simulator,id=D76E7868-D294-42A9-BA46-DD23BF6C8B9C' test`
- `xcodebuild -workspace SeukCalendar/SeukCalendar.xcworkspace -scheme AI -destination 'platform=iOS Simulator,id=D76E7868-D294-42A9-BA46-DD23BF6C8B9C' test`

## 적용 범위(Scope)
- ViewModel 권한 상태 전이 로직, Repository 권한 요청 반환 계약, 권한 관련 UI 메시지 전반

## 심각도(Severity)
- high

## 예시(Examples)
- 나쁜 예(Bad): 알림 권한 없음 → `permissionState = .denied`로 캘린더 로딩 중단
- 좋은 예(Good): 알림 권한 없음 → 캘린더는 정상 로딩, 알림 기능만 제한/안내

## 관련 메모리(Related Memories)
- `entries/2026-03-03-test-annotation-korean-and-compile-safety.md`
