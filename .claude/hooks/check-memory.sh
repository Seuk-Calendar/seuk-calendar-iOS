#!/bin/bash
# Hook: check-memory
# Type: UserPromptSubmit
# Purpose: 사용자 입력 키워드로 memory 문서를 검색해 사전 점검 체크리스트를 주입

set -euo pipefail

input="$(cat || true)"
if [ -z "${input//[[:space:]]/}" ]; then
  exit 0
fi

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
memory_root="$project_dir/.agents/memorys"
entries_dir="$memory_root/entries"

if [ ! -d "$memory_root" ]; then
  exit 0
fi

if [ ! -d "$entries_dir" ]; then
  exit 0
fi

input_lower="$(printf "%s" "$input" | tr '[:upper:]' '[:lower:]')"
keywords="$(
  printf "%s" "$input_lower" \
    | tr -cs '[:alnum:]가-힣#/_-' '\n' \
    | awk 'length($0) >= 2' \
    | grep -Ev '^(그리고|그냥|이번|다음|먼저|이어서|작업|명령|해줘|해주세요|좀|를|을|이|가|은|는|에|에서|와|과|for|with|this|that|then|from|into|after|before|please|and|the)$' \
    | sort -u \
    | head -n 20 || true
)"

if [ -z "$keywords" ]; then
  exit 0
fi

pattern="$(printf "%s\n" "$keywords" | paste -sd'|' -)"
matched_files="$(rg -l --glob '*.md' -S -e "$pattern" "$entries_dir" 2>/dev/null | head -n 5 || true)"

if [ -z "$matched_files" ]; then
  exit 0
fi

echo "---"
echo "🧠 관련 메모리(Memory) 사전 검색"
echo

echo "입력 키워드(Keywords): $(printf "%s\n" "$keywords" | head -n 8 | paste -sd ',' - | sed 's/,/, /g')"
echo

echo "사전 점검(Pre-Command Check):"
while IFS= read -r file; do
  [ -z "$file" ] && continue

  title="$(awk '/^## 제목\(Title\)/ {getline; print; exit}' "$file" | sed 's/^[[:space:]-]*//')"
  [ -z "$title" ] && title="$(basename "$file")"

  echo "- ${title} ($(basename "$file"))"

  precheck="$(awk '
    /^## 사전 점검\(Pre-Command Check\)/ {capture=1; next}
    /^## / {if (capture==1) exit}
    capture==1 {print}
  ' "$file" | sed 's/^[[:space:]-]*//' | sed '/^$/d' | head -n 3)"

  if [ -z "$precheck" ]; then
    precheck="$(awk '
      /^## 예방 규칙\(Prevention Rule\)/ {capture=1; next}
      /^## / {if (capture==1) exit}
      capture==1 {print}
    ' "$file" | sed 's/^[[:space:]-]*//' | sed '/^$/d' | head -n 2)"
  fi

  if [ -n "$precheck" ]; then
    while IFS= read -r line; do
      [ -z "$line" ] && continue
      echo "  - $line"
    done <<< "$precheck"
  else
    echo "  - 상세 체크 항목은 파일을 확인하세요."
  fi
done <<< "$matched_files"

echo
echo "참고 파일(Files):"
printf "%s\n" "$matched_files" | sed 's#^#- #' 
