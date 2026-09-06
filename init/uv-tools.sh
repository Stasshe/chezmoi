#!/usr/bin/env bash
set -euo pipefail

printf '[uv-tools] install configured tools\n'

tools=(
  posting
  ruff
)

for tool in "${tools[@]}"; do
  uv tool install "$tool"
done
