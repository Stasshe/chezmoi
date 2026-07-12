#!/usr/bin/env bash
set -euo pipefail

source_dir="$1"

mise exec -- chezmoi apply --source "$source_dir"

if [ -r /etc/os-release ]; then
    . /etc/os-release

    if [ "$ID" = "arch" ]; then
        rm -f "$HOME/.config/hypr/hyprland.conf"
    fi
fi
