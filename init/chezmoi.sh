#!/usr/bin/env bash
set -euo pipefail

source_dir="$1"

mise exec -- chezmoi apply --source "$source_dir"
