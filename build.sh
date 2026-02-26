#!/bin/bash
set -e  # 出错立即停止

# 1. 构建通用核心镜像
echo "🔨 构建通用基础镜像..."
docker build -f core/Dockerfile.base -t ready-docker-base:latest .

# 2. 构建 Python 专属镜像
echo "🔨 构建 Python 专属镜像..."
docker build -f lang/python/Dockerfile.python -t ready-docker-python:latest .

echo "✅ 所有镜像构建完成！"
echo "👉 启动 WebAPI：docker-compose -f scenarios/python-webapi/docker-compose.yml up -d"