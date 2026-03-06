#!/bin/bash
# 出错立即停止
set -e

# 版本號
VERSION="v1.0.0"

# 构建通用核心镜像
echo "🔨 构建通用基础镜像..."
docker compose -f ./.devcontainer/compose.yml build core --no-cache
docker tag anthemjelly/ready-docker-core:latest anthemjelly/ready-docker-core:$VERSION

echo "🔨 构建 Python 专属镜像..."
docker compose -f ./.devcontainer/compose.yml build python --no-cache
docker tag anthemjelly/ready-docker-python:latest anthemjelly/ready-docker-python:$VERSION

echo "✅ 所有镜像构建完成！"
docker compose -f ./.devcontainer/compose.yml build discord --no-cache
docker tag anthemjelly/ready-docker-discord:latest anthemjelly/ready-docker-discord:$VERSION


# 一次全推送
echo "推送鏡像..."
docker push anthemjelly/ready-docker-core:latest
docker push anthemjelly/ready-docker-core:$VERSION

docker push anthemjelly/ready-docker-python:latest
docker push anthemjelly/ready-docker-python:$VERSION

docker push anthemjelly/ready-docker-discord:latest
docker push anthemjelly/ready-docker-discord:$VERSION

# 清理空鏡像
docker image prune -f

echo "✅ 建構 + 雙標籤 + 推送 全部完成！"