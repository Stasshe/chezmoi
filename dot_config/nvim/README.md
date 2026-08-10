# Neovim

Windows側へ`win32yank`を入れる。

```powershell
winget install --id equalsraf.win32yank --exact
```

Neovimの通常yankは`win32yank.exe`を通してWindows clipboardへ送られる。
`dd`はWindows clipboardを更新せず、直前のclipboard内容を保つ。

`<F8>`でカーソル位置のdiagnostic messageをまとめてclipboardへコピーする。

Neo-treeの横幅はリサイズ後の値をNeovim stateへ保存し、非表示後や次回起動時も同じ幅で開く。
