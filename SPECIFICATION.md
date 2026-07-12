# Desktop

GNOME 50の標準シェルを土台にする。暗色、紫のアクセント、下部フローティングDock、2×2ワークスペース、専用壁紙で視覚を統一する。Show AppsはDock左端へ置く。

外部テーマでShell構造を上書きしない。GNOME更新後も標準UIの可読性と操作を保つ。Shell 50対応版のBlur my ShellとBurn My Windowsだけを使い、動的ぼかしと短いGlideで動きを作る。拡張本体はGNOME Extensions Webで管理し、chezmoiは設定だけを持つ。

`setups.sh`はchezmoi適用後にデスクトップ設定を冪等適用する。

# Hyprland

ArchのHyprlandはNebulaを視覚契約とする。暗い宇宙壁紙、半透明面、紫とシアンの細い光で統一し、情報は上部の一枚のWaybarへ圧縮する。ランチャー、通知、ネットワーク、音量、輝度、電池、ロック、休止、スクリーンショットをセッション内で完結させる。

UbuntuのGNOME設定とは共有せず、`init/hypr.sh`がArchだけに必要な実行環境を導入する。

# Platform

Arch LinuxではHyprland、UbuntuではGNOMEを使う。配列はJIS、入力はFcitx5 + Mozcで統一する。SayaがAPTとpacmanの実パッケージを選ぶ。`setups.sh`が管理ファイル、パッケージ、ツール、該当デスクトップ設定を適用する。
