#!/bin/bash
# 出錯立即停止
set -e

START_TIME=$(date +%s)

# 版本號
VERSION="v1.0.0"

# 构建鏡像
docker compose -f ./.devcontainer/compose.yml build
# echo "🔨 构建通用基础镜像..."
# docker compose -f ./.devcontainer/compose.yml build core --no-cache
# docker tag anthemjelly/ready-docker-core:latest anthemjelly/ready-docker-core:$VERSION

# echo "🔨 构建 Python 专属镜像..."
# docker compose -f ./.devcontainer/compose.yml build python --no-cache
# docker tag anthemjelly/ready-docker-python:latest anthemjelly/ready-docker-python:$VERSION

# echo "✅ 所有镜像构建完成！"
# docker compose -f ./.devcontainer/compose.yml build discord --no-cache
# docker tag anthemjelly/ready-docker-discord:latest anthemjelly/ready-docker-discord:$VERSION


# 打上版本標籤
echo "🏷️  打上版本標籤..."
docker tag anthemjelly/ready-docker-core:latest    anthemjelly/ready-docker-core:${VERSION}
docker tag anthemjelly/ready-docker-python:latest  anthemjelly/ready-docker-python:${VERSION}
docker tag anthemjelly/ready-docker-discord:latest anthemjelly/ready-docker-discord:${VERSION}

# 3. 推送所有標籤
echo "📤 推送鏡像到 Docker Hub..."
docker push anthemjelly/ready-docker-core:latest
docker push anthemjelly/ready-docker-core:${VERSION}

docker push anthemjelly/ready-docker-python:latest
docker push anthemjelly/ready-docker-python:${VERSION}

docker push anthemjelly/ready-docker-discord:latest
docker push anthemjelly/ready-docker-discord:${VERSION}

# 清理空鏡像
docker image prune -f

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "✅ 全部完成！總耗時：${DURATION} 秒"