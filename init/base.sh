#!/usr/bin/env bash
set -euo pipefail


curl -fsSL https://raw.githubusercontent.com/Stasshe/saya/main/install.sh | sh


echo "[init] install base packages"

if command -v apt >/dev/null 2>&1; then
  saya update
  saya install \
    curl \
    git \
    gh \
    zsh \
    build-essential \
    ca-certificates \
    unzip \
    gpg
fi