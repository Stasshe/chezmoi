#!/usr/bin/env bash
set -euo pipefail

echo "[init02] install mise"

if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

echo "[init02] install chezmoi"

mise use -g chezmoi
