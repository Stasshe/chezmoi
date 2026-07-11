#!/usr/bin/env bash
set -euo pipefail

if [ "${XDG_CURRENT_DESKTOP:-}" != "ubuntu:GNOME" ]; then
  exit 0
fi

wallpaper="$HOME/.local/share/backgrounds/orbit.png"
wallpaper_uri="file://$wallpaper"

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-purple-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface accent-color 'purple'
gsettings set org.gnome.desktop.interface font-name 'Ubuntu Sans 11'
gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Sans Mono 11'
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface show-battery-percentage true

gsettings set org.gnome.desktop.background picture-uri "$wallpaper_uri"
gsettings set org.gnome.desktop.background picture-uri-dark "$wallpaper_uri"
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.screensaver picture-uri "$wallpaper_uri"
gsettings set org.gnome.desktop.screensaver picture-options 'zoom'

gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.wm.preferences titlebar-uses-system-font true
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

dock_schema='org.gnome.shell.extensions.dash-to-dock'
gsettings set "$dock_schema" dock-position 'BOTTOM'
gsettings set "$dock_schema" dock-fixed false
gsettings set "$dock_schema" intellihide true
gsettings set "$dock_schema" extend-height false
gsettings set "$dock_schema" dash-max-icon-size 42
gsettings set "$dock_schema" icon-size-fixed false
gsettings set "$dock_schema" transparency-mode 'FIXED'
gsettings set "$dock_schema" background-opacity 0.32
gsettings set "$dock_schema" custom-theme-shrink true
gsettings set "$dock_schema" running-indicator-style 'DOTS'
gsettings set "$dock_schema" show-mounts false
gsettings set "$dock_schema" show-trash false
gsettings set "$dock_schema" scroll-action 'switch-workspace'

matrix_schema='org.gnome.shell.extensions.wsmatrix-settings'
gsettings --schemadir "$HOME/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas" \
  set "$matrix_schema" num-columns 2
gsettings --schemadir "$HOME/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas" \
  set "$matrix_schema" num-rows 2
gsettings --schemadir "$HOME/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas" \
  set "$matrix_schema" show-overview-grid true
gsettings --schemadir "$HOME/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas" \
  set "$matrix_schema" scale 0.36
