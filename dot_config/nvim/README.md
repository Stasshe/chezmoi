# Neovim

Windows側へ`win32yank`を入れる。

```powershell
winget install --id equalsraf.win32yank --exact
```

Neovimの通常yankは`win32yank.exe`を通してWindows clipboardへ送られる。
`dd`はWindows clipboardを更新せず、直前のclipboard内容を保つ。

`<F8>`でカーソル位置のdiagnostic messageをまとめてclipboardへコピーする。

normal modeで入力中の数字countはstatusline右側に表示する。行指定は`10G`、`10gg`、
`10<Enter>`を使う。数字なしの`<Enter>`は通常の`<Enter>`として扱う。

Neo-treeの横幅はリサイズ後と閉じる直前にNeovim stateへ保存し、再表示時や次回起動時に同じ幅へ戻す。
再表示直後に既存windowへ入った場合も保存幅へ戻す。
