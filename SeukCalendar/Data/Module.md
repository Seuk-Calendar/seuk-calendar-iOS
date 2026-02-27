# Data Module

데이터 레이어 모듈로, Repository 구현체와 외부 데이터 소스와의 통신을 담당합니다.

## 역할

- Repository 인터페이스 구현
- 외부 데이터 소스와의 통신 (EventKit, API, UserDefaults 등)
- DTO ↔ Domain Model 변환

## 디렉토리 구조

```
Data/
├── Package.swift
├── Module.md
├── Sources/
│   ├── CalendarData/
│   │   ├── Repository/             # Repository 구현
│   │   │   └── CalendarRepositoryImpl.swift
│   │   ├── DataSource/             # EventKit 연동
│   │   │   ├── EventKitDataSource.swift
│   │   │   └── EventKitMapper.swift
│   │   └── DTO/                    # EKEvent → Event 변환
│   ├── ParsingData/
│   │   ├── Repository/
│   │   │   └── ParsingRepositoryImpl.swift
│   │   ├── DataSource/
│   │   │   ├── FoundationModelsDataSource.swift
│   │   │   ├── ClaudeAPIDataSource.swift
│   │   │   └── OpenAIAPIDataSource.swift
│   │   └── DTO/
│   ├── RecapData/
│   │   ├── Repository/
│   │   │   └── RecapRepositoryImpl.swift
│   │   ├── DataSource/
│   │   │   └── ImagenAPIDataSource.swift
│   │   └── DTO/
│   └── WidgetData/
│       ├── Repository/
│       │   └── WidgetRepositoryImpl.swift
│       ├── DataSource/
│       │   └── WidgetDataSource.swift
│       └── DTO/
└── Tests/
    └── DataTests/
```

## 타겟 구성

### 1. CalendarData

CalendarDomain의 Repository 구현. EventKit 연동.

**Repository**: `Sources/CalendarData/Repository/`
- CalendarRepositoryImpl.swift: CalendarRepository 구현체

**DataSource**: `Sources/CalendarData/DataSource/`
- EventKitDataSource.swift: EventKit CRUD 작업
- EventKitMapper.swift: EKEvent ↔ Event 변환

**DTO**: `Sources/CalendarData/DTO/`
- EKEvent Extension: Domain Model 변환

### 2. ParsingData

ParsingDomain의 Repository 구현. AI 파싱 API 연동.

**Repository**: `Sources/ParsingData/Repository/`
- ParsingRepositoryImpl.swift: ParsingRepository 구현체

**DataSource**: `Sources/ParsingData/DataSource/`
- FoundationModelsDataSource.swift: 온디바이스 AI 파싱
- ClaudeAPIDataSource.swift: Claude API 파싱 (폴백)
- OpenAIAPIDataSource.swift: OpenAI API 파싱 (폴백)

**DTO**: `Sources/ParsingData/DTO/`
- API Response ↔ ParsedEvent 변환

### 3. RecapData

RecapDomain의 Repository 구현. AI 이미지 생성 API 연동.

**Repository**: `Sources/RecapData/Repository/`
- RecapRepositoryImpl.swift: RecapRepository 구현체

**DataSource**: `Sources/RecapData/DataSource/`
- ImagenAPIDataSource.swift: Google Imagen API 연동

**DTO**: `Sources/RecapData/DTO/`
- API Response ↔ RecapImage 변환

### 4. WidgetData

WidgetDomain의 Repository 구현.

**Repository**: `Sources/WidgetData/Repository/`
- WidgetRepositoryImpl.swift: WidgetRepository 구현체

**DataSource**: `Sources/WidgetData/DataSource/`
- WidgetDataSource.swift: UserDefaults 기반 위젯 데이터 저장/조회

**DTO**: `Sources/WidgetData/DTO/`
- WidgetData 변환 로직

## 의존성

- **Core**: 공통 유틸리티
- **Domain**: 각 Data 타겟은 해당하는 Domain 타겟에 의존
  - CalendarData → CalendarDomain
  - ParsingData → ParsingDomain
  - RecapData → RecapDomain
  - WidgetData → WidgetDomain

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 18+
- 의존성: Core, Domain
- Products: CalendarData, ParsingData, RecapData, WidgetData

## 사용 가이드

### Repository 구현

**참고**: `Sources/{Data}/Repository/` 디렉토리의 각 Repository 구현체

### DataSource 사용

**참고**: `Sources/{Data}/DataSource/` 디렉토리의 각 DataSource 파일

### DTO 변환

**참고**: `Sources/{Data}/DTO/` 디렉토리의 각 DTO 변환 로직
