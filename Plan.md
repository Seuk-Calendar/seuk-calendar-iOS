# 슥캘린더 서비스 기획서

> **문서 버전**: v1.3  
> **작성일**: 2026년 2월  
> **플랫폼**: iOS / iPadOS / macOS

---

## 목차

1. [서비스 개요](#1-서비스-개요)
2. [타겟 유저](#2-타겟-유저)
3. [수익 모델](#3-수익-모델)
4. [지원 플랫폼 및 시스템 요구사항](#4-지원-플랫폼-및-시스템-요구사항)
5. [핵심 차별점](#5-핵심-차별점)
6. [사용 방법 (입력 방식)](#6-사용-방법-입력-방식)
7. [AI 파싱 아키텍처](#7-ai-파싱-아키텍처)
8. [주요 기능 상세](#8-주요-기능-상세)
9. [기술 스택 및 네이티브 API](#9-기술-스택-및-네이티브-api)
10. [기능별 실현 가능성 검토](#10-기능별-실현-가능성-검토)
11. [개발 우선순위 로드맵](#11-개발-우선순위-로드맵)

---

## 1. 서비스 개요

### 서비스명
**슥캘린더** — AI-powered Native Calendar

### 네이밍 의도
"슥" — 빠르고 가볍게, 말하면 슥 하고 일정이 등록된다는 의미를 직관적으로 전달한다.  
캘린더라는 단어를 그대로 붙여 어떤 앱인지 설명 없이도 이해된다.

### 한 줄 소개
> 말하고, 찍고, 붙여넣기만 해도 슥 — 일정이 완성되는 AI 캘린더

### 서비스 배경

기존 캘린더 앱들의 공통된 불편함은 **일정을 등록하는 행위 자체**에 있다. 날짜를 탭하고, 제목을 입력하고, 시간을 스크롤하는 과정은 반복적이고 번거롭다. 특히 카카오톡 메시지, 이메일, 포스터 이미지에서 일정 정보를 보고 수동으로 입력해야 하는 상황은 흔하지만 여전히 마찰이 크다.

슥캘린더는 **AI를 등록 경로에 직접 통합**하여 자연어, 음성, 이미지, 클립보드 등 다양한 진입점에서 마찰 없이 일정을 등록할 수 있도록 한다. Apple의 On-device Foundation Models를 우선 활용해 **개인정보 보호와 오프라인 동작**을 기본값으로 제공한다.

---

## 2. 타겟 유저

### 핵심 타겟
> **계획적인 삶을 살고 싶지만, 일정 관리가 귀찮은 사람**

일정 관리의 필요성은 느끼지만 기존 캘린더 앱의 번거로운 입력 과정 때문에 꾸준히 쓰지 못했던 사람들이 주 타겟이다. 슥캘린더는 "등록하는 마찰"을 없애는 것이 핵심 가치이므로, 이 불편함을 공감하는 모든 사람이 잠재 유저가 된다.

### 유저 페르소나

**페르소나 A — 바쁜 직장인 (25~35세)**
- 미팅, 약속, 마감일이 많지만 캘린더 앱을 열어서 일일이 입력하기가 귀찮다
- 카카오톡 단톡방에서 약속 잡고 나서 캘린더에 다시 옮겨 적는 게 너무 번거롭다
- "말로 하면 바로 되면 좋겠다"는 니즈가 있다

**페르소나 B — 자기관리에 관심 많은 대학생 (20~25세)**
- 시험, 과제, 동아리 일정 등 관리할 것이 많다
- 미래에 대한 계획을 시각적으로 보고 싶어 한다
- 예쁘고 인터랙티브한 UI에 민감하다

**페르소나 C — 프리랜서 / 1인 사업자 (28~40세)**
- 클라이언트 미팅, 납기일, 업무 블록 등 복잡한 일정을 관리해야 한다
- Mac과 iPhone을 모두 사용하며 기기 간 일정 동기화가 중요하다
- Raycast 같은 생산성 도구를 즐겨 쓴다

### 확장 타겟
일정 관리에 관심이 있는 모든 Apple 기기 사용자. 슥캘린더의 낮은 입력 마찰은 기존에 캘린더 앱을 써본 적 없는 사람도 진입장벽 없이 시작할 수 있게 한다.

---

## 3. 수익 모델

슥캘린더는 **MAU 기반 단계적 수익화** 전략을 채택한다. 초기에는 무료로 최대한 많은 사용자를 확보하고, 일정 MAU 임계점에 도달한 이후 광고와 프리미엄 구독을 도입한다.

### 단계별 수익화 전략

| 단계 | MAU 기준 | 수익화 방법 |
|------|---------|------------|
| **0단계** | MAU 확보 전 | 완전 무료. 사용자 확보 및 리텐션 집중 |
| **1단계** | MAU 임계점 도달 | 배너/네이티브 광고 도입 (무료 사용자 대상) |
| **2단계** | 안정적 DAU 확보 후 | 프리미엄 플랜 출시 |

### 프리미엄 플랜 — 무료 vs 프리미엄 기능 비교

| 기능 | 무료 | 프리미엄 |
|------|:----:|:-------:|
| 자연어 일정 등록 | ✅ | ✅ |
| 음성 입력 | ✅ | ✅ |
| iCloud 동기화 | ✅ | ✅ |
| 기본 위젯 | ✅ | ✅ |
| 데일리 프리뷰 | ✅ | ✅ |
| 주간 리캡 / 월간 리캡 | ✅ | ✅ |
| 스마트 일정 제안 | ✅ | ✅ |
| 광고 노출 | ✅ | ❌ 광고 제거 |
| **프리미엄 앱 아이콘** | ❌ | ✅ |

### 앱 아이콘 구성
- 기본 아이콘: 무료 제공 n종
- 친구 초대 아이콘: 지인 n회 초대 달성 시 해금
- 프리미엄 아이콘: 프리미엄 플랜 구독자 전용

### 구독 가격 (예상)
- 월간 구독: **₩3,900 / 월**
- 연간 구독: **₩29,900 / 년** (월 환산 약 ₩2,490, 약 36% 할인)

---

## 4. 지원 플랫폼 및 시스템 요구사항

| 플랫폼 | 최소 버전 | 권장 버전 | 비고 |
|--------|----------|----------|------|
| iOS | iOS 26 | iOS 26+ | Foundation Models 기본 지원 |
| iPadOS | iPadOS 26 | iPadOS 26+ | 멀티태스킹 최적화 |
| macOS | macOS 26 Tahoe | macOS 26 Tahoe+ | Raycast Extension 지원 |
| Widget | iOS 26 WidgetKit | iOS 26+ WidgetKit | 홈화면 / 잠금화면 |

> **Foundation Models 지원 기기**: iPhone 15 Pro 이상, M1 이상 iPad/Mac  
> 미지원 기기는 Claude / GPT API 폴백으로 동일한 UX 제공

---

## 5. 핵심 차별점

### 5-1. AI 자연어 파싱 (온디바이스 우선)
형식에 맞춰 입력하는 것이 아니라 평소 말하듯 입력하면 AI가 날짜/시간/장소/내용을 자동으로 구조화한다.

```
"다음주 화요일 오후 2시에 강남역에서 팀장님이랑 미팅"
→ 제목: 팀장님 미팅 | 날짜: 3/18(화) | 시간: 14:00 | 장소: 강남역
```

### 5-2. 다양한 등록 진입점
앱을 열지 않아도 Siri, Spotlight, Share Extension, 클립보드 등 여러 경로로 일정을 등록할 수 있다.

### 5-3. 데일리 프리뷰
매일 해당 날짜의 일정을 AI가 사용자 아바타 이미지와 함께 알림으로 제공한다.

### 5-4. 기기 간 완전 동기화
EventKit + iCloud 기반으로 별도 계정 없이 Apple 기기 전반에 동기화된다.

### 5-5. 프라이버시 퍼스트
Foundation Models 온디바이스 처리로 일정 데이터가 기본적으로 외부 서버에 전송되지 않는다.

---

## 6. 사용 방법 (입력 방식)

### 방법 1 — 앱 직접 실행 + 자연어 입력
앱을 열고 자연어로 일정 내용을 입력하면 AI가 파싱하여 폼을 자동 완성한다. 사용자는 내용을 확인하고 저장 버튼만 누르면 된다.

```
[입력창] "금요일 저녁 7시 홍대 이자카야 친구들이랑"
         ↓ AI 파싱
[확인 카드] 제목: 친구들 이자카야
            날짜: 2026-02-27 (금)
            시간: 19:00
            장소: 홍대
            [저장] [편집]
```

### 방법 2 — 음성 입력
앱 내 마이크 버튼을 탭하면 음성으로 일정을 등록할 수 있다. 운전 중, 요리 중 등 손을 쓸 수 없는 상황에서 유용하다.

```
마이크 탭 → "내일 오전 10시 치과 예약 리마인더도 30분 전에 설정해줘"
          → Speech Framework로 텍스트 변환
          → Foundation Models로 구조화
          → EventKit에 일정 + 알림 등록
```

**사용 API**: `Speech Framework`, `Foundation Models Framework`

### 방법 3 — Spotlight 통합

```
Spotlight 검색: "회의"
→ 슥캘린더에 저장된 회의 일정 목록 표시
→ "+ 새 회의 일정 추가" 액션 제안
→ 탭하면 앱이 열리며 해당 내용으로 자동 입력
```

**사용 API**: `Core Spotlight (CSSearchableItem)`, `App Intents`

### 방법 4 — Siri 음성 명령

```
"Siri야, 슥캘린더에 다음주 수요일 오후 3시에 헬스장 일정 추가해줘"
→ AppIntent.perform() 실행
→ Foundation Models로 파싱
→ EventKit 등록 완료
→ "수요일 3월 18일 오후 3시에 헬스장 일정을 추가했어요" 응답
```

**사용 API**: `App Intents Framework`, `SiriKit`

### 방법 5 — 클립보드 감지 (앱 활성화 시)

```
카카오톡에서 "3/15 토 오후 4시 홍대 CGV" 복사
→ 슥캘린더 실행 시 상단 배너: "클립보드의 일정을 추가하시겠습니까?"
→ 탭 → 자동 파싱된 일정 확인 카드 표시
→ 저장
```

> ⚠️ iOS/iPadOS는 앱 활성화 시점에만 감지 가능. macOS는 백그라운드 감지 지원.

**사용 API**: `UIPasteboard` (iOS), `NSPasteboard` (macOS)

### 방법 6 — 이미지 / 스크린샷 인식 (Share Extension)

```
공연 포스터 이미지 → 공유 버튼 → 슥캘린더로 공유
→ Vision Framework OCR로 텍스트 추출
→ Foundation Models로 일정 파싱
→ "5월 3일 토요일 오후 7시 올림픽홀 콘서트 일정을 추가하시겠습니까?"
```

**사용 API**: `Vision Framework`, `Foundation Models`, `Share Extension`

### 방법 7 — Raycast Extension (macOS)

```
⌥ Space → "슥 내일 오전 팀 스탠드업"
→ Raycast Extension이 입력을 앱 API로 전달
→ Foundation Models 파싱
→ 등록 완료 알림 표시
```

**사용 도구**: `Raycast Extension API (React/TypeScript)`, 앱 내부 Local API

---

## 7. AI 파싱 아키텍처

```
[다양한 입력 소스]
  텍스트 직접 입력 / 음성 / 이미지(OCR) / 클립보드 / Siri
         ↓
[전처리 레이어]
  Speech Framework (음성→텍스트)
  Vision Framework (이미지→텍스트)
         ↓
[AI 파싱 레이어]
  ┌─────────────────────────────────────────────────────────────┐
  │  1순위: Foundation Models (온디바이스, 무료)                  │  ← iOS 26+ / Apple Intelligence 기기
  │         @Generable Swift 구조체 직접 반환                      │
  ├─────────────────────────────────────────────────────────────┤
  │  폴백:  Claude API / GPT API                                  │  ← 구형 기기 / AI 비활성화 시
  └─────────────────────────────────────────────────────────────┘
         ↓
[ParsedEvent 구조체]
  title / date / time / duration / location / notes / recurrence
         ↓
[사용자 확인 UI]
  파싱 결과 카드 표시 → 편집 가능 → 저장
         ↓
[EventKit → iCloud 동기화]
  iOS / iPadOS / macOS 전체 기기에 자동 반영
```

### Foundation Models 구현 예시

```swift
import FoundationModels

@Generable
struct ParsedEvent {
    let title: String
    let dateString: String    // ISO 8601 형식
    let startTime: String     // "HH:mm"
    let durationMinutes: Int
    let location: String?
    let notes: String?
    let isAllDay: Bool
}

func parseEventFromText(_ input: String) async throws -> ParsedEvent {
    let session = LanguageModelSession(
        instructions: """
        사용자 입력에서 일정 정보를 추출하세요.
        오늘 날짜 기준으로 상대적 날짜를 절대 날짜로 변환하세요.
        명시되지 않은 시간은 isAllDay = true로 처리하세요.
        """
    )
    return try await session.respond(
        to: input,
        generating: ParsedEvent.self
    )
}
```

### 파싱 경로 선택 로직

```swift
func parseEvent(_ text: String) async -> ParsedEvent {
    switch LanguageModel.availability {
    case .available:
        // 온디바이스 — 무료
        return try await parseWithFoundationModels(text)
    default:
        // 구형 기기 — 외부 AI API
        return try await parseWithExternalAPI(text)
    }
}
```

---

## 8. 주요 기능 상세

### 8-1. 일정 등록 및 관리

| 기능 | 설명 | 플랜 |
|------|------|------|
| 자연어 일정 등록 | AI가 자연어를 파싱하여 구조화된 일정으로 변환 | 무료 |
| 반복 일정 | 매주/매월 등 반복 패턴 자동 인식 및 설정 | 무료 |
| 알림 설정 | "30분 전에 알려줘" 등 자연어 알림 설정 | 무료 |
| 일정 수정/삭제 | 자연어로 수정 ("이번 회의 1시간 뒤로 미뤄줘") | 무료 |
| iCloud 동기화 | EventKit 기반 자동 동기화 | 무료 |
| 이미지 OCR 파싱 | 포스터/스크린샷에서 일정 추출 | 무료 |

### 8-2. 데일리 프리뷰

매일 아침(시간 사용자 설정 가능) 그날의 일정을 알림으로 제공한다. 핵심은 단순한 일정 나열이 아니라, **사용자 본인이 주인공**이라는 몰입감을 주는 것이다.

- 사용자의 나이, 국가, 날짜, 날씨를 반영한 개인화 아바타를 AI가 생성
- 아바타가 그날의 일정을 실제로 수행하는 장면을 이미지로 표현
- AI 생성 이미지 + 당일 일정 리스트를 함께 표시
- 이미지 저장 및 SNS 공유 기능 제공

```
[오전 8시 알림]
┌─────────────────────────────────────┐
│  🎨 AI 생성 이미지                   │
│  (눈 내리는 서울, 20대 직장인 아바타  │
│   카페에서 노트북으로 미팅 준비 중)   │
├─────────────────────────────────────┤
│  📅 오늘의 일정 — 2월 27일 (금)      │
│  • 10:00  팀 스탠드업 (30분)         │
│  • 14:00  클라이언트 미팅             │
│  • 19:00  홍대 저녁 약속              │
└─────────────────────────────────────┘
```

**사용 API**: `Foundation Models`, `Google Imagen API`, `WeatherKit`

### 8-3. 주간 리캡 / 월간 리캡

이번 주/월에 수행한 일정들을 돌아보며 사용자에게 동기부여를 제공한다. 데일리 프리뷰와 동일하게 사용자 아바타가 주인공이 되어 한 주/한 달을 살아낸 모습을 AI 이미지로 표현한다.

| 리캡 | 내용 | 우선순위 |
|------|------|:--------:|
| 주간 리캡 | 이번 주 수행 일정 + 아바타 이미지, 다음 주 예고 | P1 |
| 월간 리캡 | 이번 달 일정 패턴 분석 + 아바타 이미지, 바쁜 요일/시간대 시각화 | P2 |

### 8-4. 스마트 일정 제안

Foundation Models를 활용해 사용자의 일정 패턴을 온디바이스에서 분석하여 제안을 제공한다.

- 자주 반복되는 패턴 인식 → "지난주처럼 월요일 스탠드업을 추가할까요?"
- 이동 시간 감지 → "두 일정 사이 이동 시간이 30분인데 여유가 없어 보여요"
- 빈 시간 블록 제안 → "내일 오후 3~5시가 비어있어요. 집중 작업 시간을 잡을까요?"

---

## 9. 기술 스택 및 네이티브 API

### 9-1. Core

| 역할 | 프레임워크 | 버전 |
|------|-----------|------|
| 일정 CRUD | EventKit | iOS 26+ |
| 일정 편집 UI | EventKitUI | iOS 26+ |
| iCloud 동기화 | EventKit + CloudKit | iOS 26+ |

### 9-2. AI / ML

| 역할 | 프레임워크 | 버전 | 플랜 |
|------|-----------|------|------|
| 자연어 파싱 (온디바이스) | Foundation Models Framework | iOS 26+ | 무료 |
| 텍스트 파싱 폴백 | Claude API / OpenAI API | — | 무료 |
| 이미지 텍스트 인식 | Vision Framework | iOS 26+ | 무료 |
| 음성 인식 | Speech Framework | iOS 26+ | 무료 |
| AI 이미지 생성 | Google Imagen API | — | 무료 |

### 9-3. 시스템 통합

| 역할 | 프레임워크 / 도구 | 플랜 |
|------|-----------------|------|
| Spotlight 통합 | Core Spotlight (CSSearchableItem) | 무료 |
| Siri 연동 | App Intents, SiriKit | 무료 |
| 이미지 공유 수신 | Share Extension | 무료 |
| 위젯 | WidgetKit | 무료 |
| 클립보드 감지 | UIPasteboard (iOS), NSPasteboard (macOS) | 무료 |
| Raycast Extension | Raycast Extension API (React/TypeScript) | 무료 |
| 인앱 결제 | StoreKit 2 | — |

### 9-4. UI

| 역할 | 도구 |
|------|------|
| 메인 UI | SwiftUI |
| 복잡한 커스텀 UI | UIKit (UIViewControllerRepresentable) |
| 애니메이션 | SwiftUI Animations, Lottie |
| 크로스 플랫폼 | SwiftUI (iOS / iPadOS / macOS 통합) |

---

## 10. 기능별 실현 가능성 검토

| 기능 | 실현 가능성 | 핵심 API | 비고 |
|------|:---------:|----------|------|
| 자연어 일정 등록 | ✅ 완전 지원 | Foundation Models, EventKit | |
| 음성 입력 | ✅ 완전 지원 | Speech Framework | |
| Spotlight 통합 | ✅ 완전 지원 | Core Spotlight | |
| Siri 연동 | ✅ 완전 지원 | App Intents | iOS 18+ 자연어 크게 향상 |
| 이미지 OCR 파싱 | ✅ 완전 지원 | Vision + Foundation Models | |
| 클립보드 감지 (iOS) | ✅ 가능 | UIPasteboard | 앱 실행 시점에만 감지 |
| 클립보드 감지 (macOS) | ✅ 완전 지원 | NSPasteboard | 백그라운드 감지 가능 |
| Raycast Extension | ✅ 완전 지원 | Raycast Extension API | macOS 전용 |
| 기기 간 동기화 | ✅ 완전 지원 | EventKit + iCloud | 별도 서버 불필요 |
| 데일리 프리뷰 | ✅ 가능 | Foundation Models, Google Imagen API | |
| 주간 리캡 / 월간 리캡 | ✅ 가능 | Foundation Models, Google Imagen API | |
| 스마트 일정 제안 | ✅ 가능 | Foundation Models | 온디바이스 처리 |
| Foundation Models 온디바이스 | ✅ (조건부) | Foundation Models Framework | iOS 26+ / Apple Intelligence 기기 한정 |
| 인앱 결제 | ✅ 완전 지원 | StoreKit 2 | |
| AI 이미지 생성 | ✅ 가능 | Google Imagen API | 네트워크 요청 필요 |

---

## 11. 개발 우선순위 로드맵

### Phase 1 — MVP (약 1개월)
핵심 가치 검증. 무료 플랜의 기본 기능 완성.

- [ ] EventKit 기반 일정 CRUD
- [ ] SwiftUI 캘린더 UI (월간/주간/일간 뷰)
- [ ] Foundation Models 자연어 파싱 (텍스트 입력)
- [ ] Claude API / OpenAI API 폴백 처리
- [ ] iCloud 동기화
- [ ] 기본 알림 설정
- [ ] 기본 WidgetKit 위젯 (오늘의 일정)

### Phase 2 — 확장 (약 1개월)
진입점 다양화 및 시스템 통합. 무료 플랜 완성.

- [ ] 음성 입력 (Speech Framework)
- [ ] 클립보드 감지 (앱 활성화 시)
- [ ] Share Extension (이미지 / 텍스트 공유)
- [ ] Core Spotlight 통합
- [ ] App Intents + Siri 연동
- [ ] 데일리 프리뷰 (Google Imagen API)
- [ ] 스마트 일정 제안
- [ ] 광고 SDK 연동 (MAU 임계점 도달 시 활성화)

### Phase 3 — 프리미엄 플랜 출시 (약 1개월)
프리미엄 구독 기능 구현 및 수익화 시작.

- [ ] 인앱 결제 (StoreKit 2)
- [ ] 주간 리캡 / 월간 리캡
- [ ] 프리미엄 앱 아이콘
- [ ] 친구 초대 시스템 (아이콘 해금 연동)
- [ ] Raycast Extension (macOS)
- [ ] macOS 클립보드 백그라운드 감지

---

*본 기획서는 2026년 2월 기준 Apple 공식 문서 및 WWDC25 세션을 토대로 작성되었습니다.*  
*슥캘린더 — 말하면 슥, 일정이 완성됩니다.*
