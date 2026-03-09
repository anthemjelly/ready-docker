# 通用 Docker 打包盒
一套支援**分層構建、多語言擴展、零重複配置**的 Docker 模板，適合作為所有 Docker 專案的「基礎工具箱」。

## 📦 核心概念（簡單易懂）
把 Docker 鏡像拆成 3 層「積木」，需要什麼就疊什麼：
| 層級         | 作用                                  | 類比                  |
|--------------|---------------------------------------|-----------------------|
| `core`       | 通用基礎（系統、工具、時區）          | 所有房子都用的「地基」|
| `lang/`      | 語言專屬（Python/Node.js 環境）      | 不同風格的「房屋框架」|
| `scenarios/` | 場景化組裝（WebAPI/CLI 工具）        | 裝修好的「具體房子」  |

## 📁 目錄結構
```
ready-docker/
├── core/                  # 通用基礎（所有場景複用）
│   ├── Dockerfile.base    # 基礎鏡像構建檔
│   ├── .dockerignore      # 通用忽略規則
│   └── scripts/           # 通用腳本（健康檢查、時區設定）
├── lang/                  # 語言專屬（可擴展）
│   └── python/            # Python 環境
│       ├── Dockerfile.python
│       ├── requirements/  # Python 依賴分層
│       │   ├── base.txt   # 通用依賴（pip、setuptools）
│       │   └── webapi.txt # WebAPI 專屬（fastapi、uvicorn）
│       └── scripts/       # Python 專屬腳本
├── scenarios/             # 場景化組裝（你的業務）
│   └── example/           # 你的 場景
│       ├── Dockerfile
│       ├── docker-compose.yml
│       └── .env.example
├── build.sh               # 一鍵構建所有鏡像
└── README.md              # 本文件
```

## 🚀 快速開始（3 步搞定）
### 前置條件
- 已安裝 Docker（版本 ≥ 20.10）
- 已啟動 Docker 服務

### 操作步驟
1. **給構建腳本加執行權限**
   ```bash
   chmod +x build.sh
   ```
2. **一鍵構建所有鏡像**
   ```bash
   ./build.sh
   ```
3. **啟動你的場景**
   ```bash
   docker volume create db-discord # 使用前請先創建數據卷，視乎你使用的專案
   docker compose up
   ```
   若不在意的話，可以選擇自動生成數據卷，打開生產用的compose.yml
   ```YAML
   volumes:
      db-discord:
      # 改這行
      external: false
   ```

## 🔧 如何擴展其他語言（以 Node.js 為例）
1. 在 `lang/` 下建立 `nodejs/` 目錄
2. 新增 `lang/nodejs/Dockerfile.nodejs`（基於 `core/Dockerfile.base`）
3. 在 `build.sh` 中添加 Node.js 鏡像的構建命令
4. 在 `scenarios/` 下建立對應的場景目錄（如 `nodejs-express`）

## 📄 許可證
本項目採用  GNU GENERAL PUBLIC LICENSE 許可證 - 詳見 [LICENSE](LICENSE) 文件