# WSL dotfiles

Ubuntu on WSL専用。SSH鍵を[GH.md](./GH.md)どおり用意してから実行する。

```bash
mkdir -p ~/.local/share
git clone --branch wsl git@github.com:Stasshe/chezmoi.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./setups.sh
```

`setups.sh`はUbuntu on WSL以外では停止する。Docker公式APT repository、mise、
chezmoi、Saya管理のAPT packages、mise tools、Zellij、zsh環境を順に構成する。
Docker group反映のため、完了後はWSL sessionを開き直す。

管理をやめたファイルは`run_once_before_cleanup.sh.tmpl`へ明示的に追加する。
chezmoiはscript内容が変わったときだけcleanupを再実行する。列挙していないファイルと、
空でないディレクトリは削除しない。

## Windows integration

Windows側へ`win32yank`を入れる。Neovimの通常yankはこれを通してWindows clipboardへ
送られる。

```powershell
winget install -e --id equalsraf.win32yank
wsl --set-default Ubuntu
```

zshでは`h`を先頭につけると、端末表示用に整形された出力を`clip.exe`へ送れる。

```bash
h ls -la
```

Windows OpenSSHからWSLへ接続情報を渡す場合は、管理者PowerShellで設定する。

```powershell
$current = [Environment]::GetEnvironmentVariable("WSLENV", "Machine")
$items = @($current -split ":" | Where-Object { $_ })

foreach ($item in @("SSH_CONNECTION/u", "SSH_CLIENT/u", "SSH_TTY/u")) {
  if ($items -notcontains $item) {
    $items += $item
  }
}

[Environment]::SetEnvironmentVariable(
  "WSLENV",
  ($items -join ":"),
  "Machine"
)

Restart-Service sshd
```

Windows Terminal profile:

```json
{
  "commandline": "wsl.exe -d Ubuntu --cd ~ --exec zsh -i",
  "guid": "{c45b8388-031c-5783-bcb8-06ec821d49c2}",
  "hidden": false,
  "name": "Ubuntu zsh"
}
```

## iPhone file access

Sayaの適用後、共有設定を実行して専用SMB passwordを登録する。

```bash
chezmoi apply
./init/samba.sh
```

iPhoneの「ファイル → ブラウズ → … → サーバへ接続」から、表示された
`smb://<address>`へLinux userで接続し、`Documents`を選ぶ。同じLAN内だけで使う。

## Release

default branchでRelease workflowを実行し、`patch`、`minor`、`major`を選ぶ。
workflowは`VERSION`更新、commit、tag、GitHub release作成まで行う。
