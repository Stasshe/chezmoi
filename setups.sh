#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

export PATH="$HOME/.local/bin:$PATH"

"$root/init/docker.sh"
"$root/init/mise.sh"
"$root/init/chezmoi.sh" "$root"
"$root/init/base.sh"
"$root/init/zellij.sh"


if getent group docker >/dev/null; then
  sudo usermod -aG docker "$USER"
fi

eval "$(mise activate bash)"

"$root/init/mise-tools.sh"
"$root/init/term.sh"

printf 'Setup completed. Start a new shell session to apply group membership.\n'
