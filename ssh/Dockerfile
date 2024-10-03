# ssh/Dockerfile

FROM alpine:latest

# 必要なツールをインストール
RUN apk add --no-cache \
    openssh \
    curl \
    git \
    && mkdir -p /root/.ssh

# 環境変数をロード
ENV $(cat /usr/src/app/.env | xargs)

# SSHキーの生成とGitHubにSSHキーを追加するスクリプト
RUN ssh-keygen -t rsa -b 4096 -C "$GIT_USER_EMAIL" -N "" -f /root/.ssh/id_rsa && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    curl -H "Authorization: token $GITHUB_TOKEN" \
         -d "{\"title\":\"$(date)\",\"key\":\"$(cat /root/.ssh/id_rsa.pub)\"}" \
         https://api.github.com/user/keys

# Gitの設定（必要に応じて）
RUN git config --global user.email "$GIT_USER_EMAIL" && \
    git config --global user.name "$GIT_USER_NAME"

# コンテナ起動時にSSHエージェントを実行
CMD ["sh", "-c", "eval $(ssh-agent -s) && ssh-add /root/.ssh/id_rsa && tail -f /dev/null"]