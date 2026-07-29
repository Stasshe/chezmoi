# GitHub bootstrap

Sayaとchezmoiを導入する前のUbuntuで、cloneに必要なものだけを入れる。

```bash
sudo apt update
sudo apt install -y ca-certificates curl git openssh-client
```

SSH鍵を作り、公開鍵をGitHubへ登録する。

```bash
ssh-keygen -t ed25519 -C "YOUR_EMAIL@example.com" -f ~/.ssh/id_ed25519
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
cat ~/.ssh/id_ed25519.pub
ssh -T git@github.com
```

clone後の`./setups.sh`がGitHub CLIをSaya経由で導入する。認証は導入後に行う。

```bash
gh auth login
gh auth status
```
