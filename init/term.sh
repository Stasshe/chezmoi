#!/usr/bin/env bash
set -euo pipefail

echo "[init02] install Oh My Zsh"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh |
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -s --
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

echo "[init02] install oh-my-posh theme"

mkdir -p "$HOME/.poshthemes"

if [ ! -f "$HOME/.poshthemes/unicorn.omp.json" ]; then
  curl -fsSL \
    https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/unicorn.omp.json \
    -o "$HOME/.poshthemes/unicorn.omp.json"
fi
