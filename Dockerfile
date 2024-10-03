FROM node:20.17.0

RUN apt-get update && apt-get install -y \
    iputils-ping \
    netcat-openbsd \
    dnsutils \
    openssh-client \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --only=production

RUN npm install -g @nestjs/cli

COPY . .

RUN npm run build

# SSHキーの生成とGitHubの設定を行うスクリプト
COPY setup-ssh.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-ssh.sh

# .sshディレクトリを作成し、権限を設定
RUN mkdir -p /home/node/.ssh && chown -R node:node /home/node/.ssh && chmod 700 /home/node/.ssh

USER node

# コンテナ起動時にsetup-ssh.shを実行
CMD ["/bin/bash", "-c", "/usr/local/bin/setup-ssh.sh && tail -f /dev/null"]