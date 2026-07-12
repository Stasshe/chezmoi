#!/usr/bin/env bash
set -euo pipefail

if [ ! -r /etc/os-release ]; then
  exit 0
fi

. /etc/os-release

if [ "$ID" != "arch" ]; then
  exit 0
fi

sudo pacman -S --needed --noconfirm \
  hyprland hypridle hyprlock xdg-desktop-portal-hyprland ghostty \
  waybar rofi-wayland swaync swww \
  grim slurp wl-clipboard brightnessctl \
  network-manager-applet pavucontrol polkit-gnome \
  qt5-wayland qt6-wayland ttf-jetbrains-mono-nerd wireplumber
