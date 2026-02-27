# Domain Module

비즈니스 로직을 담당하는 모듈입니다. 4개의 도메인 타겟으로 구성되어 있습니다.

## 역할

- 비즈니스 로직 캡슐화
- 순수 도메인 엔티티 정의
- Repository 인터페이스 제공 (Data Layer와의 계약)
- 도메인 Service 구현

## 디렉토리 구조

```
Domain/
├── Package.swift
├── Module.md
├── Sources/
│   ├── CalendarDomain/
│   │   ├── Entity/          # Event, Calendar 등
│   │   ├── UseCase/         # EventKit CRUD UseCase
│   │   ├── Repository/      # CalendarRepository Interface
│   │   └── Service/         # EventKit 관련 Service
│   ├── ParsingDomain/
│   │   ├── Entity/          # ParsedEvent, ParsingRequest 등
│   │   ├── UseCase/         # AI 파싱 UseCase
│   │   └── Repository/      # ParsingRepository Interface
│   ├── RecapDomain/
│   │   ├── Entity/          # DailyPreview, WeeklyRecap, MonthlyRecap
│   │   ├── UseCase/         # 리캡 생성 UseCase
│   │   └── Repository/      # RecapRepository Interface
│   └── WidgetDomain/
│       ├── Entity/          # WidgetData, WidgetConfiguration
│       ├── UseCase/         # 위젯 데이터 조회 UseCase
│       └── Repository/      # WidgetRepository Interface
├── TestSupport/
│   └── CalendarDomainTestSupport/
│       ├── MockCalendarRepository.swift
│       └── Event+Mock.swift
└── Tests/
    └── DomainTests/
```

## 타겟 구성

### 1. CalendarDomain

일정 관련 비즈니스 로직. EventKit 연동의 핵심 도메인.

**Entity**: `Sources/CalendarDomain/Entity/`
- Event.swift: 일정 모델
- Calendar.swift: 캘린더 모델
- Reminder.swift: 알림 모델
- RecurrenceRule.swift: 반복 규칙 모델

**UseCase**: `Sources/CalendarDomain/UseCase/`
- FetchEventsUseCase.swift: 일정 목록 조회
- CreateEventUseCase.swift: 일정 생성
- UpdateEventUseCase.swift: 일정 수정
- DeleteEventUseCase.swift: 일정 삭제

**Repository**: `Sources/CalendarDomain/Repository/`
- CalendarRepository.swift: Repository Interface (Protocol)

**Service**: `Sources/CalendarDomain/Service/`
- EventKitService.swift: EventKit 통합 서비스
- CalendarPermissionService.swift: 권한 관리 서비스

### 2. ParsingDomain

AI 자연어 파싱 관련 비즈니스 로직.

**Entity**: `Sources/ParsingDomain/Entity/`
- ParsedEvent.swift: 파싱된 일정 모델
- ParsingRequest.swift: 파싱 요청 모델
- ParsingSource.swift: 파싱 소스 타입 (텍스트/음성/이미지)

**UseCase**: `Sources/ParsingDomain/UseCase/`
- ParseTextToEventUseCase.swift: 텍스트 파싱
- ParseVoiceToEventUseCase.swift: 음성 파싱
- ParseImageToEventUseCase.swift: 이미지(OCR) 파싱

**Repository**: `Sources/ParsingDomain/Repository/`
- ParsingRepository.swift: Repository Interface

### 3. RecapDomain

데일리 프리뷰, 주간/월간 리캡 관련 비즈니스 로직.

**Entity**: `Sources/RecapDomain/Entity/`
- DailyPreview.swift: 데일리 프리뷰 모델
- WeeklyRecap.swift: 주간 리캡 모델
- MonthlyRecap.swift: 월간 리캡 모델
- RecapImage.swift: AI 생성 이미지 모델

**UseCase**: `Sources/RecapDomain/UseCase/`
- GenerateDailyPreviewUseCase.swift: 데일리 프리뷰 생성
- GenerateWeeklyRecapUseCase.swift: 주간 리캡 생성
- GenerateMonthlyRecapUseCase.swift: 월간 리캡 생성

**Repository**: `Sources/RecapDomain/Repository/`
- RecapRepository.swift: Repository Interface

### 4. WidgetDomain

위젯 관련 비즈니스 로직.

**Entity**: `Sources/WidgetDomain/Entity/`
- WidgetData.swift: 위젯 데이터 모델
- WidgetConfiguration.swift: 위젯 설정 모델

**UseCase**: `Sources/WidgetDomain/UseCase/`
- FetchWidgetDataUseCase.swift: 위젯 데이터 조회
- UpdateWidgetUseCase.swift: 위젯 업데이트

**Repository**: `Sources/WidgetDomain/Repository/`
- WidgetRepository.swift: Repository Interface

## TestSupport

테스트용 Mock 객체 제공.

**위치**: `TestSupport/CalendarDomainTestSupport/`
- MockCalendarRepository.swift: Mock Repository
- Event+Mock.swift: Mock 데이터 생성 Extension

## 의존성

- **Core**: 공통 유틸리티 (각 Domain 타겟이 Core에만 의존)
- **타겟 간 의존성 없음**: 각 Domain 타겟은 독립적

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 18+
- 의존성: Core
- Products: CalendarDomain, ParsingDomain, RecapDomain, WidgetDomain, CalendarDomainTestSupport

## 사용 가이드

### Entity 사용

**참고**: `Sources/{Domain}/Entity/` 디렉토리의 각 Entity 파일

### UseCase 사용

**참고**: `Sources/{Domain}/UseCase/` 디렉토리의 각 UseCase 파일

### Repository Interface 정의

**참고**: `Sources/{Domain}/Repository/` 디렉토리의 각 Repository 파일

### Service 구현

**참고**: `Sources/CalendarDomain/Service/EventKitService.swift`

### Mock 사용

**참고**: `TestSupport/CalendarDomainTestSupport/MockCalendarRepository.swift`
