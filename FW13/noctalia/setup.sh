#!/bin/bash
# FW13 Noctarchy setup — install plugins and apply Noctalia config
# Run on the Framework 13 laptop. Noctalia must already be installed.
set -e

echo ">> Enabling plugins..."
noctalia msg plugins enable yuuto/arch-updater || true
noctalia msg plugins enable noctalia/bongocat || true

echo ">> Applying config..."
mkdir -p ~/.config/noctalia
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/config.toml" ~/.config/noctalia/config.toml

echo ">> Detecting internal keyboard for bongocat..."
FW_KBD=$(ls /dev/input/by-path/ 2>/dev/null | grep -i -m1 "kbd" || true)
if [[ -n "$FW_KBD" ]]; then
  sed -i "s|/dev/input/by-path/platform-\*kbd\*|/dev/input/by-path/$FW_KBD|" ~/.config/noctalia/config.toml
  echo "   Using /dev/input/by-path/$FW_KBD"
else
  echo "   (no keyboard detected, leaving glob)"
fi

echo ">> Noctarchy hook guard for arch-updater removed"
echo "   (patch watcher + settings overrides dropped; plugin uses its default terminal)"

echo ">> Reloading Noctalia..."
noctalia msg config-reload || true
# restart to reload patched service if needed
if pgrep -x noctalia >/dev/null 2>&1; then
  echo "   (patched service requires restart: kill and restart noctalia or run: pkill noctalia; noctalia --daemon)"
fi

echo ""
echo "Done. Check the bar for arch-updater and bongocat."
