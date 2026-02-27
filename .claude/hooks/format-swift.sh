#!/bin/bash
# Hook: format-swift
# Type: PostToolUse
# Matcher: Edit|Write
# Purpose: Swift 파일 수정 후 자동 포맷팅

set -euo pipefail

# stdin에서 JSON 입력 읽기
input=$(cat)

# file_path 추출
file_path=$(echo "$input" | jq -r '.tool_input.file_path // ""')

# .swift 파일인 경우에만 포맷팅 실행
if [[ "$file_path" == *.swift ]]; then
    # 파일이 실제로 존재하는지 확인
    if [ -f "$file_path" ]; then
        # swiftformat 실행 (에러는 무시하여 훅이 실패하지 않도록 함)
        swiftformat "$file_path" 2>/dev/null || true
    fi
fi

# 필수: stdin 데이터를 stdout으로 패스스루
echo "$input"
