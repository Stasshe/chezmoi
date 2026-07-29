#!/usr/bin/env bash
set -euo pipefail

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -fL \
  https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz \
  -o "$tmp/zellij.tar.gz"

tar -xzf "$tmp/zellij.tar.gz" -C "$tmp"
sudo install -m 0755 "$tmp/zellij" /usr/local/bin/zellij

zellij --version
