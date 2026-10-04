#!/usr/bin/env bash
# Watch codex TUI sessions in tmux and print one line per notable event.
# Usage: watch.sh <tmux-session> [<tmux-session> ...]
declare -A prev stalled questioned alive idle compactions compacting
for s in "$@"; do
  prev[$s]=""; stalled[$s]=0; questioned[$s]=0; alive[$s]=1; idle[$s]=0; compactions[$s]=0; compacting[$s]=0
done
while :; do
  any=0
  for s in "$@"; do
    if ! tmux has-session -t "$s" 2>/dev/null; then
      if [ "${alive[$s]}" -eq 1 ]; then echo "$s: session ended"; alive[$s]=0; fi
      continue
    fi
    any=1
    pane=$(tmux capture-pane -p -t "$s")

    if echo "$pane" | grep -q "Type your answer\|? [0-9] question"; then
      if [ "${questioned[$s]}" -eq 0 ]; then echo "$s: pending questions"; questioned[$s]=1; fi
    else
      questioned[$s]=0
    fi

    if echo "$pane" | grep -q "Compacting context"; then
      if [ "${compacting[$s]}" -eq 0 ]; then
        compactions[$s]=$((compactions[$s] + 1))
        echo "$s: compacting (#${compactions[$s]} since watch start)"
        compacting[$s]=1
      fi
    else
      compacting[$s]=0
    fi

    # "Working (" flickers during redraws, so require 30s of continuous absence.
    if echo "$pane" | grep -q "Working (\|Compacting context\|Waiting for background terminal\|Waiting for agents"; then
      idle[$s]=0
    else
      idle[$s]=$((idle[$s] + 1))
      if [ "${idle[$s]}" -eq 6 ]; then echo "$s: turn finished"; fi
    fi

    digest=$(echo "$pane" | md5sum)
    if [ "$digest" = "${prev[$s]}" ]; then stalled[$s]=$((stalled[$s] + 1)); else stalled[$s]=0; fi
    if [ "${stalled[$s]}" -eq 36 ]; then echo "$s: stalled 3min"; fi
    prev[$s]=$digest
  done
  if [ "$any" -eq 0 ]; then break; fi
  sleep 5
done
