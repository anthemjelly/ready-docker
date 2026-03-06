#!/bin/bash
# 出错立即停止
set -e

# 构建通用核心镜像
echo "🔨 构建通用基础镜像..."
docker compose -f ./.devcontainer/compose.yml build core --no-cache

echo "🔨 构建 Python 专属镜像..."
docker compose -f ./.devcontainer/compose.yml build python --no-cache

echo "✅ 所有镜像构建完成！"
docker compose -f ./.devcontainer/compose.yml build discord --no-cache