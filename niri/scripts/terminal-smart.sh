#!/bin/bash

# SUPER+RETURN: open a terminal, splitting into a running kitty whenever one
# exists instead of stacking another OS window. Falls back to spawning a new
# terminal only when no live kitty instance is found.
#
# Kitty exposes one remote-control socket per instance (listen_on in
# kitty.conf -> $XDG_RUNTIME_DIR/omarchy-kitty-<pid>). Instances started
# before that option existed never create a socket - restart them once.

pick_socket() {
	local info class pid s newest

	info=$(hyprctl activewindow -j 2>/dev/null)
	class=$(jq -r '.class // empty' <<<"$info" 2>/dev/null)
	pid=$(jq -r '.pid // empty' <<<"$info" 2>/dev/null)

	# Prefer the focused window when it is a kitty we can talk to.
	if [[ -n "$pid" && "$class" == "kitty" ]]; then
		s="$XDG_RUNTIME_DIR/omarchy-kitty-$pid"
		if [[ -S "$s" ]] && kitten @ --to "unix:$s" ls >/dev/null 2>&1; then
			printf '%s' "$s"
			return 0
		fi
	fi

	# Otherwise the newest running instance with a live socket wins. The ls
	# probe also weeds out stale sockets left behind by killed instances.
	newest=""
	for s in "$XDG_RUNTIME_DIR"/omarchy-kitty-*; do
		[[ -S "$s" ]] || continue
		kitten @ --to "unix:$s" ls >/dev/null 2>&1 || continue
		[[ -z "$newest" || "$s" -nt "$newest" ]] && newest="$s"
	done
	[[ -n "$newest" ]] && printf '%s' "$newest"
}

if socket=$(pick_socket); then
	exec kitten @ --to "unix:$socket" launch --type=window
fi

exec omarchy-launch-terminal
