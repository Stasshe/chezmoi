#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

./init/docker.sh
./init/mise.sh
./init/chezmoi.sh
./init/base.sh

sudo usermod -aG docker "$USER"

eval "$(mise activate bash)"

./init/mise-tools.sh
./init/term.sh
./init/zellij.sh

echo "Setup completed."

exec zsh
