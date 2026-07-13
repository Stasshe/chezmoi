#!/usr/bin/env bash
set -euo pipefail

case ":${XDG_CURRENT_DESKTOP:-}:" in
  *:GNOME:* | *:ubuntu:GNOME:*) ;;
  *) exit 0 ;;
esac

sudo apt-get install -y ibus ibus-mozc mozc-utils-gui

set_value() {
  local schema="$1"
  local key="$2"
  local value="$3"

  if gsettings writable "$schema" "$key" >/dev/null 2>&1; then
    gsettings set "$schema" "$key" "$value"
    return
  fi

  printf '[desktop] skipped %s/%s: unavailable\n' "$schema" "$key"
}

set_extension_value() {
  local schema_dir="$1"
  local schema="$2"
  local key="$3"
  local value="$4"

  if gsettings --schemadir "$schema_dir" writable "$schema" "$key" >/dev/null 2>&1; then
    gsettings --schemadir "$schema_dir" set "$schema" "$key" "$value"
    return
  fi

  printf '[desktop] skipped %s/%s: unavailable\n' "$schema" "$key"
}

wallpaper="$HOME/.local/share/backgrounds/orbit.png"
wallpaper_uri="file://$wallpaper"

set_value org.gnome.desktop.interface color-scheme 'prefer-dark'
set_value org.gnome.desktop.interface gtk-theme 'Yaru-dark'
set_value org.gnome.desktop.interface icon-theme 'Yaru-purple-dark'
set_value org.gnome.desktop.interface cursor-theme 'Yaru'
set_value org.gnome.desktop.interface accent-color 'purple'
set_value org.gnome.desktop.interface font-name 'Ubuntu Sans 11'
set_value org.gnome.desktop.interface document-font-name 'Ubuntu Sans 11'
set_value org.gnome.desktop.interface monospace-font-name 'Ubuntu Sans Mono 11'
set_value org.gnome.desktop.interface clock-show-weekday true
set_value org.gnome.desktop.interface show-battery-percentage true
input_sources="[('ibus', 'mozc-jp')]"
set_value org.gnome.desktop.input-sources sources "$input_sources"
set_value org.gnome.desktop.input-sources mru-sources "$input_sources"
gsettings reset org.gnome.desktop.wm.keybindings switch-input-source
set_value org.gnome.shell.keybindings show-screenshot-ui "['Print', '<Super><Shift>s']"

set_value org.gnome.desktop.background picture-uri "$wallpaper_uri"
set_value org.gnome.desktop.background picture-uri-dark "$wallpaper_uri"
set_value org.gnome.desktop.background picture-options 'zoom'
set_value org.gnome.desktop.screensaver picture-uri "$wallpaper_uri"
set_value org.gnome.desktop.screensaver picture-uri-dark "$wallpaper_uri"
set_value org.gnome.desktop.screensaver picture-options 'zoom'

set_value org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
set_value org.gnome.desktop.wm.preferences titlebar-uses-system-font true
set_value org.gnome.mutter center-new-windows true
set_value org.gnome.mutter dynamic-workspaces false
set_value org.gnome.desktop.wm.preferences num-workspaces 4
set_value org.gnome.desktop.wm.preferences workspace-names "['I', 'II', 'III', 'IV']"

dock_schema='org.gnome.shell.extensions.dash-to-dock'
set_value "$dock_schema" dock-position 'LEFT'
set_value "$dock_schema" dock-fixed true
set_value "$dock_schema" intellihide false
set_value "$dock_schema" extend-height false
set_value "$dock_schema" dash-max-icon-size 42
set_value "$dock_schema" icon-size-fixed false
set_value "$dock_schema" transparency-mode 'FIXED'
set_value "$dock_schema" background-opacity 0.32
set_value "$dock_schema" custom-theme-shrink true
set_value "$dock_schema" running-indicator-style 'DOTS'
set_value "$dock_schema" animation-time 0.16
set_value "$dock_schema" show-delay 0.0
set_value "$dock_schema" hide-delay 0.15
set_value "$dock_schema" show-show-apps-button true
set_value "$dock_schema" show-apps-at-top true
set_value "$dock_schema" show-mounts false
set_value "$dock_schema" show-trash false
set_value "$dock_schema" scroll-action 'switch-workspace'

matrix_schema_dir="$HOME/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas"
matrix_schema='org.gnome.shell.extensions.wsmatrix-settings'
set_extension_value "$matrix_schema_dir" "$matrix_schema" num-columns 2
set_extension_value "$matrix_schema_dir" "$matrix_schema" num-rows 2
set_extension_value "$matrix_schema_dir" "$matrix_schema" show-overview-grid true
set_extension_value "$matrix_schema_dir" "$matrix_schema" show-popup true
set_extension_value "$matrix_schema_dir" "$matrix_schema" show-thumbnails false
set_extension_value "$matrix_schema_dir" "$matrix_schema" show-workspace-names true
set_extension_value "$matrix_schema_dir" "$matrix_schema" scale 0.30

blur_schema_dir="$HOME/.local/share/gnome-shell/extensions/blur-my-shell@aunetx/schemas"
blur_schema='org.gnome.shell.extensions.blur-my-shell.overview'
set_extension_value "$blur_schema_dir" "$blur_schema" blur false

blur_schema='org.gnome.shell.extensions.blur-my-shell.panel'
set_extension_value "$blur_schema_dir" "$blur_schema" blur true
set_extension_value "$blur_schema_dir" "$blur_schema" brightness 0.48
set_extension_value "$blur_schema_dir" "$blur_schema" static-blur false

blur_schema='org.gnome.shell.extensions.blur-my-shell.dash-to-dock'
set_extension_value "$blur_schema_dir" "$blur_schema" blur true
set_extension_value "$blur_schema_dir" "$blur_schema" brightness 0.52
set_extension_value "$blur_schema_dir" "$blur_schema" corner-radius 18
set_extension_value "$blur_schema_dir" "$blur_schema" static-blur false

blur_schema='org.gnome.shell.extensions.blur-my-shell.applications'
set_extension_value "$blur_schema_dir" "$blur_schema" blur false
