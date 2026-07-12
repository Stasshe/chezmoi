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

The repository supports Arch Linux with Hyprland and Ubuntu with GNOME. Saya
selects the APT or pacman package names. Japanese input uses Fcitx5 + Mozc and
the keyboard layout is JIS (`jp`); sign out and back in after setup before
using the IME.

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
