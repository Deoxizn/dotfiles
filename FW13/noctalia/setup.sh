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

echo ">> Applying Noctalia settings (arch-updater -> noctarchy hook)..."
SETTINGS_SRC="$(cd "$SCRIPT_DIR/../../noctalia" && pwd)/settings.toml"
if [[ -f "$SETTINGS_SRC" ]]; then
  mkdir -p ~/.local/state/noctalia
  cp "$SETTINGS_SRC" ~/.local/state/noctalia/settings.toml
  echo "   settings.toml applied (update_mode=terminal, update_cmd=noctarchy-update-run)"
else
  echo "   (no settings.toml found at $SETTINGS_SRC, skipping)"
fi

echo ">> Patching arch-updater plugin for Noctarchy (terminal -> noctarchy-update-run)..."
PATCH_SRC="$(cd "$SCRIPT_DIR/../../noctalia/patches" && pwd)/arch-updater-noctarchy.patch"
SERVICE_FILE="$HOME/.local/state/noctalia/plugins/materialized/community/arch-updater/service.luau"
if [[ -f "$PATCH_SRC" && -f "$SERVICE_FILE" ]]; then
  if grep -q 'noctarchy-update-run' "$SERVICE_FILE"; then
    echo "   already patched"
  else
    # apply with patch, fallback to sed if patch not available
    if command -v patch >/dev/null 2>&1; then
      if patch -p1 --forward --directory="$(dirname "$SERVICE_FILE")" < "$PATCH_SRC" 2>/dev/null; then
        echo "   patched via patch(1)"
      else
        echo "   patch(1) failed, trying sed fallback..."
        # sed fallback: insert override block at buildTerminalCommand
        if ! grep -q 'local override = trim(cfg("update_cmd"))' "$SERVICE_FILE"; then
          # insert after 'local function buildTerminalCommand()'
          sed -i '/^local function buildTerminalCommand()/a \    local override = trim(cfg("update_cmd"))\n    if override ~= "" then\n        return override\n    end\n    if noctalia.commandExists("noctarchy-update-run") then\n        return "noctarchy-update-run"\n    end\n' "$SERVICE_FILE"
          echo "   patched via sed"
        fi
      fi
    else
      echo "   patch not found, using sed"
      sed -i '/^local function buildTerminalCommand()/a \    local override = trim(cfg("update_cmd"))\n    if override ~= "" then\n        return override\n    end\n    if noctalia.commandExists("noctarchy-update-run") then\n        return "noctarchy-update-run"\n    end\n' "$SERVICE_FILE"
      echo "   patched via sed"
    fi
  fi
else
  if [[ ! -f "$PATCH_SRC" ]]; then echo "   patch not found at $PATCH_SRC, skipping"; fi
  if [[ ! -f "$SERVICE_FILE" ]]; then echo "   service.luau not yet materialized (enable plugin first), skipping"; fi
fi

echo ">> Reloading Noctalia..."
noctalia msg config-reload || true
# restart to reload patched service if needed
if pgrep -x noctalia >/dev/null 2>&1; then
  echo "   (patched service requires restart: kill and restart noctalia or run: pkill noctalia; noctalia --daemon)"
fi

echo ""
echo "Done. Check the bar for arch-updater and bongocat."
