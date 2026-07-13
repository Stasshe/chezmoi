#!/usr/bin/env bash
set -euo pipefail

if [ ! -r /etc/os-release ]; then
  exit 0
fi

. /etc/os-release

if [ "$ID" != "arch" ]; then
  exit 0
fi

# Ghostty is our terminal choice; everything else the Hyprland session needs
# (Hyprland itself, Quickshell, fuzzel, matugen, fonts, portals, polkit agent,
# services/groups/kernel modules) comes from end-4/dots-hyprland's own
# dependency installer below, run in deps+setup-only mode.
sudo pacman -S --needed --noconfirm \
  archlinux-wallpaper \
  fcitx5 \
  fcitx5-gtk \
  fcitx5-mozc \
  fcitx5-qt \
  ghostty \
  ttf-jetbrains-mono-nerd

DOTS_HYPRLAND_REF="c04b0bbc8143a2b2166c1f699f7583cb28ff78fe"
DOTS_HYPRLAND_SRC="$HOME/.cache/dots-hyprland"

if [ ! -d "$DOTS_HYPRLAND_SRC/.git" ]; then
  git clone https://github.com/end-4/dots-hyprland.git "$DOTS_HYPRLAND_SRC"
fi
git -C "$DOTS_HYPRLAND_SRC" fetch --depth 1 origin "$DOTS_HYPRLAND_REF"
git -C "$DOTS_HYPRLAND_SRC" checkout --detach FETCH_HEAD

(cd "$DOTS_HYPRLAND_SRC" && ./setup install --skip-allfiles --skip-sysupdate -f)
