#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

./init/base.sh
./init/mise.sh
./init/chezmoi.sh

eval "$(mise activate bash)"

./init/npmg.sh
./init/term.sh
./init/zellij.sh

exec zsh
