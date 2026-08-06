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

Files retired from chezmoi are listed explicitly in
`run_once_before_cleanup.sh.tmpl`. Chezmoi reruns the cleanup when its rendered
content changes; paths absent from the list are never removed.

The repository supports Arch Linux with Hyprland and Ubuntu with GNOME.
`setups.sh` installs the common managed configuration and tools; it does not
install Hyprland. Ubuntu remains GNOME-only. Japanese input uses IBus + Mozc on
Ubuntu and Fcitx5 + Mozc on Arch. Both use the JIS (`jp`) keyboard layout. GNOME
uses the standard Mozc engine; its direct and hiragana modes are switched
internally with the JIS Hankaku/Zenkaku key. Sign out and back in after setup
before using the IME. On Hyprland, Chrome uses native Wayland and its
text-input-v3 integration for Fcitx5. Chezmoi applies common files plus the
matching desktop configuration; it excludes Arch/Hyprland files on Ubuntu and
Ubuntu/GNOME files on Arch or WSL. Ubuntu GNOME uses Ghostty, opened with
`Super+Enter`, without a close confirmation; Arch Hyprland uses Kitty.

Windows側へ`win32yank`を入れる。Neovimの通常yankはこれを通してWindows clipboardへ
送られる。`dd`はWindows clipboardを更新しない。

```powershell
winget install -e --id equalsraf.win32yank
wsl --set-default Ubuntu
```

zshでは`h`を先頭につけると、端末表示用に整形された出力を`clip.exe`へ送れる。

```bash
h ls -la
```

## Hyprland

On Arch, install the complete Hyprland session explicitly when needed:

```bash
./setups.sh
./init/hypr.sh
```

Saya installs Hyprland, native Wayland Noctalia v5, Noctalia Greeter, the
Wayland portals, Kitty, Fcitx5, the fixed Arch wallpaper, and supporting
services. Noctalia is the only desktop shell and owns the bar, notifications,
launcher, settings, wallpaper, clipboard history, lock screen, idle actions,
screenshots, and session menu. Quickshell and the old standalone shell
components are not used. The bar groups running application icons by workspace;
workspaces 1–10 remain visible, with unfocused windows at reduced opacity.
The center clock shows `MM/DD (weekday) HH:MM` in 24-hour time. Claude
Companion sits to its left and reports Claude Code lifecycle state; the media
player sits to its right with additional separation from the status widgets.
The official Wallhaven plugin provides tag search, filters, thumbnail browsing,
and downloads into `~/Pictures/Wallpapers`; the bar wallpaper button and
`Ctrl+Super+T` open its browser.

`init/hypr.sh` configures Noctalia Greeter under greetd and schedules it to
replace SDDM on the next reboot. The greeter and Hyprland session use Wayland
and the JIS layout. Native Wayland backends are selected for Chrome, Electron,
GTK, Firefox, Qt, and SDL before their X11 fallbacks. XWayland use remains
limited to applications without a reliable native Wayland path.

On Arch, run `init/virtualization.sh` separately to enable libvirt socket
activation, prepare its default autostarted NAT network, and download and
verify the Kali QEMU image. The verified image is extracted into libvirt's
system storage pool without overwriting an existing VM disk on later runs.

Before removing the old dependency groups, mark the replacement desktop
packages as explicit:

```bash
saya install -y \
  accountsservice \
  archlinux-wallpaper \
  bibata-cursor-theme \
  bluez \
  brightnessctl \
  fcitx5 \
  fcitx5-mozc \
  fcitx5-qt \
  gnome-keyring \
  hyprland \
  kitty \
  loupe \
  nautilus \
  networkmanager \
  noctalia \
  noctalia-greeter \
  pavucontrol \
  pipewire-pulse \
  ttf-jetbrains-mono-nerd \
  upower \
  wl-clipboard \
  wireplumber \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-hyprland \
  -- --asexplicit
```

After the first successful Noctalia login, remove the old shell and KDE stack
through Saya:

```bash
for package in \
  illogical-impulse-audio \
  illogical-impulse-backlight \
  illogical-impulse-basic \
  illogical-impulse-bibata-modern-classic-bin \
  illogical-impulse-fonts-themes \
  illogical-impulse-hyprland \
  illogical-impulse-kde \
  illogical-impulse-microtex-git \
  illogical-impulse-microtex-git-debug \
  illogical-impulse-portal \
  illogical-impulse-python \
  illogical-impulse-quickshell-git \
  illogical-impulse-screencapture \
  illogical-impulse-toolkit \
  illogical-impulse-widgets \
  fcitx5-configtool \
  gwenview \
  hyprlauncher \
  hyprpolkitagent \
  hyprshutdown \
  kwallet-pam \
  kwalletmanager \
  network-manager-applet \
  plasma-browser-integration \
  sddm
do
  saya uninstall "$package"
done
```

Key shortcuts:
`Super+Return` (terminal), `Super+Q` (close window), `Super+F` (fullscreen),
`Super+D` (maximize), `Super+Alt+Space` (float/tile toggle), `Super+H/J/K/L`
(focus a window), `Ctrl+Super+H/J/K/L` (focus a workspace), `Super+Alt+H/L`
(send a window to the adjacent workspace), `Super+Shift+L` (sleep),
`Super+Shift+S` (region screenshot),
`Print` (fullscreen screenshot), `Super+V` (clipboard history), `Super+N`
(control center), `Ctrl+Alt+Delete` (session menu), `Ctrl+Super+T`
(Wallhaven search), `Super+E` (Nautilus), `Super+W` (browser), `Super+I` (Noctalia
settings), and a double-tap of `Super` to open the launcher.

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
