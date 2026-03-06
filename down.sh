#!/bin/bash
# 出错立即停止
set -e

# 完全下架應用
echo "🔨 解構 容器 卷 鏡像..."
docker compose -f ./.devcontainer/compose.yml down -v --rmi all

echo "✅ 解構完成！"