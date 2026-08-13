#!/bin/bash

# SUPER+RETURN: launch a new terminal, but if a kitty window is already
# focused, split inside it instead of stacking another terminal window.

pid=$(hyprctl activewindow -j 2>/dev/null | jq -r '.pid // empty' 2>/dev/null)
socket="$XDG_RUNTIME_DIR/omarchy-kitty-$pid"

if [[ -n "$pid" && -S "$socket" ]]; then
  exec kitten @ --to "unix:$socket" launch --type=window
else
  exec omarchy-launch-terminal
fi
