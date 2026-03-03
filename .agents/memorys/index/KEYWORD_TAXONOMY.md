# 키워드 분류(Keywords Taxonomy)

## 목적(Purpose)
검색 정확도를 높이기 위해 메모리 키워드 작성 규칙을 통일합니다.

## 분류 체계(Schema)
- `workflow`: branch / rebase / commit / pr / review / build / test / release
- `action`: create / edit / restore / revert / delete / push / merge
- `failure`: scope-creep / conflict / convention-miss / tool-limit / permission / regression
- `target`: module:{name} / file:{path} / dir:{path}
- `risk`: low / medium / high
- `verify`: build / test / lint / manual-check / diff-check

## 작성 예시(Examples)
- `workflow:rebase`
- `action:restore`
- `failure:scope-creep`
- `target:file:SeukCalendar/Feature/BaseFeature/View/ToolBar/ToolBar.swift`
- `risk:medium`
- `verify:diff-check`
