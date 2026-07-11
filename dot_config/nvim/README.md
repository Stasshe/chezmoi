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

## Ubuntu Desktop clipboard

On Ubuntu Desktop, Neovim uses OSC 52 to copy regular yanks through the
terminal. Ghostty supports OSC 52 without an external clipboard command.
