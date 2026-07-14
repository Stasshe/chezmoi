sayaを使え
apt,pacmanはsudoで
インストールはこちらでやるcmd渡せ
ubuntuはgnome, archはhyprで固定
環境を常に確認しろ









  根本原因: gsd-media-keysはsystemd user unit (org.gnome.SettingsDaemon.MediaKeys.service)管理下。俺がkill+nohupで手動再起動した→systemd管理外の孤児プロセス生成。

  journalログ:
  Failed to grab accelerator for keybinding settings:playback-repeat
  Failed to grab accelerator for keybinding settings:hibernate
  既存アクセラレータのgrab自体失敗してる。GNOME(Wayland)のキーバインドはX11のXGrabKeyでなくD-Bus経由でmutterに登録する方式→gsd再起動タイミングでmutter側の古いgrab状態と新プロセスがズレる→grab失敗。

  沼る理由まとめ:
  1. systemctl --user restart使うべきところkill+nohupで代用→systemd供給ライフサイクル外れる
  2. daemon再起動そのものがmutterとのgrab同期を壊すリスク持つ操作→触るたび状態が悪化しうる
  3. カスタムキーバインドはGUI(設定画面)経由の方が同じ壊れる操作を踏まない可能性高いが、根本の「動的daemon再起動でgrab不整合」問題は変わらず

  確実な手段: ログアウト/イン(session再生成でgrab状態クリーン化)。動的再起動系は原理的に賭け。

  systemctl --user restart org.gnome.SettingsDaemon.MediaKeys.serviceで正規手順に戻すなら言え。それでもダメならログアウトが確実。
