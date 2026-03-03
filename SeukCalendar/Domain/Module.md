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
├── Domain.xcodeproj
├── CalendarDomain/
│   ├── Entity/
│   ├── UseCase/
│   ├── Repository/
│   └── Service/
├── UserDomain/
│   ├── Entity/
│   ├── UseCase/
│   └── Repository/
├── CalendarDomainTestSupport/
├── UserDomainTestSupport/
├── CalendarDomainTests/
└── UserDomainTests/
```

## 타겟 구성

### 1. CalendarDomain

캘린더 관련 비즈니스 로직.

**Entity**: `CalendarDomain/Entity/`
- `Schedule.swift`: 일정 도메인 모델 (title, date/time, duration, recurrence)

**UseCase**: `CalendarDomain/UseCase/`
- `CreateScheduleUseCase.swift`: 일정 생성
- `FetchSchedulesUseCase.swift`: 일정 단건/기간 조회
- `UpdateScheduleUseCase.swift`: 일정 수정
- `DeleteScheduleUseCase.swift`: 일정 삭제

**Repository**: `CalendarDomain/Repository/`
- `ScheduleRepository.swift`: EventKit 기반 저장소와의 계약 인터페이스

**Service**: `CalendarDomain/Service/`

### 2. UserDomain

사용자 관련 비즈니스 로직.

**Entity**: `UserDomain/Entity/`
- User.swift: 사용자 모델

**UseCase**: `UserDomain/UseCase/`
- FetchUserProfileUseCase.swift: 사용자 프로필 조회

**Repository**: `UserDomain/Repository/`
- UserRepository.swift: Repository Interface

## TestSupport

테스트용 Mock 객체 제공.

**CalendarDomain TestSupport**: `CalendarDomainTestSupport/`
**UserDomain TestSupport**: `UserDomainTestSupport/`

## 의존성

- **Core**: 공통 유틸리티 (각 Domain 타겟이 Core에만 의존)
- **타겟 간 의존성 없음**: 각 Domain 타겟은 독립적

## Xcode 프로젝트 설정

**위치**: `Domain.xcodeproj`

**주요 설정**:
- 플랫폼: iOS 18+
- 프레임워크 타입: Dynamic Framework
- 의존성: Core.framework
- 타겟:
  - CalendarDomain (Framework)
  - UserDomain (Framework)
  - CalendarDomainTestSupport (Framework)
  - UserDomainTestSupport (Framework)
  - CalendarDomainTests (Unit Test)
  - UserDomainTests (Unit Test)

## 사용 가이드

### Entity 사용

**참고**: `{Domain}Domain/Entity/` 디렉토리의 각 Entity 파일

### UseCase 사용

**참고**: `{Domain}Domain/UseCase/` 디렉토리의 각 UseCase 파일

### Repository Interface 정의

**참고**: `{Domain}Domain/Repository/` 디렉토리의 각 Repository 파일

### Service 구현

**참고**: `CalendarDomain/Service/CalendarService.swift`

### Mock 사용

**참고**: `UserDomainTestSupport/MockUserRepository.swift`
