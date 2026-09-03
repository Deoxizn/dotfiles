#!/bin/bash

# SUPER+RETURN: open a terminal, adding a tab to a running kitty whenever one
# exists instead of stacking another OS window. Falls back to spawning a new
# terminal only when no live kitty instance is found.
#
# Kitty exposes one remote-control socket per instance (listen_on in
# kitty.conf -> $XDG_RUNTIME_DIR/omarchy-kitty-<pid>). Instances started
# before that option existed never create a socket - restart them once.
#
# A socket alone is not enough: closed windows can leave a windowless kitty
# process behind whose socket still answers. So liveness is decided by Niri
# itself (niri msg windows): only a kitty pid that owns a live window
# counts. (kitty's own platform_window_id is always null under Niri, so it
# cannot be used.) Without Niri (Hyprland session), fall back to the
# original "socket answers" probe.

# One pid per line for every live window Niri knows about.
niri_window_pids() {
	[[ -n "${NIRI_SOCKET:-}" ]] && command -v niri >/dev/null 2>&1 || return 0
	niri msg --json windows 2>/dev/null | jq -r '.[].pid // empty' 2>/dev/null | sort -u
}

# 0 = kitty pid owns a live window. On Niri this is ground truth from the
# compositor; without Niri it falls back to "socket answers".
pid_is_live() { # $1 = kitty pid, $2 = pid list from niri_window_pids
	local pid="$1" list="$2" s
	[[ "$pid" =~ ^[0-9]+$ ]] || return 1
	if [[ -n "${NIRI_SOCKET:-}" ]] && command -v niri >/dev/null 2>&1; then
		grep -qx "$pid" <<<"$list"
		return $?
	fi
	s="$XDG_RUNTIME_DIR/omarchy-kitty-$pid"
	[[ -S "$s" ]] && kitten @ --to "unix:$s" ls >/dev/null 2>&1
}

# Prints "<app-id> <pid>" of the focused window. Niri first, Hyprland fallback.
focused_info() {
	if [[ -n "${NIRI_SOCKET:-}" ]] && command -v niri >/dev/null 2>&1; then
		niri msg --json focused-window 2>/dev/null | \
			jq -r '"\(.app_id // empty) \(.pid // empty)"' 2>/dev/null
		return 0
	fi
	local info class pid
	info=$(hyprctl activewindow -j 2>/dev/null)
	class=$(jq -r '.class // empty' <<<"$info" 2>/dev/null)
	pid=$(jq -r '.pid // empty' <<<"$info" 2>/dev/null)
	printf '%s %s' "$class" "$pid"
}

pick_socket() {
	local app pid s newest spid win_pids

	read -r app pid <<<"$(focused_info)"
	win_pids=$(niri_window_pids)

	# Prefer the focused window when it is a kitty we can talk to.
	if [[ -n "$pid" && "$app" == "kitty" ]]; then
		s="$XDG_RUNTIME_DIR/omarchy-kitty-$pid"
		if [[ -S "$s" ]] && pid_is_live "$pid" "$win_pids"; then
			printf '%s' "$s"
			return 0
		fi
	fi

	# Otherwise the newest instance owning a live window wins. Pids
	# without a Niri window (stale sockets, windowless processes left
	# behind by closed windows) are skipped.
	newest=""
	for s in "$XDG_RUNTIME_DIR"/omarchy-kitty-*; do
		[[ -S "$s" ]] || continue
		[[ "$s" =~ omarchy-kitty-([0-9]+)$ ]] || continue
		spid="${BASH_REMATCH[1]}"
		pid_is_live "$spid" "$win_pids" || continue
		[[ -z "$newest" || "$s" -nt "$newest" ]] && newest="$s"
	done
	[[ -n "$newest" ]] && printf '%s' "$newest"
}

# Open as a new tab in the running instance (same OS window).
if socket=$(pick_socket); then
	exec kitten @ --to "unix:$socket" launch --type=tab
fi

# No visible kitty anywhere. If we *just* spawned one it may still be
# opening - wait for it and tab into it instead of stacking another
# fresh terminal (rapid Super+Enter presses).
MARKER="$XDG_RUNTIME_DIR/omarchy-kitty.spawned"
now=$(date +%s)
age=999
[[ -f "$MARKER" ]] && age=$(( now - $(stat -c %Y "$MARKER" 2>/dev/null || echo 0) ))
if (( age < 4 )); then
	for _ in $(seq 1 20); do
		sleep 0.1
		if socket=$(pick_socket); then
			exec kitten @ --to "unix:$socket" launch --type=tab
		fi
	done
fi

touch "$MARKER"
exec omarchy-launch-terminal
