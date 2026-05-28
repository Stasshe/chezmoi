#!/usr/bin/env bash
set -euo pipefail

echo "[init02] check GitHub auth"

if ! command -v gh >/dev/null 2>&1; then
  echo "[init02] gh is not installed."
  echo "Run scripts/init.sh first."
  exit 1
fi

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

echo "[init02] mise install"

mise install

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

echo "[init02] install oh-my-posh theme"

mkdir -p "$HOME/.poshthemes"

if [ ! -f "$HOME/.poshthemes/unicorn.omp.json" ]; then
  curl -fsSL \
    https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/unicorn.omp.json \
    -o "$HOME/.poshthemes/unicorn.omp.json"
fi

echo "[init02] apply chezmoi"

chezmoi apply

echo "[init02] set default shell"

ZSH_PATH="$(command -v zsh)"

if ! grep -qx "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

CURRENT_SHELL="$(getent passwd "$USER" | awk -F: '{print $7}')"

if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
  sudo usermod -s "$ZSH_PATH" "$USER"
fi

echo "[init02] verification"

echo "zsh:        $(command -v zsh)"
echo "mise:       $(command -v mise)"
echo "oh-my-posh: $(command -v oh-my-posh)"
echo "eza:        $(command -v eza)"
echo "fzf:        $(command -v fzf)"
echo "zoxide:     $(command -v zoxide)"
echo "shell:      $(getent passwd "$USER" | awk -F: '{print $7}')"

echo
echo "[init02] done"
echo "Close this WSL window and open Ubuntu again."