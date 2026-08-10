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

Neo-treeの横幅はリサイズ後と閉じる直前にNeovim stateへ保存し、再表示時や次回起動時に同じ幅へ戻す。
再表示直後に既存windowへ入った場合も保存幅へ戻す。
