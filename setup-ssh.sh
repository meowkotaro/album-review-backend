
SSH_DIR="/home/node/.ssh"
SSH_KEY_PATH="${SSH_DIR}/id_rsa"

# SSHキーが存在しない場合のみ生成
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$GIT_USER_EMAIL" -N "" -f "$SSH_KEY_PATH"

    # known_hostsファイルにGitHubを追加
    ssh-keyscan github.com >> "${SSH_DIR}/known_hosts"

    # SSHキーの権限を設定
    chmod 600 "$SSH_KEY_PATH"
    chmod 644 "${SSH_KEY_PATH}.pub"
    chmod 644 "${SSH_DIR}/known_hosts"

    # GitHubにSSHキーを追加
    if [ -n "$GITHUB_TOKEN" ]; then
        echo "Adding SSH key to GitHub..."
        curl -H "Authorization: token $GITHUB_TOKEN" \
             -d "{\"title\":\"Docker-generated key $(date)\",\"key\":\"$(cat ${SSH_KEY_PATH}.pub)\"}" \
             https://api.github.com/user/keys
    else
        echo "GITHUB_TOKEN not set. Skipping GitHub key registration."
    fi
else
    echo "SSH key already exists. Skipping generation."
fi

# Gitの設定
if [ -n "$GIT_USER_EMAIL" ] && [ -n "$GIT_USER_NAME" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
    git config --global user.name "$GIT_USER_NAME"
else
    echo "GIT_USER_EMAIL or GIT_USER_NAME not set. Skipping Git configuration."
fi

# SSHエージェントを起動し、キーを追加
eval $(ssh-agent -s)
ssh-add "$SSH_KEY_PATH"

exec "$@"