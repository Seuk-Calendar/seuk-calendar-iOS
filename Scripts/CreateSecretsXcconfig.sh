#!/bin/bash
# Secrets.xcconfig 파일을 환경변수로부터 생성합니다.
#
# 이 파일은 gitignored 되어 있어 CI 환경에서 매번 새로 생성해야 합니다.
# GitHub Secrets에 저장된 값들이 환경변수로 주입된 상태에서 실행됩니다.
#
# 사용법:
# Scripts/CreateSecretsXcconfig.sh
#
# 필요한 환경변수:
#   KAKAO_NATIVE_APP_KEY   — 카카오 SDK 네이티브 앱 키
#   NID_APP_NAME           — 네이버 로그인 앱 이름
#   NID_URL_SCHEME         — 네이버 로그인 URL 스킴
#   NID_CLIENT_ID          — 네이버 Client ID
#   NID_CLIENT_SECRET      — 네이버 Client Secret
#
# 출력 파일:
#   Pool/Pool/App/Resources/Secrets.xcconfig

set -euo pipefail

OUTPUT_PATH="Pool/Pool/App/Resources/Secrets.xcconfig"

cat > "$OUTPUT_PATH" << XCCONFIG
KAKAO_NATIVE_APP_KEY = ${KAKAO_NATIVE_APP_KEY}
NID_APP_NAME = ${NID_APP_NAME}
NID_URL_SCHEME = ${NID_URL_SCHEME}
NID_CLIENT_ID = ${NID_CLIENT_ID}
NID_CLIENT_SECRET = ${NID_CLIENT_SECRET}
XCCONFIG

echo "✅ Secrets.xcconfig 생성 완료: $OUTPUT_PATH"
