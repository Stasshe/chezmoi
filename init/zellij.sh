#!/usr/bin/env bash
set -euo pipefail

if [[ ! -r /etc/os-release ]]; then
  exit 0
fi

. /etc/os-release

if [[ "$ID" != "ubuntu" ]]; then
  exit 0
fi

machine="$(uname -m)"

case "$machine" in
  x86_64)
    architecture="x86_64"
    ;;
  aarch64 | arm64)
    architecture="aarch64"
    ;;
  *)
    printf 'Unsupported architecture: %s\n' "$machine" >&2
    exit 1
    ;;
esac

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -fL \
  "https://github.com/zellij-org/zellij/releases/latest/download/zellij-${architecture}-unknown-linux-musl.tar.gz" \
  -o "$tmp/zellij.tar.gz"

tar -xzf "$tmp/zellij.tar.gz" -C "$tmp"
sudo install -m 0755 "$tmp/zellij" /usr/local/bin/zellij

zellij --version
