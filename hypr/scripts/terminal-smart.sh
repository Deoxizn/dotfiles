#!/bin/bash

# SUPER+RETURN: open a terminal, adding a tab to a running kitty whenever one
# exists instead of stacking another OS window. Falls back to spawning a new
# terminal only when no live kitty instance is found.
#
# Kitty exposes one remote-control socket per instance (listen_on in
# kitty.conf -> $XDG_RUNTIME_DIR/hexciri-kitty-<pid>). Instances started
# before that option existed never create a socket - restart them once.
#
# A socket alone is not enough: closed windows can leave a windowless kitty
# process behind whose socket still answers. So liveness is decided by
# Hyprland itself (hyprctl clients -j): only a kitty pid that owns a live
# window counts. If hyprctl is unavailable, fall back to the original
# "socket answers" probe.
#
# JSON is parsed with python3 (stdlib only): jq may not be installed, while
# python3 ships with the system.

# One pid per line for every live window Hyprland knows about.
hypr_window_pids() {
	command -v hyprctl >/dev/null 2>&1 || return 0
	hyprctl clients -j 2>/dev/null | python3 -c 'import json,sys
try:
    clients = json.load(sys.stdin)
except Exception:
    clients = []
for c in clients if isinstance(clients, list) else []:
    pid = c.get("pid") if isinstance(c, dict) else None
    if pid is not None:
        print(pid)' 2>/dev/null | sort -u
}

# 0 = kitty pid owns a live window (ground truth from the compositor); with
# hyprctl unavailable, 0 = the pid's socket still answers.
pid_is_live() { # $1 = kitty pid, $2 = pid list from hypr_window_pids
	local pid="$1" list="$2" s
	[[ "$pid" =~ ^[0-9]+$ ]] || return 1
	if command -v hyprctl >/dev/null 2>&1; then
		grep -qx "$pid" <<<"$list"
		return $?
	fi
	s="$XDG_RUNTIME_DIR/hexciri-kitty-$pid"
	[[ -S "$s" ]] && kitten @ --to "unix:$s" ls >/dev/null 2>&1
}

# Prints "<class> <pid>" of the focused window.
focused_info() {
	local info
	info=$(hyprctl activewindow -j 2>/dev/null)
	python3 -c 'import json,sys
try:
    w = json.load(sys.stdin)
except Exception:
    w = {}
if not isinstance(w, dict):
    w = {}
app = w.get("class")
pid = w.get("pid")
print(app if app is not None else "", pid if pid is not None else "")' <<<"$info" 2>/dev/null
}

pick_socket() {
	local app pid s newest spid win_pids

	read -r app pid <<<"$(focused_info)"
	win_pids=$(hypr_window_pids)

	# Prefer the focused window when it is a kitty we can talk to.
	if [[ -n "$pid" && "$app" == "kitty" ]]; then
		s="$XDG_RUNTIME_DIR/hexciri-kitty-$pid"
		if [[ -S "$s" ]] && pid_is_live "$pid" "$win_pids"; then
			printf '%s' "$s"
			return 0
		fi
	fi

	# Otherwise the newest instance owning a live window wins. Pids
	# without a Hyprland window (stale sockets, windowless processes left
	# behind by closed windows) are skipped.
	newest=""
	for s in "$XDG_RUNTIME_DIR"/hexciri-kitty-*; do
		[[ -S "$s" ]] || continue
		[[ "$s" =~ hexciri-kitty-([0-9]+)$ ]] || continue
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
MARKER="$XDG_RUNTIME_DIR/hexciri-kitty.spawned"
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
exec hexciri-terminal
