#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -r /etc/os-release ]]; then
  printf 'Ubuntu on WSL is required.\n' >&2
  exit 1
fi

. /etc/os-release

if [[ "$ID" != "ubuntu" ]] || ! grep -qi microsoft /proc/sys/kernel/osrelease; then
  printf 'Ubuntu on WSL is required.\n' >&2
  exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

"$root/init/docker.sh"
"$root/init/mise.sh"
mise exec -- chezmoi apply --source "$root"
"$root/init/base.sh"
"$root/init/zellij.sh"

if getent group docker >/dev/null; then
  sudo usermod -aG docker "$USER"
fi

eval "$(mise activate bash)"

mise install
"$root/init/term.sh"

printf 'Setup completed. Start a new WSL session to apply group membership.\n'
