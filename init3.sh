#!/usr/bin/env bash
set -euo pipefail

echo "[init03] install global Node CLIs"
npm install -g @openai/codex ctx-gleaner uipro-cli

echo "[init03] install ffmpeg"
if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y ffmpeg
fi

echo "[init03] install Headroom CLI with uv"
if ! command -v uv >/dev/null 2>&1; then
  echo "[init03] uv is not installed. Run ./init2.sh first."
  exit 1
fi

if command -v python3.13 >/dev/null 2>&1; then
  python_bin="python3.13"
else
  python_bin="python3"
fi

uv tool install --python "$python_bin" "headroom-ai[all]"

echo "[init03] verification"
echo "codex:    $(command -v codex)"
echo "headroom: $(command -v headroom)"

echo
echo "[init03] done"
