#!/usr/bin/env bash
# Wayland has no primary-monitor concept, so XWayland leaves the randr primary
# output unset. X11 games then fall back to the first output (HDMI-A-1) instead
# of DP-1. Mark DP-1 primary at startup and re-assert it whenever monitors
# change, the config is reloaded, or the flag is dropped (e.g. after resume).
set -euo pipefail

output="DP-1"

is_primary() {
  xrandr --query 2>/dev/null | grep -qE "^${output} connected primary"
}

is_connected() {
  xrandr --query 2>/dev/null | grep -qE "^${output} connected"
}

ensure_primary() {
  is_primary && return 0
  is_connected || return 1
  xrandr --output "$output" --primary 2>/dev/null
}

# Xwayland can take a moment to come up after hyprland.start.
for _attempt in {1..50}; do
  ensure_primary && break
  sleep 0.2
done

# Backstop for the occasional flag loss on resume, where no Hyprland event fires.
poll() {
  while sleep 10; do
    ensure_primary || true
  done
}

poll &
poll_pid=$!
trap 'kill "$poll_pid" 2>/dev/null' EXIT INT TERM

socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

socat -U - "UNIX-CONNECT:${socket}" | while read -r event; do
  case "$event" in
    monitoradded\>\>* | monitorremoved\>\>* | configreloaded\>\>*)
      sleep 0.3
      ensure_primary || true
      ;;
  esac
done
