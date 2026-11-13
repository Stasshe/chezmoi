#!/bin/bash
# Claude Code statusline: model name + pwd.
#
# settings.json:
#   "statusLine": { "type": "command", "command": "bash ~/.claude/hooks/statusline.sh" }

input=$(cat)

MODEL=$(printf '%s' "$input" | jq -r '.model.display_name // "?"')
RAW_DIR=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // "?"')
DIR="${RAW_DIR/#$HOME/\~}"

SETTINGS="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/settings.json"
EFFORT=$(jq -r '.effortLevel // empty' "$SETTINGS" 2>/dev/null)

BRANCH=$(git -C "$RAW_DIR" branch --show-current 2>/dev/null)

printf '\033[38;5;39m%s\033[0m \033[38;5;244m%s\033[0m' "$MODEL" "$DIR"
[ -n "$BRANCH" ] && printf ' \033[38;5;214m(%s)\033[0m' "$BRANCH"
[ -n "$EFFORT" ] && printf ' \033[38;5;178m[%s]\033[0m' "$EFFORT"

printf '\n'
