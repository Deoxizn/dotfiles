#!/bin/sh
# Wake fix - try non-destructive first, fallback to niri restart (closes windows like reboot but faster)
niri msg action power-on-monitors 2>&1 | head -5
# Force niri to recalc input regions for rotated HDMI (DPMS bug) - separate mode + transform
niri msg output HDMI-A-1 transform 90 2>&1 >/dev/null || true
sleep 1
niri msg action power-on-monitors 2>&1 >/dev/null || true
# Rebind bar
pkill -9 noctalia; sleep 1; noctalia >/tmp/noctalia.log 2>&1 & disown
sleep 1
# Check if HDMI bar still dead - if so, fallback to niri restart (uncomment next line if output fix not enough)
# systemctl --user restart niri.service
