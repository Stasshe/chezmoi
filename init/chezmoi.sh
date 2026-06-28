#!/usr/bin/env bash
set -euo pipefail

mise exec -- chezmoi apply
mise install
