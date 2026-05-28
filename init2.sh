#!/usr/bin/env bash
set -euo pipefail

echo "[init02] check GitHub auth"

if ! gh auth status >/dev/null 2>&1; then
  echo "[init02] gh is not authenticated."
  echo "Run:"
  echo "  gh auth login"
  exit 1
fi

export GITHUB_TOKEN="$(gh auth token)"

echo "[init02] install mise"

if [ ! -x "$HOME/.local/bin/mise" ]; then
  curl https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

echo "[init02] install Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "[init02] install Oh My Zsh plugins"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

echo "[init02] mise install"

mise install

echo "[init02] shell"

if command -v zsh >/dev/null 2>&1; then
  if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
    echo "To change default shell, run:"
    echo "  chsh -s \"$(command -v zsh)\""
  fi
fi

echo "[init02] done"