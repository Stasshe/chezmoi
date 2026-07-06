#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

./init/docker.sh
./init/mise.sh
./init/chezmoi.sh
./init/base.sh

sudo usermod -aG docker "$USER"

eval "$(mise activate bash)"

./init/npmg.sh
./init/term.sh
./init/zellij.sh

exec zsh

echo "Successfully setups Done!!!!"
