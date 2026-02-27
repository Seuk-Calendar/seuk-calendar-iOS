#!/bin/bash
# 추후 경로를 상대 경로로 전환하기
TEMPLATE_DIR=~/Library/Developer/Xcode/Templates
POOL_TEMPLATE_PATH="$TEMPLATE_DIR/PoolTemplates"

if [ -d "$TEMPLATE_DIR" ]; then
    echo "✅ Template 디렉토리가 존재합니다."
else
    mkdir -p $TEMPLATE_DIR
    echo "📂 Templates 디렉토리를 생성했습니다."
fi

# PoolTemplate 복사 (덮어쓰기)
cp -R -f ./PoolTemplates "$TEMPLATE_DIR"

if [ -d "$POOL_TEMPLATE_PATH" ]; then
    echo "✅ Template 업데이트에 성공했습니다."
else
    echo "❌ Template 생성에 실패했습니다."
fi