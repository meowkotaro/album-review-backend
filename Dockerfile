FROM node:20.17.0

# 必要なツールをインストール
RUN apt-get update && apt-get install -y \
    iputils-ping \
    netcat-openbsd \
    dnsutils \
    openssh-client \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# .envファイルをコピー
COPY .env /usr/src/app/.env

# パッケージファイルをコピーし、依存関係をインストール
COPY package*.json ./
RUN npm ci --only=production

# @nestjs/cliをインストール
RUN npm install -g @nestjs/cli

# ソースコードをコピー
COPY . .

# 環境変数をロード
ENV $(cat /usr/src/app/.env | xargs)

# SSHキーの生成とGitHubにSSHキーを追加するスクリプト
RUN ssh-keygen -t rsa -b 4096 -C "$GIT_USER_EMAIL" -N "" -f /root/.ssh/id_rsa && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    curl -H "Authorization: token $GITHUB_TOKEN" \
         -d "{\"title\":\"$(date)\",\"key\":\"$(cat /root/.ssh/id_rsa.pub)\"}" \
         https://api.github.com/user/keys

# Gitの設定
RUN git config --global user.email "$GIT_USER_EMAIL" && \
    git config --global user.name "$GIT_USER_NAME"

# プロダクション用にビルド
RUN npm run build

# 手動でアプリケーションを開始するためのコマンド
CMD ["tail", "-f", "/dev/null"]