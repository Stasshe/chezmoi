# Neovim

Neovimはmiseで`0.12.6`、AstroNvimは`lua/lazy_setup.lua`で`v6.1.1`に固定する。
plugin commitは`lazy-lock.json`で管理する。更新はchezmoi sourceに対して行う。

```sh
XDG_CONFIG_HOME="$HOME/.local/share/chezmoi/dot_config" nvim
# Run :Lazy update, then quit Neovim.
chezmoi apply ~/.config/nvim ~/.config/mise/config.toml
mise install neovim
```

Windows側へ`win32yank`を入れる。

```powershell
winget install --id equalsraf.win32yank --exact
```

Neovimの通常yankは`win32yank.exe`を通してWindows clipboardへ送られる。
normal・visual modeの`d`はWindows clipboardを更新せず、直前のclipboard内容を保つ。

`<F8>`でカーソル位置のdiagnostic messageをまとめてclipboardへコピーする。

normal modeで入力中の数字countはstatusline右側に表示する。行指定は`10G`、`10gg`、
`10<Enter>`を使う。数字なしの`<Enter>`は通常の`<Enter>`として扱う。

Neo-treeの横幅はリサイズ後と閉じる直前にNeovim stateへ保存し、再表示時や次回起動時に同じ幅へ戻す。
再表示直後に既存windowへ入った場合も保存幅へ戻す。Neo-treeだけが残った全画面幅は保存しない。

HTMLは保存後、normal modeの`<Space>fB`でWindowsの既定ブラウザへ開く。
JavaScript・TypeScriptのlint・formatはproject側CLIを使い、言語機能は`tsgo`、JSONは`jsonls`を使う。

## C development

GCC・Makeは`build-essential`、GDBとC library manualはSayaで管理する。

```sh
chezmoi apply ~/.config/nvim ~/.config/saya/packages.toml
saya install gdb man-db manpages-dev
gcc -std=gnu17 -Wall -Wextra -Wpedantic -g -O0 main.c -o main
./main
```

Neovim内では`:split | terminal gdb --nx ./main`でdebuggerを開き、`i`で入力する。
`break main`、`run`、`next`、`p variable`、`continue`、`quit`を使う。
`Ctrl-\ Ctrl-N`でnormal modeへ戻る。libraryの使い方は`man 3 printf`などで確認する。
