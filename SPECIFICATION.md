# Desktop

GNOME 50の標準シェルを土台にする。暗色、紫のアクセント、下部フローティングDock、2×2ワークスペース、専用壁紙で視覚を統一する。Show AppsはDock左端へ置く。

外部テーマでShell構造を上書きしない。GNOME更新後も標準UIの可読性と操作を保つ。Shell 50対応版のBlur my ShellとBurn My Windowsだけを使い、動的ぼかしと短いGlideで動きを作る。拡張本体はGNOME Extensions Webで管理し、chezmoiは設定だけを持つ。

`setups.sh`、chezmoi適用後に共通設定とデスクトップ設定を冪等適用する。Hyprland導入、重い。通常実行から外す。必要な時だけ`init/hypr.sh`走らす。

# Hyprland

ArchのHyprlandはend-4/dots-hyprland(illogical impulse)をShellの正とする。壁紙は`archlinux-wallpaper`の`archwaveinv.png`、テーマは`edb8b5b9c62a617ba8f4cd9a77cf465b27c9107d`の`mono`で固定する。スライドショー、壁紙連動のmatugen配色、アプリ・Qt・端末テーマ更新は使わない。`illogical-impulse/config.json`をchezmoiで管理し、適用時にこの状態へ戻す。ランチャー・通知・バーはQuickshell内蔵、フォールバックランチャーはfuzzel。

上流ツリー(`hypr/hyprland/`, `quickshell/`, `matugen/`等)はベンダリングする。個人差分はJIS配列、Fcitx5環境変数、Ghostty、固定壁紙動作に限る。更新時は上流を丸ごと再ベンダリング後に差分を再適用する。Waybar/Rofi/SwayNCは廃止。

UbuntuのGNOME設定とは共有せず、`init/hypr.sh`がArchだけに必要な実行環境を明示実行で導入する。依存パッケージはend-4本家のインストーラ(deps+setupフェーズのみ、`--skip-allfiles`)を呼ぶ。ファイル配布フェーズは使わず、設定ファイルはchezmoiが正とする。

# Platform

Arch LinuxではHyprland、UbuntuではGNOMEを使う。配列はJIS、入力はFcitx5 + Mozcで統一する。SayaがAPTとpacmanの実パッケージを選ぶ。`setups.sh`が管理ファイル、パッケージ、ツール、該当デスクトップ設定を適用する。
