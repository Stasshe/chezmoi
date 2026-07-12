Set up the SSH key as described in [GH.md](./GH.md), then run:

```bash
mkdir -p ~/.local/share/
git clone git@github.com:Stasshe/chezmoi.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./setups.sh
```

The setup configures the Docker APT repository on Ubuntu, installs mise and
chezmoi, applies the managed files, installs the configured Saya packages,
installs the configured mise tools, and configures the desktop session.

The repository supports Arch Linux with Hyprland and Ubuntu with GNOME. On
Arch, `setups.sh` installs the complete Hyprland session (Quickshell shell,
lock/idle handling, screenshots, clipboard support, and the required Wayland
portals) by running [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)'s
own dependency installer. Ubuntu remains GNOME-only. Japanese input uses
Fcitx5 + Mozc and the keyboard layout is JIS (`jp`); sign out and back in
after setup before using the IME.

## Hyprland

Choose **Hyprland** from the display manager after running setup on Arch. The
session is [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
("illogical impulse") vendored as-is under `~/.config/{hypr,quickshell,matugen,fuzzel,...}`,
pinned at a fixed upstream commit (see `init/hypr.sh`). Quickshell provides
the bar, notifications, launcher search and settings; `fuzzel` is the app
launcher fallback; `matugen` derives the color scheme dynamically from the
current wallpaper, so there is no fixed palette. `archlinux-wallpaper` provides
the wallpaper set; Quickshell selects one at startup and every 30 minutes.
`~/.config/illogical-impulse/config.json` seeds on first run only (transparency
on and the AI/anime sidebar toggle disabled) via chezmoi's `create_` file —
later in-app setting changes are never overwritten by `chezmoi apply`.

Personal deltas (JIS keyboard, Fcitx5 env vars, Ghostty as the terminal) live
in `~/.config/hypr/custom/` and are never touched by upstream updates. The
upstream tree itself (`hypr/hyprland/`, `quickshell/`, etc.) is unmodified —
re-vendor it rather than hand-editing it.

Key shortcuts (upstream defaults — note `Super+Q` now **closes** the focused
window, it does not open a terminal):
`Super+Return` (terminal), `Super+Q` (close window), `Super+F` (fullscreen),
`Super+D` (maximize), `Super+Alt+Space` (float/tile toggle), `Super+L`
(lock), `Super+Shift+L` (sleep), `Super+Shift+S` (region screenshot),
`Print`/`Ctrl+Print` (fullscreen screenshot to clipboard/file), `Super+V`
(clipboard history), `Super+E` (file manager), `Super+W` (browser), and a
double-tap of `Super` to open search. Run `Ctrl+Super+Alt+/` to edit your own
keybinds, or see `~/.config/hypr/hyprland/keybinds.lua` for the full list.

Open a new WSL session after setup so the Docker group membership takes effect.

On Ubuntu GNOME, setup also applies the managed dark desktop, bottom dock,
2×2 workspaces, icon theme, typography, wallpaper, blur, and window transitions.

## Release

Run the **Release** workflow from the default branch and select `patch`, `minor`,
or `major`. The workflow updates `VERSION`, commits and tags the version, and
creates a GitHub release with generated notes.



```powershell
wsl --set-default Ubuntu
```

```powershell
winget install -e --id equalsraf.win32yank
```




管理者で実行
```powershell
$current = [Environment]::GetEnvironmentVariable("WSLENV", "Machine")
$items = @($current -split ":" | Where-Object { $_ })

foreach ($item in @("SSH_CONNECTION/u", "SSH_CLIENT/u", "SSH_TTY/u")) {
  if ($items -notcontains $item) {
    $items += $item
  }
}

[Environment]::SetEnvironmentVariable(
  "WSLENV",
  ($items -join ":"),
  "Machine"
)

Restart-Service sshd
```

```json
{
  "commandline": "wsl.exe -d Ubuntu --cd ~ --exec zsh -i",
  "guid": "{c45b8388-031c-5783-bcb8-06ec821d49c2}", // This is a randomly generated GUID. You can generate a new one using `New-Guid` in PowerShell.
  "hidden": false,
  "name": "Ubuntu zsh"
}
```
