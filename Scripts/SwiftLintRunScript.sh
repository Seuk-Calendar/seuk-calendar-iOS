#!/usr/bin/env bash

# 에러시 중단
set -euo pipefail

# Homebrew 경로 추가
if [ -d "/opt/homebrew/bin/" ]; then
    export PATH="/opt/homebrew/bin:${PATH}"
fi

# .swiftlint.yml 경로 계산 (scripts/.swiftlint.yml)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YML="${SCRIPT_DIR}/.swiftlint.yml"

# SwiftLint 실행
if command -v swiftlint >/dev/null 2>&1; then
    swiftlint --config "${YML}"
else
    echo """
    warning: SwiftLint not installed.
    Download from https://github.com/realm/SwiftLint
    or
    Download from brew install swiftlint
    """
    exit 0
fi
