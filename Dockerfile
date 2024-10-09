FROM node:20.17.0

RUN apt-get update && apt-get install -y \
    iputils-ping \
    netcat-openbsd \
    dnsutils \
    openssh-client \
    git \
    && rm -rf /var/lib/apt/lists/*

# nodeユーザーに切り替え
USER node

WORKDIR /usr/src/app

# パッケージファイルをコピー
COPY --chown=node:node package*.json ./

RUN npm ci

# ソースコードをコピー
COPY --chown=node:node . .

RUN npm run build

# SSHキーの生成とGitHubの設定を行うスクリプト
COPY --chown=node:node setup-ssh.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-ssh.sh

# .sshディレクトリを作成し、権限を設定
RUN mkdir -p /home/node/.ssh && chmod 700 /home/node/.ssh

# コンテナ起動時にsetup-ssh.shを実行
CMD ["/bin/bash", "-c", "/usr/local/bin/setup-ssh.sh && npm start"]