# WSL に apt で GitHub CLI `gh` を入れて SSH 接続まで設定する

## 方針

`mise` や `brew` は使わず、Ubuntu / Debian 系 WSL の `apt` で `gh` を入れる。

推奨は次の構成。

* `gh`: GitHub CLI 公式 apt リポジトリからインストール
* `git`: Ubuntu の apt からインストール
* GitHub への Git 通信: SSH
* `gh` の認証: `gh auth login`
* SSH 鍵: `~/.ssh/id_ed25519`

---

## 1. 前提確認

WSL 側で実行する。

```bash
cat /etc/os-release
```

Ubuntu ならそのまま進める。

```bash
sudo apt update
sudo apt install -y git wget ca-certificates
```

---

## 2. GitHub CLI 公式 apt リポジトリを追加する

古い `apt-key` は使わない。`/etc/apt/keyrings` に keyring を置く。

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) \
  && wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
  && sudo apt update \
  && sudo apt install -y gh
```

確認する。

```bash
gh --version
```

アップデートは通常の apt と同じ。

```bash
sudo apt update
sudo apt install gh
```

---

## 3. Git の基本設定

```bash
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL@example.com"
git config --global init.defaultBranch main
```

確認する。

```bash
git config --global --list
```

GitHub のコミットに表示したいメールを使う。公開したくないなら GitHub の noreply メールを使う。

---

## 4. SSH 鍵を作る

既存の鍵を確認する。

```bash
ls -la ~/.ssh
```

なければ Ed25519 鍵を作る。

```bash
ssh-keygen -t ed25519 -C "YOUR_EMAIL@example.com" -f ~/.ssh/id_ed25519
```

聞かれる内容。

* passphrase: 付けるなら入力、不要なら空 Enter
* overwrite: 既存鍵がある場合だけ注意

権限を整える。

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

---

## 5. SSH agent に鍵を登録する

一時的に登録する。

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

確認する。

```bash
ssh-add -l
```

毎回 `ssh-add` したくない場合は、必要になった時点で考えればよい。まずは接続できることを優先する。

---

## 6. GitHub に公開鍵を登録する

公開鍵を表示する。

```bash
cat ~/.ssh/id_ed25519.pub
```

出力された 1 行をコピーして、GitHub に登録する。

場所:

```text
GitHub → Settings → SSH and GPG keys → New SSH key
```

Title は `WSL Ubuntu` などでよい。

Key には `id_ed25519.pub` の中身を貼る。

---

## 7. SSH の接続確認

```bash
ssh -T git@github.com
```

初回は次のように聞かれる。

```text
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

`yes` と入力する。

成功例。

```text
Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

これは成功。GitHub は SSH ログイン用の shell を提供しないので、この表示で正しい。

---

## 8. `gh auth login` で GitHub CLI を認証する

```bash
gh auth login
```

推奨選択。

```text
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? SSH
? Upload your SSH public key to your GitHub account? Skip
? How would you like to authenticate GitHub CLI? Login with a web browser
```

すでに手動で SSH 公開鍵を登録した場合、`Upload your SSH public key` は `Skip` でよい。

ブラウザ認証でコードが表示されたら、Windows 側のブラウザで開いて入力する。

認証後に確認する。

```bash
gh auth status
```

---

## 9. Git の remote を SSH にする

既存リポジトリで確認する。

```bash
git remote -v
```

HTTPS になっている例。

```text
origin  https://github.com/USER/REPO.git (fetch)
origin  https://github.com/USER/REPO.git (push)
```

SSH に変更する。

```bash
git remote set-url origin git@github.com:USER/REPO.git
```

確認する。

```bash
git remote -v
```

SSH ならこうなる。

```text
origin  git@github.com:USER/REPO.git (fetch)
origin  git@github.com:USER/REPO.git (push)
```

---

## 10. push 確認

```bash
git status
git push
```

成功すれば完了。

---

## 11. よくあるエラー

### `Permission denied (publickey).`

原因候補。

* GitHub に公開鍵を登録していない
* 違う秘密鍵を見に行っている
* `ssh-agent` に鍵が登録されていない
* remote が SSH ではなく HTTPS のまま
* `~/.ssh/config` が間違っている

確認する。

```bash
ssh-add -l
ssh -T git@github.com
git remote -v
```

---

### `no such identity: ~/.ssh/xxx: No such file or directory`

`~/.ssh/config` に存在しない鍵が書かれている。

確認する。

```bash
cat ~/.ssh/config
ls -la ~/.ssh
```

例えば `IdentityFile ~/.ssh/id_lenovo_auth` と書いてあるのに、そのファイルがないなら失敗する。

修正例。

```sshconfig
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
```

保存後に確認する。

```bash
ssh -T git@github.com
```

---

### `gh auth status` は成功するが `git push` は失敗する

`gh` の認証と SSH の認証は別物。

* `gh auth login`: GitHub CLI が GitHub API を使うための認証
* `ssh -T git@github.com`: Git が SSH で GitHub に接続するための認証

SSH で push したいなら、`ssh -T git@github.com` が成功している必要がある。

---

## 12. 最小コマンドまとめ

```bash
sudo apt update
sudo apt install -y git curl wget gpg openssh-client ca-certificates

(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) \
  && wget -nv -O "$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
  && sudo apt update \
  && sudo apt install -y gh

git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL@example.com"
git config --global init.defaultBranch main

ssh-keygen -t ed25519 -C "YOUR_EMAIL@example.com" -f ~/.ssh/id_ed25519
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub

ssh -T git@github.com
gh auth login
gh auth status
```
