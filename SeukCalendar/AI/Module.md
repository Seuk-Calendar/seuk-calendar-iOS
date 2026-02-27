# AI Module

AI 관련 기능을 제공하는 모듈입니다.

## 역할

- Foundation Models Framework 통합 (온디바이스 AI)
- 외부 AI API 연동 (Claude, OpenAI 폴백)
- Vision Framework OCR 처리
- Speech Framework 음성 인식

## 디렉토리 구조

```
AI/
├── Package.swift
├── Module.md
├── Sources/
│   └── AI/
│       ├── FoundationModels/
│       │   ├── FoundationModelsParser.swift
│       │   ├── LanguageModelManager.swift
│       │   └── ParsedEventGenerable.swift
│       ├── ExternalAPI/
│       │   ├── ClaudeAPIClient.swift
│       │   ├── OpenAIAPIClient.swift
│       │   └── ImagenAPIClient.swift
│       ├── OCR/
│       │   ├── VisionOCRProcessor.swift
│       │   └── OCRResult.swift
│       └── Speech/
│           ├── SpeechRecognizer.swift
│           └── SpeechResult.swift
└── Tests/
    └── AITests/
```

## 주요 구성요소

### FoundationModels

**역할**: iOS 26+ Foundation Models Framework를 활용한 온디바이스 AI 파싱

**위치**: `Sources/AI/FoundationModels/`

**파일**:
- FoundationModelsParser.swift: 자연어 → ParsedEvent 파싱
- LanguageModelManager.swift: LanguageModel 세션 관리
- ParsedEventGenerable.swift: @Generable 구조체 정의

**주요 기능**:
- 텍스트 자연어 파싱
- 날짜/시간 정규화
- 반복 패턴 인식
- 프라이버시 보호 (온디바이스 처리)

### ExternalAPI

**역할**: 외부 AI API 연동 (구형 기기 폴백)

**위치**: `Sources/AI/ExternalAPI/`

**파일**:
- ClaudeAPIClient.swift: Anthropic Claude API 클라이언트
- OpenAIAPIClient.swift: OpenAI GPT API 클라이언트
- ImagenAPIClient.swift: Google Imagen API 클라이언트 (리캡 이미지 생성)

**주요 기능**:
- Foundation Models 미지원 기기용 파싱
- AI 이미지 생성 (데일리 프리뷰, 리캡)
- API 키 관리 및 에러 핸들링

### OCR

**역할**: Vision Framework를 활용한 이미지 텍스트 인식

**위치**: `Sources/AI/OCR/`

**파일**:
- VisionOCRProcessor.swift: VNRecognizeTextRequest 처리
- OCRResult.swift: OCR 결과 모델

**주요 기능**:
- 이미지에서 텍스트 추출
- 공연 포스터, 스크린샷 파싱
- 한글/영문 동시 인식

### Speech

**역할**: Speech Framework를 활용한 음성 인식

**위치**: `Sources/AI/Speech/`

**파일**:
- SpeechRecognizer.swift: SFSpeechRecognizer 래퍼
- SpeechResult.swift: 음성 인식 결과 모델

**주요 기능**:
- 실시간 음성 → 텍스트 변환
- 권한 요청 및 처리
- 에러 핸들링

## 의존성

- **Core**: 공통 유틸리티
- **Domain**: ParsingDomain (ParsedEvent 모델 사용)

## Package.swift

**위치**: `Package.swift`

**주요 설정**:
- 플랫폼: iOS 18+
- 의존성: Core, ParsingDomain
- Products: AI

## 사용 가이드

### Foundation Models 파싱

**참고**: `Sources/AI/FoundationModels/FoundationModelsParser.swift`

```swift
let parser = FoundationModelsParser()
let parsedEvent = try await parser.parse(text: "내일 오후 3시 강남역 미팅")
```

### 외부 API 파싱 (폴백)

**참고**: `Sources/AI/ExternalAPI/ClaudeAPIClient.swift`

```swift
let client = ClaudeAPIClient()
let parsedEvent = try await client.parseEvent(text: "내일 오후 3시 강남역 미팅")
```

### OCR 처리

**참고**: `Sources/AI/OCR/VisionOCRProcessor.swift`

```swift
let processor = VisionOCRProcessor()
let ocrResult = try await processor.recognizeText(from: image)
```

### 음성 인식

**참고**: `Sources/AI/Speech/SpeechRecognizer.swift`

```swift
let recognizer = SpeechRecognizer()
try await recognizer.startRecording()
```
