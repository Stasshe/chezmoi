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

## dotfile除外

GUI関連dotfile本体(hypr/noctalia/kitty/ghostty/fcitx5/mozc等)は消さずmain資産として
リポジトリに残す。`.chezmoiignore`で常時除外することでvmホストへは一切適用しない。
mainの`.chezmoiignore`はdistribution判定(arch/ubuntu/WSL)で出し分けていたが、
vmは判定不要で最初から全部除外に倒す。

## init/スクリプト

setups.shはdocker.sh → mise.sh → chezmoi apply → base.sh(saya+claude CLI) →
zellij.sh → mise-tools.sh → term.sh(zsh設定)の順で呼ぶ。desktop.sh(GNOME gsettings)は
呼ばない。

hypr.sh/greetd.toml/samba.sh/smb.conf/virtualization.shはCLI vmで使う経路が
そもそも無いため削除した(setups.shから呼ばれず、死んだコードとして残す理由がない)。
