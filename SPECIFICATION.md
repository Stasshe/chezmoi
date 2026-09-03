# Desktop

Arch HyprlandではNoctaliaがchezmoi管理の壁紙を全画面へ表示する。壁紙の自動切替は行わない。AI usageのreset時刻はTokyo時間で表示する。

GNOME 50の標準シェルを土台にする。暗色、紫のアクセント、常時表示する左側フローティングDock、2×2ワークスペース、専用壁紙で視覚を統一する。Show AppsはDock上端へ置く。上部パネルにはCPUとメモリの使用率を常時表示する。

Workspace Matrixの切替ポップアップを表示する。サムネイルは使わず、IからIVまでの2×2グリッドを使う。アプリウィンドウはぼかさず、切替中の描画を安定させる。

Hyprlandのワークスペース移動はSuper+Ctrl+H/J/K/Lまたは矢印を使う。現在位置から相対移動し、1–10では循環させない。ウィンドウの方向移動はSuper+Shift+U/I/O/Pを左/下/上/右として使う。Alt+H/J/K/Lはフォーカス中のアプリへ左/下/上/右キーを送る。

Hyprlandはモニターごとに10ワークスペースを持つ。番号帯の順序はディスプレイの物理配置から分離し、専用TUIで編集する。外部モニターはserial、serialを持たないモニターは出力名で識別し、未接続時も保存順を維持する。未登録の接続済み出力は物理配置順で後続させる。モニター切断で不要になった番号帯のウィンドウは1–10の対応番号へ戻す。13は3、20は10へ戻す。余剰ワークスペースは残さない。

Super+Shift+SとPrintはGNOME標準のスクリーンショットUIを開く。

切替グリッドは半透明の暗いガラスと紫の選択枠で描く。Workspace Matrix本体は変更しない。

外部テーマでShell構造を上書きしない。GNOME更新後も標準UIの可読性と操作を保つ。Shell 50対応版のBlur my ShellとBurn My Windowsだけを使い、通常時の壁紙はぼかさず、Overviewの静的ぼかし、パネルとDockの動的ぼかし、短いGlideで動きを作る。拡張本体はGNOME Extensions Webで管理し、chezmoiは設定だけを持つ。

Linux側の設定を正本としつつ、clipboardだけWindows executableへ委譲する。
`~/.local/bin/h`は疑似端末出力から装飾を除いて`clip.exe`へ渡す。Neovimは
`win32yank.exe`をproviderとし、UTF-8 textをWindows clipboardへ渡す。`dd`は
clipboardを更新せずlineを削除する。

# Codex

Codexは確認なしでhostへアクセスできる。`git push`だけはcommand ruleで拒否し、実行をユーザーへ委ねる。

# Container networking

Dockerのdefault bridgeは`192.168.223.0/24`を使う。自動生成bridgeは
`192.168.224.0/20`と`192.168.240.0/20`から`/24`単位で割り当てる。
`init/docker.sh`がdaemon設定を`/etc/docker/daemon.json`へ配置する。
lazydockerのcontainer custom commandは選択containerのCompose project labelを基準に、
同project所有のcontainer、image、volume、networkを確認後に一括削除する。
他containerが共有・使用中のresourceとprojectへ帰属できないBuildKit cacheは削除しない。

# Local file sharing

SambaはSayaで導入する。ローカルネットワーク上の認証済みLinuxユーザー本人に限り、`~/Documents`をSMB2以上で読み書き共有する。Apple SMB拡張で実効権限とメタデータを伝える。ゲストアクセスとホームディレクトリ全体の公開は行わない。共有設定は`init/samba.sh`で明示的に適用し、SMBパスワードは対話入力で登録する。

Ubuntu GNOMEの日本語入力はIBus + MozcとJIS配列を使う。GNOME入力ソースは通常のMozcだけに固定し、半角／全角キーはMozc内部の直接入力とひらがなを切り替える。Arch HyprlandはUS配列とFcitx5 + Mozcを使う。Caps LockまたはCtrl+Spaceで日本語入力を切り替え、Caps Lock機能は有効にしない。入力基盤の環境変数をセッション間で共有しない。
