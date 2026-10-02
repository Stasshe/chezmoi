# AstroNvim Template

**NOTE:** This is for AstroNvim v6+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.

You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository

```shell
git clone https://github.com/<your_user>/<your_repository> ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```

## WSL clipboard

Install `win32yank` from PowerShell on Windows:

```powershell
winget install --id equalsraf.win32yank --exact
```

On WSL, regular Neovim yanks then use `win32yank.exe` and are copied to the
Windows clipboard without changing UTF-8 text.

`<F8>`でカーソル位置のdiagnostic messageをまとめてclipboardへコピーする。

normal modeで入力中の数字countはstatusline右側に表示する。行指定は`10G`、`10gg`、
`10<Enter>`を使う。数字なしの`<Enter>`は通常の`<Enter>`として扱う。

Neo-treeの横幅はリサイズ後と閉じる直前にNeovim stateへ保存し、再表示時や次回起動時に同じ幅へ戻す。
再表示直後に既存windowへ入った場合も保存幅へ戻す。Neo-treeだけが残って全画面幅になった状態は保存しない。

## C development

C uses the C Tree-sitter parser for syntax highlighting. GCC compiles programs,
GDB provides debugging, and man provides library documentation.
Apply the managed configuration:

```sh
chezmoi apply ~/.config/nvim ~/.config/saya/packages.toml
```

GCC and Make come from `base-devel` on Arch and `build-essential` on Ubuntu.
GDB and C library manuals are declared in the Saya manifest. Install missing
packages on Arch with:

```sh
saya install gdb man-db man-pages
```

On Ubuntu:

```sh
saya install gdb man-db manpages-dev
```

Build and run a single file from the project directory:

```sh
gcc -std=gnu17 -Wall -Wextra -Wpedantic -g -O0 main.c -o main
./main
nvim main.c
```

The course uses `random()` and `srandom()`, which are outside ISO C. GNU C17
keeps their declarations available on Linux. Use four spaces for indentation;
Neovim's `gg=G` reindents the entire file.

For the course's interactive programs, open GDB in Neovim with
`:split | terminal gdb --nx ./main`, then press `i` to type. `--nx` skips the
managed pwndbg configuration and shows the standard GDB interface used in class.
Use `break main`, `run`, `next`, `p variable`, `set variable = value`,
`continue`, and `quit`. This terminal accepts input for `scanf()`.
Press `Ctrl-\ Ctrl-N` to return to Neovim normal mode.

Library manuals work in an ordinary terminal or Neovim's terminal:

```sh
man 3 printf
man 3 random
man 3 srandom
man 3 scanf
man ascii
```

Use the installed draw.io application for flowcharts. Save each exercise's
`.drawio` and `.c` files separately in its own directory, and export diagrams
as PDF or PNG when needed for review or submission.
