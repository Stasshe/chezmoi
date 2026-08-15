Set up the SSH key as described in [GH.md](./GH.md), then run:

```bash
mkdir -p ~/.local/share/
git clone git@github.com:Stasshe/chezmoi.git ~/.local/share/chezmoi
cd ~/.local/share/chezmoi
./setups.sh
```

CLI-only setup. No desktop environment, no Hyprland, no GNOME extras.
Targets Ubuntu and Arch, both headless.

`setups.sh` sets up the Docker APT repo on Ubuntu, installs mise and chezmoi,
applies the managed dotfiles, installs the Saya packages
(`dot_config/saya/packages.toml`: git, gh, docker, build toolchain, ffmpeg,
imagemagick, openssh), installs mise-managed tools, and configures zsh
(Oh My Zsh + plugins, oh-my-posh theme).

GUI-only dotfiles (Hyprland, GNOME, Noctalia, Ghostty, Kitty, IME, wallpapers)
are removed on this branch, not just ignored.

## Release

Run the **Release** workflow from the default branch and select `patch`,
`minor`, or `major`. It updates `VERSION`, commits and tags the version, and
creates a GitHub release with generated notes.
