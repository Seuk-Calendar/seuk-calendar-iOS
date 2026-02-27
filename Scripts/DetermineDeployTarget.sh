#!/bin/bash
# 태그 정보를 기반으로 배포 대상(lane)을 결정합니다.
#
# 사용법:
# Scripts/DetermineDeployTarget.sh "${{ github.ref }}"
#
#   github_ref: GITHUB_REF 값 (e.g. refs/tags/v1.0.0-beta.1)
#
# 출력 (GITHUB_OUTPUT):
#   tag=v1.0.0-beta.1
#   lane=beta

set -euo pipefail

GITHUB_REF="$1"

# 태그 추출
TAG="${GITHUB_REF#refs/tags/}"

if [[ "$TAG" == "$GITHUB_REF" ]]; then
  echo "❌ 태그에서만 실행할 수 있습니다. (현재: $GITHUB_REF)"
  exit 1
fi

# lane 결정
if [[ "$TAG" == *"-beta"* ]]; then
  LANE="beta"
else
  LANE="release"
fi

echo "tag=$TAG" >> "$GITHUB_OUTPUT"
echo "lane=$LANE" >> "$GITHUB_OUTPUT"

echo "📦 Tag: $TAG"
echo "🎯 Lane: $LANE"
