# Desktop

GNOME 50の標準シェルを土台にする。暗色、紫のアクセント、下部フローティングDock、2×2ワークスペース、専用壁紙で視覚を統一する。Show AppsはDock左端へ置く。

外部テーマでShell構造を上書きしない。GNOME更新後も標準UIの可読性と操作を保つ。Shell 50対応版のBlur my ShellとBurn My Windowsだけを使い、動的ぼかしと短いGlideで動きを作る。拡張本体はGNOME Extensions Webで管理し、chezmoiは設定だけを持つ。

`setups.sh`はchezmoi適用後にデスクトップ設定を冪等適用する。

# Hyprland

ArchのHyprlandはend-4/dots-hyprland(illogical impulse)をShellの正とする。QuickshellとLua設定、matugenによる壁紙連動の動的配色を使う。固定パレットは持たない。ランチャー・通知・バーはQuickshell内蔵、フォールバックランチャーはfuzzel。

上流ツリー(`hypr/hyprland/`, `quickshell/`, `matugen/`等)は無改変でベンダリングし、個人差分(JIS配列、Fcitx5環境変数、端末はghostty固定)だけを`hypr/custom/`に置く。アップデートは上流を丸ごと再ベンダリングして行う、パッチを重ねない。Waybar/Rofi/SwayNCは廃止。

UbuntuのGNOME設定とは共有せず、`init/hypr.sh`がArchだけに必要な実行環境を導入する。依存パッケージはend-4本家のインストーラ(deps+setupフェーズのみ、`--skip-allfiles`)を呼ぶ。ファイル配布フェーズは使わず、設定ファイルはchezmoiが正とする。

# Platform

Arch LinuxではHyprland、UbuntuではGNOMEを使う。配列はJIS、入力はFcitx5 + Mozcで統一する。SayaがAPTとpacmanの実パッケージを選ぶ。`setups.sh`が管理ファイル、パッケージ、ツール、該当デスクトップ設定を適用する。
