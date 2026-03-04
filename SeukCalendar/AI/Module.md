# AI Module

AI 관련 기능을 제공하는 모듈입니다.

## 역할

- Foundation Models 기반 자연어 일정 파싱
- `CalendarDomain`의 `ScheduleNaturalLanguageParser` 구현 제공
- Foundation Models 실패/미지원 시 휴리스틱 파싱 폴백 제공

## 디렉토리 구조

```
AI/
├── AI.xcodeproj
├── Module.md
├── AI/
│   └── FoundationModels/
│       ├── FoundationModelsParser.swift
│       └── ParsedEventGenerable.swift
└── AITests/
    └── AITests.swift
```

## 주요 구성요소

### FoundationModelsParser

**위치**: `AI/FoundationModels/FoundationModelsParser.swift`

**역할**:
- 사용자 자연어 입력을 `ParsedEvent`로 변환
- Foundation Models 사용 가능 시 모델 파싱 우선 시도
- 모델 응답 실패 시 휴리스틱 파싱으로 안전하게 폴백

**주요 기능**:
- 상대 날짜(`오늘`, `내일`, `다음주 금요일`)를 절대 날짜로 정규화
- `오전/오후/저녁` 시간을 24시간 형식(`HH:mm`)으로 변환
- 시간 누락 시 `isAllDay=true` 처리
- 알림 문구(`30분 전`, `1시간 전`, `하루 전`, `시작 시간`)를 `ScheduleAlarm` 오프셋으로 파싱

### ParsedEventGenerable

**위치**: `AI/FoundationModels/ParsedEventGenerable.swift`

**역할**:
- Foundation Models의 구조화 출력용 `@Generable` 모델 정의

## 의존성

- **Core**: 공통 에러 프로토콜(`SCError`)
- **Domain**: `ParsedEvent`, `ScheduleNaturalLanguageParser`

## Xcode 프로젝트 설정

**위치**: `AI.xcodeproj`

**주요 설정**:
- 플랫폼: iOS 26+
- 프레임워크 타입: Dynamic Framework
- 의존성: Core.framework, CalendarDomain.framework, UserDomain.framework
- 타겟: AI (Framework), AITests (Unit Test)

## 사용 가이드

```swift
import AI
import CalendarDomain

let parser: any ScheduleNaturalLanguageParser = FoundationModelsParser()
let parsed = try await parser.parse(
  text: "다음주 화요일 오후 2시에 강남역에서 팀 미팅",
  referenceDate: Date()
)
```
