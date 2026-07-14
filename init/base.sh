#!/usr/bin/env bash
set -euo pipefail


if command -v saya >/dev/null 2>&1; then
  saya self-update
else
  curl -fsSL https://raw.githubusercontent.com/Stasshe/saya/main/install.sh | sh
fi

saya update
saya install


if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
