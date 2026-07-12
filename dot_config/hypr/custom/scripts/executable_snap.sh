#!/usr/bin/env bash
# Windows-Snap-style half-screen placement for the focused floating window.
# Usage: snap.sh left|right|top|bottom
set -euo pipefail

dir="$1"

mon="$(hyprctl -j activewindow | jq -r '.monitor')"
read -r mx my mw mh rt rr rb rl < <(hyprctl -j monitors | jq -r --argjson m "$mon" '
  .[] | select(.id == $m) | "\(.x) \(.y) \(.width / .scale) \(.height / .scale) \(.reserved[1]) \(.reserved[2]) \(.reserved[3]) \(.reserved[0])"
')

wx=$mx
wy=$((my + rt))
ww=$mw
wh=$(echo "$mh - $rt - $rb" | bc)

half_w=$(echo "$ww / 2" | bc)
half_h=$(echo "$wh / 2" | bc)

case "$dir" in
  left)   x=$wx;            y=$wy;            w=$half_w; h=$wh ;;
  right)  x=$((wx + half_w)); y=$wy;          w=$half_w; h=$wh ;;
  top)    x=$wx;            y=$wy;            w=$ww;     h=$half_h ;;
  bottom) x=$wx;            y=$((wy + half_h)); w=$ww;   h=$half_h ;;
  *) echo "usage: snap.sh left|right|top|bottom" >&2; exit 1 ;;
esac

hyprctl dispatch "hl.dsp.window.float({action=\"enable\"})"
hyprctl dispatch "hl.dsp.window.move({x=$x, y=$y, relative=false})"
hyprctl dispatch "hl.dsp.window.resize({x=$w, y=$h, relative=false})"
