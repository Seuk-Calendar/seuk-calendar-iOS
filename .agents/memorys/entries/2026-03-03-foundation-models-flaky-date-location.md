## 제목(Title)
- Foundation Models 출력 변동을 그대로 신뢰해 날짜/장소 테스트가 플레이키해진 사례

## 날짜(Date)
- 2026-03-03

## 유형(Type)
- anti-pattern

## 키워드(Keywords)
- workflow:test
- action:normalize-fm-result
- failure:flaky-output
- target:AI/FoundationModelsParser
- risk:wrong-event-date
- verify:repeated-only-testing

## 컨텍스트(Context)
- Foundation Models 기반 파싱 테스트에서 동일 입력이 실행마다 다른 날짜(예: 03-08/03-10/03-11)와 nil 장소를 반환했다.

## 문제 행동(Bad Action)
- 모델 출력 값을 그대로 신뢰하고, 텍스트에 날짜/시간/장소 신호가 있어도 휴리스틱 보정 우선순위를 약하게 두었다.

## 사용자 피드백(User Feedback)
- "Expectation failed: parsed.dateString이 2026-03-13이 아니라 2026-03-11"
- "앱에서 여러 번 돌리면 03-13은 안 나오고 8일/10일이 나온다"
- "홍대 인식이 될 때도 있고 안 될 때도 있다"

## 원인(Root Cause)
- LLM 추론 결과의 비결정성을 테스트 기대값과 동일 수준의 신뢰도로 취급했다.
- "다음주/담주" 같은 상대 날짜 신호가 있을 때 요일 해석 실패 시 기준일로 떨어질 수 있는 경로가 있었다.

## 예방 규칙(Prevention Rule)
- 날짜/시간/장소 신호가 텍스트에 존재하면 해당 필드는 휴리스틱 결과를 우선 적용한다.
- "다음주/담주" 신호가 있는데 요일을 해석하지 못하면 기준일 보정 대신 실패(nil) 처리한다.

## 사전 점검(Pre-Command Check)
- preferFoundationModels=true 테스트가 고정 기대값을 가지는지 확인했는가?
- 날짜/장소 필드에 대해 "모델 결과 != 휴리스틱"일 때 어느 쪽을 우선할지 명시했는가?

## 금지 동작(Do Not Do)
- 자연어 일정 파싱 테스트에서 모델 응답을 단일 정답처럼 가정하지 않는다.

## 안전 대안(Safe Alternative)
- 모델 결과를 구조화 보조값으로만 사용하고, 규칙 기반(휴리스틱) 파서를 최종 정합 레이어로 둔다.

## 검증 단계(Verification Step)
- `xcodebuild ... -scheme AI test` 전체 통과 확인
- `-only-testing:AITests/parseNextWeekFridayEvening` 반복 실행(3회 이상) 통과 확인

## 적용 범위(Scope)
- AI 모듈의 자연어 일정 파싱 및 관련 테스트

## 심각도(Severity)
- high

## 예시(Examples)
- 나쁜 예(Bad): 모델이 반환한 dateString/location을 조건 없이 그대로 저장
- 좋은 예(Good): 텍스트에서 날짜/시간/장소 신호를 감지하면 휴리스틱 결과로 정규화 후 저장

## 관련 메모리(Related Memories)
- entries/2026-03-03-core-safe-index-regex-capture.md
