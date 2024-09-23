FROM node:20.17.0

# 必要なツールをインストール
RUN apt-get update && apt-get install -y \
    iputils-ping \
    netcat-openbsd \
    dnsutils \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# パッケージファイルをコピーし、依存関係をインストール
COPY package*.json ./
RUN npm ci --only=production

# ソースコードをコピー
COPY . .

# プロダクション用にビルド
RUN npm run build

# 開発モードで起動
CMD ["npm", "run", "start:dev"]