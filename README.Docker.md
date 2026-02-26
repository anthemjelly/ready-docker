# README.docker.md - Docker 部署詳細指南
[![Docker Build](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://docs.docker.com/)
[![Docker Compose](https://img.shields.io/badge/Compose-v2.0+-green.svg)](https://docs.docker.com/compose/)

## 📋 檔案說明
本文件專門說明專案的 Docker 容器化部署細節，包含鏡像構建、容器管理、環境配置等核心操作，建議與專案主 README.md 搭配使用。

## 🛠️ 環境準備
### 1. 安裝 Docker
- **Linux**
  ```bash
  # Ubuntu/Debian
  sudo apt update && sudo apt install -y docker.io docker-compose-plugin
  sudo usermod -aG docker $USER  # 免 sudo 使用 Docker
  # 重啟終端機生效
  ```
- **macOS**
  下載安裝 [Docker Desktop](https://www.docker.com/products/docker-desktop/)（內含 Docker Compose）
- **Windows**
  下載安裝 [Docker Desktop](https://www.docker.com/products/docker-desktop/)（需開啟 WSL2）

### 2. 驗證安裝
```bash
docker --version          # 檢查 Docker 版本
docker compose version    # 檢查 Compose 版本
docker run hello-world    # 測試 Docker 運行
```

## 🔧 核心配置檔說明
### 1. Dockerfile
專案根目錄的 `Dockerfile` 定義鏡像構建規則，範例結構如下：
```dockerfile
# 階段1：構建依賴（多階段構建，減小最終鏡像體積）
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install

# 階段2：生產環境鏡像
FROM node:18-alpine
WORKDIR /app
# 複製構建階段的依賴
COPY --from=builder /app/node_modules ./node_modules
# 複製應用程式程式碼
COPY . .
# 暴露應用端口
EXPOSE 3000
# 啟動命令（確保前台運行）
CMD ["node", "app.js"]
```

### 2. docker-compose.yml
定義多容器編排，支援服務依賴、環境變量、數據持久化等：
```yaml
version: '3.8'

# 自定義網路（隔離專案網路）
networks:
  app-network:
    driver: bridge

# 數據卷（持久化數據）
volumes:
  app-data:    # 應用數據卷
  logs-data:   # 日誌數據卷

services:
  # 主應用服務
  app:
    build:
      context: .          # 構建上下文（專案根目錄）
      dockerfile: Dockerfile
    restart: always       # 容器異常退出自動重啟
    ports:
      - "80:3000"         # 主機端口:容器端口
    environment:
      - NODE_ENV=production
      - DB_HOST=mysql     # 連接同一網路的 mysql 服務
      - DB_PORT=3306
    volumes:
      - app-data:/app/data
      - logs-data:/app/logs
    networks:
      - app-network
    depends_on:
      - mysql             # 依賴 mysql 服務，先啟動 mysql

  # 資料庫服務（範例）
  mysql:
    image: mysql:8.0
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=your_password
      - MYSQL_DATABASE=app_db
    volumes:
      - mysql-data:/var/lib/mysql
    networks:
      - app-network
    ports:
      - "3306:3306"

volumes:
  mysql-data:
```

### 3. .dockerignore
排除無需打包到鏡像的檔案，減小鏡像體積：
```
# 依賴目錄
node_modules/
venv/
__pycache__/

# 版本控制
.git/
.gitignore

# 日誌
logs/
*.log

# 環境配置
.env
.env.local
.dockerignore
Dockerfile
docker-compose.yml

# 編輯器配置
.idea/
.vscode/
*.swp
*.swo

# 構建產物
dist/
build/
```

## 🚀 常用操作指令
### 1. 基礎操作
```bash
# 構建並啟動所有服務（後台運行）
docker compose up -d --build

# 啟動已構建的服務
docker compose up -d

# 查看運行中的容器
docker compose ps

# 查看服務日誌（跟蹤實時日誌）
docker compose logs -f app  # 只看 app 服務日誌
docker compose logs -f     # 看所有服務日誌

# 停止所有服務（保留容器）
docker compose stop

# 停止並刪除容器、網路（保留數據卷）
docker compose down

# 停止並刪除容器、網路、數據卷（徹底清理）
docker compose down -v
```

### 2. 進階操作
```bash
# 進入運行中的容器
docker compose exec app /bin/sh  # Alpine 系統用 /bin/sh
docker compose exec app /bin/bash # Ubuntu/Debian 用 /bin/bash

# 手動構建鏡像
docker build -t your-image-name:latest .

# 推送鏡像到倉庫
docker tag your-image-name:latest your-registry/your-image-name:latest
docker push your-registry/your-image-name:latest

# 清理無用的鏡像/容器/數據卷
docker system prune -a  # 清理所有無用資源
docker volume prune     # 清理未使用的數據卷
```

## ⚡ 優化建議
### 1. 鏡像優化
- 使用**多階段構建**（Multi-stage build）減小鏡像體積
- 選擇輕量級基礎鏡像（如 `alpine` 版本，而非 `debian`/`ubuntu`）
- 合理使用 `.dockerignore`，排除無關檔案
- 鏡像層緩存：將不常變動的指令（如安裝依賴）放在前面

### 2. 性能優化
- 容器資源限制：在 `docker-compose.yml` 中添加 `deploy` 配置
  ```yaml
  services:
    app:
      deploy:
        resources:
          limits:
            cpus: '0.5'    # 最多使用 0.5 個 CPU 核心
            memory: 512M   # 最多使用 512MB 內存
  ```
- 避免容器內運行多個進程，一個容器只負責一個服務
- 使用數據卷（Volume）而非綁定掛載（Bind Mount）存儲持久化數據

### 3. 生產環境建議
- 不要在鏡像中存放敏感資訊（如密碼、金鑰），改用環境變量或秘密管理工具
- 啟用容器自動重啟（`restart: always` 或 `restart: unless-stopped`）
- 使用私有鏡像倉庫管理自定義鏡像
- 配置日誌驅動（如 ELK Stack）收集容器日誌

## ❌ 常見問題排查
| 問題現象 | 可能原因 | 解決方案 |
|----------|----------|----------|
| 容器啟動後立即退出 | 啟動命令為後台運行、應用異常退出 | 檢查 `CMD`/`ENTRYPOINT` 確保前台運行；查看日誌 `docker compose logs` |
| 端口映射失敗 | 端口被佔用、容器內應用未綁定 0.0.0.0 | 更換主機端口；確保應用綁定 `0.0.0.0` 而非 `127.0.0.1` |
| 鏡像構建緩慢 | 網路問題、基礎鏡像過大 | 更換國內鏡像源；使用輕量級基礎鏡像 |
| 容器間無法通信 | 不在同一網路、服務名解析失敗 | 確保服務加入同一自定義網路；使用服務名（而非 IP）通信 |
| 數據持久化失敗 | 數據卷配置錯誤、權限問題 | 檢查 `volumes` 路徑；手動設置目錄權限 `chmod 777`（測試用） |

## 📞 支援與反饋
若遇到 Docker 部署相關問題，可參考以下資源：
- [Docker 官方文檔](https://docs.docker.com/)
- [Docker Compose 官方文檔](https://docs.docker.com/compose/)
- 提交 Issue 到專案倉庫，標註「Docker 部署」標籤