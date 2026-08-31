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

echo ">> Installing persistent patch watcher (survives reboots + plugin updates)..."
PATCH_SCRIPT_SRC="$(cd "$SCRIPT_DIR/../../local/bin" && pwd)/noctalia-patch-arch-updater"
PATCH_SCRIPT_DST="$HOME/.local/bin/noctalia-patch-arch-updater"
if [[ -f "$PATCH_SCRIPT_SRC" ]]; then
  mkdir -p "$(dirname "$PATCH_SCRIPT_DST")"
  if [[ ! -f "$PATCH_SCRIPT_DST" ]] || ! cmp -s "$PATCH_SCRIPT_SRC" "$PATCH_SCRIPT_DST"; then
    install -m755 "$PATCH_SCRIPT_SRC" "$PATCH_SCRIPT_DST"
    echo "   installed noctalia-patch-arch-updater to $PATCH_SCRIPT_DST"
  else
    echo "   noctalia-patch-arch-updater up to date"
  fi
else
  echo "   patch script not found at $PATCH_SCRIPT_SRC, skipping"
fi
SYSTEMD_SRC_DIR="$(cd "$SCRIPT_DIR/../../systemd/user" && pwd)"
SYSTEMD_DST_DIR="$HOME/.config/systemd/user"
if [[ -d "$SYSTEMD_SRC_DIR" ]]; then
  mkdir -p "$SYSTEMD_DST_DIR"
  for unit in arch-updater-noctarchy-patch.service arch-updater-noctarchy-patch.path; do
    if [[ -f "$SYSTEMD_SRC_DIR/$unit" ]]; then
      if [[ ! -f "$SYSTEMD_DST_DIR/$unit" ]] || ! cmp -s "$SYSTEMD_SRC_DIR/$unit" "$SYSTEMD_DST_DIR/$unit"; then
        install -m644 "$SYSTEMD_SRC_DIR/$unit" "$SYSTEMD_DST_DIR/$unit"
        echo "   installed $unit"
      else
        echo "   $unit up to date"
      fi
    fi
  done
  systemctl --user daemon-reload 2>/dev/null || true
  systemctl --user enable arch-updater-noctarchy-patch.path 2>/dev/null || true
  systemctl --user enable arch-updater-noctarchy-patch.service 2>/dev/null || true
  systemctl --user start arch-updater-noctarchy-patch.path 2>/dev/null || true
  # also run once now to ensure patched after this setup
  systemctl --user start arch-updater-noctarchy-patch.service 2>/dev/null || true
  echo "   enabled path watcher (active: $(systemctl --user is-active arch-updater-noctarchy-patch.path 2>/dev/null || echo unknown))"
else
  echo "   systemd units not found at $SYSTEMD_SRC_DIR, skipping"
fi

echo ">> Reloading Noctalia..."
noctalia msg config-reload || true
# restart to reload patched service if needed
if pgrep -x noctalia >/dev/null 2>&1; then
  echo "   (patched service requires restart: kill and restart noctalia or run: pkill noctalia; noctalia --daemon)"
fi

echo ""
echo "Done. Check the bar for arch-updater and bongocat."
