#!/usr/bin/env bash
set -euo pipefail

if [ ! -r /etc/os-release ]; then
  exit 0
fi

. /etc/os-release

if [ "$ID" != "arch" ]; then
  exit 0
fi

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for command in greetd noctalia noctalia-greeter-session; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf '%s\n' "$command is required. Run saya install first." >&2
    exit 1
  fi
done

if ! getent passwd greeter >/dev/null; then
  printf '%s\n' "The greeter user is missing. Reinstall greetd before continuing." >&2
  exit 1
fi

sudo install -Dm644 "$root/greetd.toml" /etc/greetd/config.toml
sudo install -d -o greeter -g greeter /var/lib/noctalia-greeter
if systemctl cat sddm.service >/dev/null 2>&1; then
  sudo systemctl disable sddm.service
fi
sudo systemctl enable NetworkManager.service accounts-daemon.service bluetooth.service greetd.service

printf '%s\n' "greetd will replace SDDM after the next reboot."
