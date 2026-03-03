# ViewModel Convention

Feature 레이어의 ViewModel 파일 구조 및 의존성 주입 규칙입니다.

## 파일 구조

모든 ViewModel은 아래 3개 파일 구조를 기본으로 사용합니다.

```
SomeViewModel.swift
SomeViewModel+Action.swift
SomeViewModel+Model.swift
```

- `SomeViewModel.swift`
  - 상태(State) 및 로직 구현
  - 의존성 주입(Repository/UseCase 등)
  - `send(_:)` 액션 처리 진입점

- `SomeViewModel+Action.swift`
  - `Action` enum만 정의
  - 액션 분류 기준(Lifecycle, ViewAction 등)은 feature 상황에 맞춰 유지
  - 액션 수가 많아지면 `nested enum`으로 세분화
    - 예: `Action.lifecycle(LifecycleAction)`, `Action.view(ViewAction)`, `Action.internal(InternalAction)`
  - Action 처리 메서드(`send(_:)`, `handle(action:)` 등)도 nested enum 기준으로 분기 처리

- `SomeViewModel+Model.swift`
  - `ViewState`, `ViewMode`, `PermissionState` 등 ViewModel 보조 enum 정의
  - Action 이외의 모델성 타입은 이 파일에 우선 배치

## 의존성 주입 규칙

- View는 ViewModel을 **필수 주입**받습니다.
  - 허용: `init(viewModel: SomeViewModel)`
  - 금지: `init(viewModel: SomeViewModel? = nil)`, View 내부 fallback 생성

- Factory가 ViewModel 생성 책임을 가집니다.
  - DIContainer 도입 전: `makeView()` 내부에서 ViewModel 생성 후 주입
  - DIContainer 도입 후: 컨테이너에서 resolve한 ViewModel을 주입

## 금지 사항

- `SomeViewModel.swift` 내부에 `Action` enum을 직접 선언한 채 유지하지 않습니다.
- View 내부에서 `SomeViewModel()`을 직접 생성하지 않습니다.
- 아직 도입되지 않은 DI 구조를 위해 Factory를 과도하게 추상화하지 않습니다.

## 검증 체크리스트

- `Action` enum이 `SomeViewModel+Action.swift`에 분리되어 있는가?
- 액션이 많을 때 `Action`이 nested enum으로 세분화되어 있는가?
- 액션 처리 메서드가 nested enum 구조에 맞춰 분기되는가?
- 보조 enum이 `SomeViewModel+Model.swift`에 분리되어 있는가?
- View init이 필수 주입 시그니처인가?
- Factory가 ViewModel 생성/주입 책임을 수행하는가?
