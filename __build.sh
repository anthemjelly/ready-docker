#!/bin/bash
set -e

# 記錄開始時間
START_TIME=$(date +%s)

echo "🔨 開始構建（開發模式，不推送）..."

# 構建所有鏡像
docker compose -f ./.devcontainer/compose.yml build

# 計算總耗時
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "✅ 構建完成！總耗時：${DURATION} 秒"