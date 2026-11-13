# Platform

Ubuntu on WSL専用。他OS・desktop sessionへ適応せぬ。入口で環境を検証し、内部に
distributionやdesktopの分岐を持ち込まぬ。

# Provisioning

`setups.sh`を唯一の一括入口とする。Docker公式APT repositoryを登録し、mise経由で
chezmoiをbootstrap、管理ファイル適用後にSayaでAPT packages、miseでuser toolsを
導入する。sudoを要するsystem設定とuser設定の責務をinit script単位で分ける。

OS package宣言はSayaの`apt`配列だけに置く。GUI shell、IME、Wayland、Arch packageを
持たぬ。miseはCLI・言語toolchainを管理し、FlutterとJavaを持たぬ。
Saya schema必須の`yay` tableは空で保持する。

Sayaの`absent`は`gnome-shell`、`qemu-system-gui`、`wl-clipboard`を指定する。
QEMUはheadless用のsystem emulatorとdisk toolsを維持する。

Neovimは`0.12.6`、AstroNvimは`v6.1.1`へ固定し、plugin commitはlockfileで揃える。
Cのcompiler・debugger・manualはSaya、Go tools・lazydocker・gcloudはmiseが担う。
JS/TSのlint・formatはproject側CLIへ委ねる。

管理を終了したtargetはcleanup scriptへ個別列挙する。scriptは内容hash単位で一度実行し、
fileだけを明示削除、directoryは空の場合だけ削除する。sourceに存在しないtargetの一括削除を
行わず、OS・application・userが作った非管理fileを保つ。
廃止したctx-gleanerの`hooksPath`指定だけをglobal Git設定から外す。

# Windows boundary

Linux側の設定を正本とし、clipboardとHTMLのbrowser起動をWindows executableへ委譲する。
`~/.local/bin/h`は疑似端末出力から装飾を除いて`clip.exe`へ渡す。Neovimは
`win32yank.exe`をproviderとし、UTF-8 textをWindows clipboardへ渡す。
normal・visual modeの`d`はclipboardを更新せず削除する。
HTMLは`wslpath`でpathを変換し、`explorer.exe`でWindowsの既定browserへ渡す。

# AI tools

ClaudeはSessionStartでmode trackerを縮め、model・directory・branch・effortをstatus lineへ
出す。Codexはhostへの確認なし実行を共通設定とし、`git push`をcommand ruleで拒否する。
project trustとUI設定は端末に残す。`ai-usage`はCodex・Claudeの使用量をJSONで出し、
reset時刻はTokyo時間を使う。

# Container networking

Docker default bridgeは`192.168.223.0/24`。自動bridgeは`192.168.224.0/20`と
`192.168.240.0/20`から`/24`単位で割り当てる。`init/docker.sh`がdaemon設定を配置する。
lazydockerの削除commandはCompose project labelでcontainer・image・volume・networkを
特定し、確認後に削除する。他containerの共有imageと使用中resourceは保つ。

# Local file sharing

Sambaは認証済みLinux user本人へ`~/Documents`だけをSMB2以上で読み書き共有する。
guest accessとhome全体の公開を許さぬ。Sayaはpackage導入、`init/samba.sh`は設定検証、
service反映、SMB credential登録を担う。
