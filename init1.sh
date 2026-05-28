#!/usr/bin/env bash
set -euo pipefail

echo "[init] install base packages"

if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y \
    curl \
    git \
    gh \
    zsh \
    build-essential \
    ca-certificates \
    unzip \
    gpg
fi

echo
echo "[init] GitHub CLI login"
echo "Run:"
echo
echo "  gh auth login"
echo
echo "After login, run:"
echo
echo "  ./scripts/init02.sh"
echo

gh auth status || true