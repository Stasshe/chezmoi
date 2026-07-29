#!/usr/bin/env bash
set -euo pipefail

if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl -fsSL https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

mise use -g chezmoi
