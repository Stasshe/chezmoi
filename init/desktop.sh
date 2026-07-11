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
gsettings set "$dock_schema" animation-time 0.16
gsettings set "$dock_schema" show-delay 0.0
gsettings set "$dock_schema" hide-delay 0.15
gsettings set "$dock_schema" show-show-apps-button true
gsettings set "$dock_schema" show-apps-at-top true
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
  set "$matrix_schema" scale 0.30

blur_schema_dir="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas"
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.overview brightness 0.52
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.panel blur true
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.panel brightness 0.48
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.panel static-blur false
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.52
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.dash-to-dock corner-radius 18
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur false
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.applications blur true
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.applications enable-all true
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.applications static-blur false
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.applications dynamic-opacity true
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.applications opacity 232
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.applications brightness 0.82
gsettings --schemadir "$blur_schema_dir" \
  set org.gnome.shell.extensions.blur-my-shell.applications corner-radius 16
