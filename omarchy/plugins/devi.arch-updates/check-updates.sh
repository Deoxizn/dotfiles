#!/bin/bash
# Count pending updates for the devi.arch-updates bar widget.
# Prints one line: "<total> <repo> <aur> <mise> <plugins> <themes>"
# Check-only: nothing here installs anything. Installs go through omarchy update
# (system, AUR, mise) and, separately, omarchy plugin update / theme git pull
# for shell plugins and themes.

repo=0
aur=0
mise=0
plugins=0
themes=0

# Repo (pacman-contrib)
if command -v checkupdates >/dev/null 2>&1; then
  repo=$(checkupdates 2>/dev/null | wc -l)
fi

# AUR (yay, falls back to paru)
if command -v yay >/dev/null 2>&1; then
  aur=$(yay -Qua 2>/dev/null | wc -l)
elif command -v paru >/dev/null 2>&1; then
  aur=$(paru -Qua 2>/dev/null | wc -l)
fi

# Mise dev tools. MISE_MINIMUM_RELEASE_AGE=0 so the count matches what an
# update installs (same as omarchy update does). Prefers --json + jq; falls
# back to counting plain output lines after the header when jq is missing.
if command -v mise >/dev/null 2>&1; then
  if command -v jq >/dev/null 2>&1; then
    mise=$(MISE_MINIMUM_RELEASE_AGE=0 timeout 120 mise outdated --json 2>/dev/null | jq '[to_entries[] | select(.value.current != .value.latest and .value.latest != "")] | length' 2>/dev/null)
  else
    mise=$(MISE_MINIMUM_RELEASE_AGE=0 timeout 120 mise outdated 2>/dev/null | awk 'NR>1 && NF' | wc -l)
  fi
fi

# Shell plugins: git checkouts in ~/.config/omarchy/plugins with a remote.
# A plugin counts when its tracked branch is behind after a fetch (same
# approach as techspawn.updates). Fetches run in parallel so a full plugin
# list stays fast. Plain folders, symlinks, and checkouts without a remote
# are not counted.
plugins_dir="$HOME/.config/omarchy/plugins"
if [ -d "$plugins_dir" ]; then
  plug_tmp=$(mktemp -d)
  for d in "$plugins_dir"/*/; do
    d=${d%/}
    [ -f "$d/manifest.json" ] || continue
    [ -L "$d" ] && continue
    [ -d "$d/.git" ] || continue
    (
      branch=$(git -C "$d" symbolic-ref -q --short HEAD 2>/dev/null)
      remote=""; ref=""
      if [ -n "$branch" ]; then
        remote=$(git -C "$d" config --get "branch.$branch.remote" 2>/dev/null)
        merge=$(git -C "$d" config --get "branch.$branch.merge" 2>/dev/null)
        if [ -n "$remote" ] && [ "$remote" != "." ] && [ -n "$merge" ]; then
          ref="$merge"
        fi
      fi
      if [ -z "$ref" ]; then
        git -C "$d" remote get-url origin >/dev/null 2>&1 || exit 0
        remote="origin"; ref="HEAD"
      fi
      if timeout 30 git -C "$d" fetch --quiet --no-tags "$remote" "$ref" 2>/dev/null; then
        target=$(git -C "$d" rev-parse -q --verify 'FETCH_HEAD^{commit}' 2>/dev/null)
        if [ -n "$target" ]; then
          behind=$(git -C "$d" rev-list --count "HEAD..$target" 2>/dev/null || echo 0)
          behind=$(echo "$behind" | tr -d ' ')
          if [ -n "$behind" ] && [ "$behind" -gt 0 ] 2>/dev/null; then
            : > "$plug_tmp/$(basename "$d")"
          fi
        fi
      fi
    ) &
  done
  wait
  plugins=$(find "$plug_tmp" -type f 2>/dev/null | wc -l)
  rm -rf "$plug_tmp"
fi

# Git themes (from omarchy-theme-extras). A theme counts when its upstream
# branch is behind after a fetch.
if command -v omarchy-theme-extras >/dev/null 2>&1; then
  while IFS= read -r t; do
    [ -n "$t" ] || continue
    [ -d "$t/.git" ] || continue
    if timeout 30 git -C "$t" fetch --quiet 2>/dev/null; then
      behind=$(git -C "$t" rev-list --count 'HEAD..@{upstream}' 2>/dev/null || echo 0)
      behind=$(echo "$behind" | tr -d ' ')
      if [ -n "$behind" ] && [ "$behind" -gt 0 ] 2>/dev/null; then
        themes=$((themes + 1))
      fi
    fi
  done < <(omarchy-theme-extras 2>/dev/null)
fi

# Normalize to plain numbers (wc -l output can carry spaces).
repo=$(echo "$repo" | tr -d ' ')
aur=$(echo "$aur" | tr -d ' ')
mise=$(echo "$mise" | tr -d ' ')
plugins=$(echo "$plugins" | tr -d ' ')
themes=$(echo "$themes" | tr -d ' ')

# Guard against empty/non-numeric values (e.g. a failed query).
for v in repo aur mise plugins themes; do
  eval "val=\$$v"
  case "$val" in
    ''|*[!0-9]*) eval "$v=0" ;;
  esac
done

echo "$((repo + aur + mise + plugins + themes)) $repo $aur $mise $plugins $themes"
