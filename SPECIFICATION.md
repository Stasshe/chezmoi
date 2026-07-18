# Desktop

GNOME 50の標準シェルを土台にする。暗色、紫のアクセント、常時表示する左側フローティングDock、2×2ワークスペース、専用壁紙で視覚を統一する。Show AppsはDock上端へ置く。上部パネルにはCPUとメモリの使用率を常時表示する。

Workspace Matrixの切替ポップアップを表示する。サムネイルは使わず、IからIVまでの2×2グリッドを使う。アプリウィンドウはぼかさず、切替中の描画を安定させる。

ワークスペース移動はSuper+Ctrl+矢印に統一する。

Super+Shift+SとPrintはGNOME標準のスクリーンショットUIを開く。

切替グリッドは半透明の暗いガラスと紫の選択枠で描く。Workspace Matrix本体は変更しない。

外部テーマでShell構造を上書きしない。GNOME更新後も標準UIの可読性と操作を保つ。Shell 50対応版のBlur my ShellとBurn My Windowsだけを使い、通常時の壁紙はぼかさず、Overviewの静的ぼかし、パネルとDockの動的ぼかし、短いGlideで動きを作る。拡張本体はGNOME Extensions Webで管理し、chezmoiは設定だけを持つ。

`setups.sh`はchezmoi適用後にデスクトップ設定を冪等適用する。

OSパッケージの宣言はSayaのschema v3マニフェストへ集約する。APTとpacmanのパッケージ名は独立した配列で保持し、OS間の論理名対応は持たない。UbuntuのIME依存、ArchのHyprland補助依存とZellijも同じマニフェストから導入する。外部リポジトリ設定や上流インストーラーによる構成処理は各initスクリプトが担う。

chezmoiは共通設定と実行環境に対応する設定だけを適用する。UbuntuではArch・Hyprland固有ファイルを、ArchではUbuntu・GNOME固有ファイルを対象外にする。未対応ディストリビューションには固有設定を適用しない。

`~/.local/bin/h`はコマンドを疑似端末で実行し、端末向けに整形されたテキスト出力をOSクリップボードへコピーする。Arch HyprlandとUbuntu GNOMEでは`wl-copy`、Ubuntu WSLでは`clip.exe`を使い、`h command`で呼び出す。

# Local file sharing

SambaはSayaで導入する。ローカルネットワーク上の認証済みLinuxユーザー本人に限り、`~/Documents`をSMB2以上で読み書き共有する。Apple SMB拡張で実効権限とメタデータを伝える。ゲストアクセスとホームディレクトリ全体の公開は行わない。共有設定は`init/samba.sh`で明示的に適用し、SMBパスワードは対話入力で登録する。

Ubuntu GNOMEの日本語入力はIBus + Mozcを使う。GNOME入力ソースは通常のMozcだけに固定し、半角／全角キーはMozc内部の直接入力とひらがなを切り替える。Arch HyprlandはFcitx5 + Mozcを使い、入力基盤の環境変数をセッション間で共有しない。
