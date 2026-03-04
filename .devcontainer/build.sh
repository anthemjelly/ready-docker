#!/bin/bash
set -e  # 出错立即停止

# 1. 构建通用核心镜像
echo "🔨 构建通用基础镜像..."
docker compose build core-dev --no-cache

# 2. 构建 Python 专属镜像
echo "🔨 构建 Python 专属镜像..."
docker compose build python-dev --no-cache

echo "✅ 所有镜像构建完成！"
docker compose build discord-dev --no-cache