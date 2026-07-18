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

The repository supports Arch Linux with Hyprland and Ubuntu with GNOME.
`setups.sh` installs the common managed configuration and tools; it does not
install Hyprland. Ubuntu remains GNOME-only. Japanese input uses IBus + Mozc on
Ubuntu and Fcitx5 + Mozc on Arch. Both use the JIS (`jp`) keyboard layout. GNOME
uses the standard Mozc engine; its direct and hiragana modes are switched
internally with the JIS Hankaku/Zenkaku key. Sign out and back in after setup
before using the IME. Chezmoi applies common files plus the matching desktop
configuration; it excludes Arch/Hyprland files on Ubuntu and Ubuntu/GNOME files
on Arch. Ubuntu uses Ghostty without a close confirmation; Arch Hyprland uses
Kitty.

In zsh, prefix a command with `h` to copy its terminal-formatted output to the
OS clipboard:

```bash
h ls -la
```

## Hyprland

On Arch, install the complete Hyprland session explicitly when needed:

```bash
./init/hypr.sh
```

Saya installs the Arch-specific terminal, IME, font, wallpaper, shutdown helper,
and Zellij packages. The script then runs
[end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)'s own dependency
installer for the remaining session dependencies. Choose **Hyprland** from the
display manager afterwards. The session is
[end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
("illogical impulse") vendored as-is under `~/.config/{hypr,quickshell,matugen,fuzzel,...}`,
pinned at a fixed upstream commit (see `init/hypr.sh`). Quickshell provides
the bar, notifications, launcher search and settings; `fuzzel` is the app
launcher fallback. `archlinux-wallpaper` provides the managed
`archwaveinv.png` wallpaper and the `mono` theme from
`edb8b5b9c62a617ba8f4cd9a77cf465b27c9107d`. Wallpaper rotation and
wallpaper-driven app, shell, Qt, and terminal theming are disabled.
`~/.config/illogical-impulse/config.json`
is managed by chezmoi, so `chezmoi apply` restores these settings.

SDDM runs its greeter on KWin Wayland with the JIS keyboard layout. Hyprland
keeps Xwayland available for applications that still require X11 compatibility.

Personal deltas (JIS keyboard, Fcitx5 env vars, Kitty as the Hyprland terminal, and
fixed wallpaper behavior) are managed alongside the vendored configuration.
Re-vendor the upstream tree when updating it, then reapply these deltas.

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

On Ubuntu GNOME, setup also applies the managed dark desktop, persistent left dock,
2×2 workspaces, icon theme, typography, unblurred wallpaper during normal use,
Overview, panel and dock blur, window transitions, and CPU and memory usage in the
top panel. GPaste provides clipboard history through a native GNOME Shell panel
extension; `Super+V` opens the history.
`Super+Shift+S` and `Print` open the standard GNOME screenshot interface.

## iPhone file access

Apply the chezmoi configuration so Saya knows about Samba, then run the share
setup and enter a dedicated SMB password when prompted:

```bash
chezmoi apply
./init/samba.sh
```

On the iPhone, open **Files → Browse → … → Connect to Server**, enter
`smb://<computer-ip>`, sign in as the Linux user with that SMB password, then
select **Documents**. The iPhone and computer must be on the same local network.

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
