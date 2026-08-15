# vm branch

CLI専用ホスト向け分岐。main(GNOME/Hyprlandデスクトップ)からGUI一式を落とし、
最小のCLI開発環境だけ残す。対象はUbuntu/Arch両方、どちらもheadless前提。

## パッケージ方針

`dot_config/saya/packages.toml`は開発必須のみ: ビルドツールチェーン、
git/gh、docker、ffmpeg/imagemagick、openssh。

除外(mainにあったが落とした):
- GUI/デスクトップシェル一式(GNOME拡張、Hyprland、Noctalia、Kitty/Ghostty、IME、オーディオ、入力デバイス調整)
- samba: ファイル共有はvmの用途外
- 仮想化(libvirt/qemu/virt-manager/Kaliイメージ): vm内で入れ子仮想化は想定しない
- adb/fastboot: Android実機デバッグ、vmでは繋がらない

## dotfile削除

GUI関連dotfile本体(hypr/noctalia/kitty/ghostty/fcitx5/mozc/xdg-desktop-portal/
burn-my-windows/mimeapps.list/wallpaper/gnome-shell拡張等)はignoreでなくリポジトリから
削除した。mainに戻せば復元できるが、vm branchでは存在自体させない。
mainの`.chezmoiignore`はdistribution判定(arch/ubuntu/WSL)で出し分けていたが、
vmはその判定自体不要になった。

## init/スクリプト

setups.shはdocker.sh → mise.sh → chezmoi apply → base.sh(saya+claude CLI) →
zellij.sh → mise-tools.sh → term.sh(zsh設定)の順で呼ぶ。desktop.sh(GNOME gsettings)は
呼ばない。

hypr.sh/greetd.toml/samba.sh/smb.conf/virtualization.shはCLI vmで使う経路が
そもそも無いため削除した(setups.shから呼ばれず、死んだコードとして残す理由がない)。
