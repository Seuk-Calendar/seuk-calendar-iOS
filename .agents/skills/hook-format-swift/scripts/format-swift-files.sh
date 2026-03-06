#!/bin/bash
set -euo pipefail

if ! command -v swiftformat >/dev/null 2>&1; then
  echo "swiftformat not found. Please install SwiftFormat first." >&2
  exit 127
fi

files=()

if [ "$#" -gt 0 ]; then
  for file in "$@"; do
    if [[ "$file" == *.swift ]] && [ -f "$file" ]; then
      files+=("$file")
    fi
  done
else
  while IFS= read -r file; do
    [ -n "$file" ] && files+=("$file")
  done < <(
    {
      git diff --name-only -- '*.swift'
      git diff --cached --name-only -- '*.swift'
      git ls-files --others --exclude-standard -- '*.swift'
    } | sort -u
  )
fi

if [ "${#files[@]}" -eq 0 ]; then
  echo "No Swift files to format."
  exit 0
fi

for file in "${files[@]}"; do
  swiftformat "$file"
  echo "formatted: $file"
done
