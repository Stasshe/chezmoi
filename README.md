Set up the SSH key as described in [GH.md](./GH.md), then run:

```bash
mkdir -p ~/.local/share/
git clone git@github.com:Stasshe/chezmoi.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./setups.sh
```

The setup configures the Docker APT repository, installs mise and chezmoi,
applies the managed files, installs the configured mise and Saya packages, and
starts zsh.



```powershell
wsl --set-default Ubuntu
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
