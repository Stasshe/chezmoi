# Desktop

GNOME 50の標準シェルを土台にする。暗色、紫のアクセント、常時表示する左側フローティングDock、2×2ワークスペース、専用壁紙で視覚を統一する。Show AppsはDock上端へ置く。

Workspace Matrixの切替ポップアップを表示する。サムネイルは使わず、IからIVまでの2×2グリッドを使う。アプリウィンドウはぼかさず、切替中の描画を安定させる。

ワークスペース移動はSuper+Ctrl+矢印に統一する。

切替グリッドは半透明の暗いガラスと紫の選択枠で描く。Workspace Matrix本体は変更しない。

外部テーマでShell構造を上書きしない。GNOME更新後も標準UIの可読性と操作を保つ。Shell 50対応版のBlur my ShellとBurn My Windowsだけを使い、パネルとDockの動的ぼかし、Overviewの静的ぼかし、短いGlideで動きを作る。拡張本体はGNOME Extensions Webで管理し、chezmoiは設定だけを持つ。

`setups.sh`はchezmoi適用後にデスクトップ設定を冪等適用する。
