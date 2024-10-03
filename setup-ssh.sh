SSH_DIR="/home/node/.ssh"
SSH_KEY_PATH="${SSH_DIR}/id_rsa"

# SSHディレクトリが存在しない場合は作成
mkdir -p $SSH_DIR
chmod 700 $SSH_DIR

# SSHキーが存在しない場合のみ生成
if [ ! -f "$SSH_KEY_PATH" ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t rsa -b 4096 -C "$GIT_USER_EMAIL" -N "" -f "$SSH_KEY_PATH"

    # known_hostsファイルにGitHubを追加
    ssh-keyscan github.com >> ${SSH_DIR}/known_hosts

    # GitHubにSSHキーを追加
    echo "Adding SSH key to GitHub..."
    curl -H "Authorization: token $GITHUB_TOKEN" \
         -d "{\"title\":\"Docker-generated key $(date)\",\"key\":\"$(cat ${SSH_KEY_PATH}.pub)\"}" \
         https://api.github.com/user/keys
else
    echo "SSH key already exists. Skipping generation."
fi

# Gitの設定
git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"

# SSHエージェントを起動し、キーを追加
eval $(ssh-agent -s)
ssh-add "$SSH_KEY_PATH"

# SSHキーの権限を設定
chmod 600 "$SSH_KEY_PATH"
chmod 644 "${SSH_KEY_PATH}.pub"

exec "$@"