#!/bin/bash
# Hook: check-rules
# Type: UserPromptSubmit
# Matcher: N/A (모든 프롬프트 제출 시 실행)
# Purpose: 프롬프트 키워드 기반 관련 규칙 자동 주입

set -euo pipefail

# stdin에서 사용자 입력 읽기
input=$(cat)

# 소문자로 변환하여 키워드 매칭
input_lower=$(echo "$input" | tr '[:upper:]' '[:lower:]')

# 규칙 파일 경로
rules_dir="$CLAUDE_PROJECT_DIR/.agents/rules"
injected_rules=""

# 커밋 관련 키워드 감지
if echo "$input_lower" | grep -qE "(커밋|commit)"; then
    if [ -f "$rules_dir/commit-convention.md" ]; then
        injected_rules="$injected_rules\n\n---\n📋 관련 규칙: 커밋 컨벤션\n\n$(cat "$rules_dir/commit-convention.md")"
    fi
fi

# PR 관련 키워드 감지
if echo "$input_lower" | grep -qE "(pr|풀리퀘스트|pull request|풀 리퀘스트)"; then
    if [ -f "$rules_dir/pr-convention.md" ]; then
        injected_rules="$injected_rules\n\n---\n📋 관련 규칙: PR 컨벤션\n\n$(cat "$rules_dir/pr-convention.md")"
    fi
fi

# 브랜치 관련 키워드 감지
if echo "$input_lower" | grep -qE "(브랜치|branch)"; then
    if [ -f "$rules_dir/branch-convention.md" ]; then
        injected_rules="$injected_rules\n\n---\n📋 관련 규칙: 브랜치 컨벤션\n\n$(cat "$rules_dir/branch-convention.md")"
    fi
fi

# 아키텍처 관련 키워드 감지
if echo "$input_lower" | grep -qE "(아키텍처|architecture|모듈|module)"; then
    if [ -f "$rules_dir/Architecture.md" ]; then
        injected_rules="$injected_rules\n\n---\n📋 관련 규칙: 아키텍처\n\n$(cat "$rules_dir/Architecture.md")"
    fi
fi

# 디자인시스템 관련 키워드 감지
if echo "$input_lower" | grep -qE "(디자인시스템|디자인 시스템|design system|designsystem)"; then
    if [ -f "$rules_dir/design-system-component-convention.md" ]; then
        injected_rules="$injected_rules\n\n---\n📋 관련 규칙: 디자인시스템 컴포넌트 컨벤션\n\n$(cat "$rules_dir/design-system-component-convention.md")"
    fi
fi

# 코드 리뷰 관련 키워드 감지
if echo "$input_lower" | grep -qE "(리뷰|review|code review|코드 리뷰|코드리뷰)"; then
    if [ -f "$rules_dir/code-review-convention.md" ]; then
        injected_rules="$injected_rules\n\n---\n📋 관련 규칙: 코드 리뷰 컨벤션\n\n$(cat "$rules_dir/code-review-convention.md")"
    fi
fi

# 규칙이 주입되었으면 stdout으로 출력
if [ -n "$injected_rules" ]; then
    echo -e "$injected_rules"
fi

exit 0
