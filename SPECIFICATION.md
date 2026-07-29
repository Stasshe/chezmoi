# Platform

Ubuntu on WSL専用。他OS・desktop sessionへ適応せぬ。入口で環境を検証し、内部に
distributionやdesktopの分岐を持ち込まぬ。

# Provisioning

`setups.sh`を唯一の一括入口とする。Docker公式APT repositoryを登録し、mise経由で
chezmoiをbootstrap、管理ファイル適用後にSayaでAPT packages、miseでuser toolsを
導入する。sudoを要するsystem設定とuser設定の責務をinit script単位で分ける。

OS package宣言はSayaの`apt`配列だけに置く。GUI shell、IME、Wayland、Arch packageを
持たぬ。miseはCLI・言語toolchainを管理し、FlutterとJavaを持たぬ。

# Windows boundary

Linux側の設定を正本としつつ、clipboardだけWindows executableへ委譲する。
`~/.local/bin/h`は疑似端末出力から装飾を除いて`clip.exe`へ渡す。Neovimは
`win32yank.exe`をproviderとし、UTF-8 textをWindows clipboardへ渡す。

# Local file sharing

Sambaは認証済みLinux user本人へ`~/Documents`だけをSMB2以上で読み書き共有する。
guest accessとhome全体の公開を許さぬ。Sayaはpackage導入、`init/samba.sh`は設定検証、
service反映、SMB credential登録を担う。
