# 디자인시스템 컴포넌트 생성 규칙

## 목적

- 디자인시스템 컴포넌트의 public API를 일관된 형태로 유지합니다.
- UI 구성 정보와 사용자 이벤트 전달 경로를 분리합니다.
- Preview, 테스트, 상위 뷰 조합 시 재사용성을 높입니다.

## 적용 범위

- `SeukCalendar/DesignSystem`에 추가되는 신규 컴포넌트 및 기존 컴포넌트

## 규칙

### 1. 생성자 시그니처를 통일합니다

- 모든 public 컴포넌트는 생성자에서 `Configuration`을 필수로 받습니다.
- 상위 뷰 이벤트 전달이 필요한 경우 `eventListener`를 옵셔널로 받습니다.
- 개별 파라미터 나열 방식(`title`, `mode`, `onTap` 등)은 지양합니다.

권장 형태:

```swift
public init(
  configuration: Configuration,
  eventListener: EventListener? = nil
)
```

### 2. `Configuration`은 UI 정보만 포함합니다

- `Configuration`은 `struct`로 선언합니다.
- 컴포넌트 외형과 표현 상태를 결정하는 값만 담습니다.
- 예: `title`, `subtitle`, `icon`, `mode`, `size`, `isSelected`, `badgeCount`
- 비즈니스 로직, Repository, UseCase, ViewModel, side effect는 포함하지 않습니다.
- 액션 클로저는 `Configuration`에 넣지 않습니다.

### 3. `EventListener`는 상위 뷰 전달 전용으로 사용합니다

- `EventListener`는 이벤트를 상위 뷰로 전달하는 역할만 가집니다.
- 내부 상태 저장, 비동기 스트림 관리, 외부 의존성 보관 책임을 두지 않습니다.
- 이벤트는 컴포넌트 내부에서 발생한 UI 상호작용이나 상태 변화만 표현합니다.
- 예: `tap`, `longPress`, `didSelectDate(Date)`, `didTapAccessory`

### 4. `eventListener`는 closure typealias를 기본으로 사용합니다

- 기본 권장 타입은 `typealias EventListener = (Event) -> Void` 입니다.
- 이유:
  - 상위 뷰에서 `eventListener: { event in ... }` 형태로 바로 주입할 수 있습니다.
  - 이벤트가 추가되어도 생성자 시그니처는 안정적으로 유지됩니다.
  - `switch event` 패턴 매칭으로 이벤트 분기를 한 곳에서 처리하기 쉽습니다.
- 특별한 수명주기 관리나 내부 상태 저장이 없다면 `struct` wrapper나 `class` listener는 기본값으로 사용하지 않습니다.

### 5. 이벤트 방출 방식은 `Event enum + typed closure`를 기본값으로 사용합니다

- 디자인시스템 public API에서는 `Closure` 기반 이벤트 방출을 기본으로 사용합니다.
- 권장 방식은 단일 이벤트 sink + `Event` enum 조합입니다.

권장 형태:

```swift
public extension DSChip {
  enum Event {
    case tap
    case removeTap
  }

  typealias EventListener = (Event) -> Void
}
```

### 6. 이벤트는 타입 안전하게 정의합니다

- 여러 이벤트가 존재하면 개별 클로저 여러 개보다 `Event` enum 하나로 묶는 것을 우선합니다.
- 이벤트 payload는 해당 상호작용에 필요한 최소 정보만 포함합니다.
- 도메인 객체 전체를 넘기기보다 상위 뷰에 필요한 식별자나 선택 결과를 우선 검토합니다.

### 7. 파일 구조는 역할 기준으로 분리합니다

- 디자인시스템 컴포넌트는 디렉토리 단위로 구성합니다.
- 기본 경로는 `TierN/<Name>Component/` 형태를 사용합니다.
- 기본 구현 파일은 항상 `<Name>Component.swift`로 분리합니다.
- 설정 타입은 항상 `<Name>Component+Configuration.swift`로 분리합니다.
- 이벤트 타입은 항상 `<Name>Component+Event.swift`로 분리합니다.
- 계산 로직이 많거나 복잡하면 `<Name>Component+Calculate.swift`를 추가로 분리합니다.
- 하위 뷰는 `TierN/<Name>Component/Components/` 디렉토리 아래에 둡니다.

권장 구조:

```text
Tier1/
└── AComponent/
    ├── AComponent.swift
    ├── AComponent+Configuration.swift
    ├── AComponent+Event.swift
    ├── AComponent+Calculate.swift
    └── Components/
        ├── AComponentHeader.swift
        └── AComponentRow.swift
```

## 예시

좋은 예:

```swift
public struct AComponent: View {
  private let configuration: Configuration
  private let eventListener: EventListener?

  public init(
    configuration: Configuration,
    eventListener: EventListener? = nil
  ) {
    self.configuration = configuration
    self.eventListener = eventListener
  }

  public var body: some View {
    Button(configuration.title) {
      eventListener?(.tap)
    }
  }
}

public extension AComponent {
  struct Configuration {
    let title: String
    let mode: Mode
  }

  enum Mode {
    case normal
    case selected
    case disabled
  }

  enum Event {
    case tap
  }

  typealias EventListener = (Event) -> Void
}
```

나쁜 예:

```swift
public init(
  title: String,
  isSelected: Bool,
  mode: String,
  onTap: @escaping () -> Void,
  onLongPress: @escaping () -> Void
)
```

문제:

- 생성자 파라미터가 늘어날수록 API가 빠르게 불안정해집니다.
- UI 설정 값과 이벤트 전달 경로가 섞여 역할이 흐려집니다.
- 이벤트가 늘어날 때 시그니처 변경 범위가 커집니다.

## 체크리스트

- [ ] 생성자가 `configuration`을 필수로 받는가
- [ ] `eventListener`가 필요한 경우에만 옵셔널로 노출되는가
- [ ] `Configuration`이 UI 정보만 담고 있는가
- [ ] `Configuration`에 액션 클로저나 외부 의존성이 없는가
- [ ] `eventListener`가 `Event enum`을 받는 closure 형태로 정의되었는가
- [ ] 이벤트가 `Event` enum 기반으로 타입 안전하게 정의되었는가
- [ ] `<Name>Component.swift`, `<Name>Component+Configuration.swift`, `<Name>Component+Event.swift`가 분리되어 있는가
- [ ] 계산 로직이 복잡한 경우 `<Name>Component+Calculate.swift`로 분리했는가
- [ ] 하위 뷰가 `Components/` 디렉토리로 분리되어 있는가

## 참고

- 디자인 토큰, Tier 분류 기준은 `.agents/rules/design-guide.md`를 따릅니다.
