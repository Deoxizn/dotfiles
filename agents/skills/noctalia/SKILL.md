---
name: noctalia
description: >
  Expert knowledge for configuring and troubleshooting the Noctalia Wayland desktop
  shell. REQUIRED when editing anything under ~/.config/noctalia/ or ~/.local/state/noctalia/,
  or diagnosing bar, launcher, dock, notifications, OSD, wallpaper, lock screen, clipboard,
  system tray, session manager, desktop widgets, or theming behavior. Covers the TOML config
  format, the hybrid config architecture (TOML + GUI overrides), widget system (30+ types),
  IPC, plugin system, template-based app theming, wallpaper-driven dynamic colors, the C++23
  rendering pipeline, and multi-compositor support (Niri, Hyprland, Sway, Scroll, Mango,
  Labwc, Triad, dwl). Triggers: noctalia, noctalia shell, noctalia config, config.toml,
  noctalia bar, noctalia launcher, noctalia lock, noctalia dock, noctalia notifications,
  noctalia wallpaper, noctalia tray, noctalia osd, noctalia clipboard, noctalia plugins,
  noctalia widgets, noctalia ipc, noctalia theming, noctalia templates, noctalia v5.
---

# Noctalia Skill

Expert agent for the **Noctalia Wayland desktop shell** — a complete bar/launcher/lock/
notifications/widgets layer for any Wayland compositor. Grounded in **Noctalia v5** (current,
C++23 + OpenGL ES + Wayland, ~9.4K stars).

## 0. Primary references

- **Docs (authoritative)**: <https://docs.noctalia.dev>
- **v5 shell docs**: <https://docs.noctalia.dev/noctalia/>
- **Configuration**: <https://docs.noctalia.dev/noctalia/configuration/>
- **Installation**: <https://docs.noctalia.dev/noctalia/getting-started/installation/>
- **Bar & widgets**: <https://docs.noctalia.dev/noctalia/bar/>
- **Theming**: <https://docs.noctalia.dev/noctalia/theming/>
- **Templates**: <https://docs.noctalia.dev/noctalia/theming/templates/>
- **IPC**: <https://docs.noctalia.dev/noctalia/ipc/>
- **Plugin development**: <https://docs.noctalia.dev/noctalia/plugins/development/>
- **Plugins catalog**: <https://docs.noctalia.dev/noctalia/plugins/>
- **GitHub org**: <https://github.com/noctalia-dev>
- **Main repo (v5)**: <https://github.com/noctalia-dev/noctalia> (~9.4K stars, MIT)
- **Website**: <https://noctalia.dev>
- **Blog**: <https://noctalia.dev/blog>
- **Discord**: <https://discord.noctalia.dev>
- **NixOS Wiki**: <https://wiki.nixos.org/wiki/Noctalia_Shell>

## 1. What Noctalia is

Noctalia is a **standalone Wayland desktop shell** — the visual/service layer that sits
on top of a Wayland compositor. It provides everything a "desktop environment" provides
visually, but without being tied to a specific compositor.

**Replaces**: bar (Waybar), notification daemon (Mako/Dunst), lock screen (Hyprlock/swaylock),
launcher (Rofi/Wofi), wallpaper tool (swww/hyprpaper), OSD, system tray, session manager,
clipboard manager, desktop widgets — all in one process.

**Supports 7+ compositors**: Niri, Hyprland, Sway, Scroll, Mango, Labwc, Triad, dwl —
and any compositor that implements standard layer-shell + `ext-workspace-v1`.

### v5 architecture (current)

| Aspect | Detail |
|--------|--------|
| Language | **C++23** (GCC 13+ or Clang 16+) |
| Rendering | **Wayland layer-shell + OpenGL ES** (no Qt, no GTK) |
| Build | Meson + `just` |
| Config | **TOML** (user) + JSON (GUI overrides) |
| Reactivity | Poll-based (inotify, DBus, PipeWire) |
| Memory | ~50 MB (vs ~300 MB/monitor in v4 Quickshell era) |
| Vendored deps | Wuffs, Luau (scripting), fzy (fuzzy matching), Material Color Utilities |

### v4 (legacy, frozen)

- Built on **Quickshell** (Qt/QML)
- Separate config from v5 — they can coexist
- Legacy repo: `noctalia-dev/noctalia-shell` (archived)
- Legacy docs: <https://docs.noctalia.dev/noctalia-shell/>

## 2. Installation

| Distro | Method |
|--------|--------|
| Arch Linux | `sudo pacman -S noctalia` (in [extra]) |
| Fedora 44+ | `sudo dnf install noctalia` |
| NixOS | Flake or Home Manager: `programs.noctalia.enable = true` |
| Debian/Ubuntu | APT repo at `pkg.noctalia.dev` |
| openSUSE | OBS: `home:neifua:Noctalia` |
| Gentoo | GURU: `emerge gui-apps/noctalia` |
| Void Linux | Custom XBPS repo or xbps-src |
| Manual | `git clone && just configure release && just build release && sudo just install release` |

Also included in **CachyOS** ISO (June 2026+) as a Hyprland desktop option.

## 3. Config format: TOML

### File locations

| Path | Purpose |
|------|---------|
| `~/.config/noctalia/config.toml` | Main user config |
| `~/.config/noctalia/*.toml` | Additional TOML files (merge alphabetically) |
| `~/.local/state/noctalia/settings.toml` | GUI overrides (written by Settings UI, wins over user config) |
| `~/.local/state/noctalia/state.toml` | Internal runtime state |
| `~/.config/noctalia/palettes/` | Custom color palettes |
| `~/.local/share/noctalia/plugins/` | Installed plugins |

### Config merge order

Built-in defaults → user TOML files (alphabetical) → GUI overrides (`settings.toml`)

### Hot reload

Inotify-based — changes to TOML files are detected and applied live.

### TOML basics

```toml
[general]
terminal = "alacritty"
launcher = "fuzzel"

[bar]
position = "top"
height = 40
opacity = 0.95

[bar.widgets]
left = ["workspaces", "separator"]
center = ["clock"]
right = ["network", "bluetooth", "battery", "tray"]

[lock]
command = "swaylock"
idle_timeout = 300

[wallpaper]
enabled = true
directory = "~/Pictures/Wallpapers"
```

## 4. Key config sections

### `[general]`
```toml
[general]
terminal = "alacritty"
launcher = "fuzzel"
file_manager = "thunar"
browser = "firefox"
```

### `[bar]`
```toml
[bar]
position = "top"           # "top" | "bottom" | "left" | "right"
height = 40                # pixel height (or width for left/right)
opacity = 0.95
exclusive = true           # reserve screen space
```

### `[bar.widgets]`
Widget order per bar section. 30+ widget types available:

```toml
[bar.widgets]
left = ["workspaces", "separator", "active-window"]
center = ["clock"]
right = ["network", "bluetooth", "battery", "volume", "brightness", "tray", "media"]

[bar.widgets.clock]
format = "%H:%M"
interval = 1

[bar.widgets.workspaces]
persistent = [1, 2, 3, 4, 5]
```

**Widget types**: `workspaces`, `active-window`, `clock`, `date`, `battery`, `network`, `bluetooth`, `volume`, `brightness`, `media`, `tray`, `sysmon`, `cpu`, `memory`, `disk`, `temperature`, `fan-speed`, `power-profile`, `night-light`, `clipboard`, `weather`, `separator`, `spacing`, and more.

### `[launcher]`
```toml
[launcher]
command = "fuzzel"
width = 600
height = 400
```

### `[notifications]`
```toml
[notifications]
enabled = true
timeout = 5000
max_visible = 5
position = "top-right"
```

### `[lock]`
```toml
[lock]
command = "swaylock"
idle_timeout = 300         # seconds before auto-lock
before_sleep = true        # lock before suspend
```

### `[wallpaper]`
```toml
[wallpaper]
enabled = true
directory = "~/Pictures/Wallpapers"
mode = "fill"              # "fill" | "fit" | "stretch" | "center"
interval = 300             # rotation interval (seconds), 0 = off
transition = "fade"
```

### `[dock]`
```toml
[dock]
enabled = true
position = "bottom"
icon_size = 48
auto_hide = true
```

### `[osd]`
```toml
[osd]
enabled = true
volume = true
brightness = true
timeout = 2000
```

### `[clipboard]`
```toml
[clipboard]
enabled = true
max_entries = 100
encrypted = true           # uses Secret Service
```

### `[theming]`
```toml
[theming]
source = "wallpaper"       # "wallpaper" | "manual"
dark_mode = true
accent_color = "#7c3aed"
border_radius = 12
```

## 5. Widget system

Widgets are configured inline in `[bar.widgets.*]` sections. Each widget type has its own config sub-section.

### Common widget configs

```toml
[bar.widgets.clock]
format = "%H:%M:%S"
interval = 1
tooltip_format = "%A, %d %B %Y"

[bar.widgets.battery]
critical_threshold = 15
warning_threshold = 30
show_percentage = true

[bar.widgets.network]
show_wifi = true
show_wired = true
show_vpn = true

[bar.widgets.media]
show_album_art = true
max_title_length = 40

[bar.widgets.sysmon]
interval = 2
```

## 6. Theming pipeline

### Wallpaper-driven dynamic colors

Noctalia extracts colors from the current wallpaper and propagates them across all shell surfaces — similar to Material You / matugen.

```toml
[theming]
source = "wallpaper"       # auto-extract from wallpaper
dark_mode = true           # or auto-detect from wallpaper luminance
```

### Custom palettes

Drop TOML palette files in `~/.config/noctalia/palettes/`:
```toml
# ~/.config/noctalia/palettes/my-theme.toml
[palette]
name = "My Theme"
accent = "#7c3aed"
background = "#1a1a2e"
foreground = "#e0e0e0"
surface = "#16213e"
```

### Template-based app theming

Noctalia can theme GTK, Qt, Firefox, Discord, VSCode, Spotify, and more:
```toml
[theming.templates]
enabled = true
targets = ["gtk", "qt", "firefox", "discord", "vscode"]
```

Templates generate config files for each app based on the active color scheme.

## 7. IPC

```bash
noctalia ipc <command>      # runtime control
noctalia ipc bar reload     # reload bar config
noctalia ipc wallpaper next # switch wallpaper
noctalia ipc theme set my-theme
noctalia ipc lock           # trigger lock
```

Check docs for full IPC command reference: <https://docs.noctalia.dev/noctalia/ipc/>

## 8. Plugin system

Plugins live in `~/.local/share/noctalia/plugins/`. 132+ available (official + community).

```toml
[plugins]
enabled = true
# plugins auto-discovered from plugin directory
```

Plugin development docs: <https://docs.noctalia.dev/noctalia/plugins/development/>

## 9. Multi-compositor support

Noctalia works with any compositor that implements:
- **wlr-layer-shell** (for bar/launcher/notifications surfaces)
- **ext-workspace-v1** (for workspace display)
- Standard Wayland protocols for lock, idle, etc.

**Tested with**: Niri, Hyprland, Sway, Scroll, Mango, Labwc, Triad, dwl.

Integration differs per compositor — check the docs for compositor-specific setup:
- **Hyprland**: `exec-once = noctalia` in autostart, remove omarchy-shell/Caelestia
- **Niri**: `spawn-at-startup "noctalia"` in config.kdl
- **Sway**: `exec noctalia` in sway config

## 10. Troubleshooting

### Common issues

1. **Bar not showing**: check `exclusive = true`, verify compositor supports layer-shell, check `noctalia ipc bar reload`
2. **Widgets not updating**: verify widget config syntax in TOML, check `noctalia ipc` output
3. **Theme not applying**: check `theming.source`, verify wallpaper path exists, try `noctalia ipc theme reload`
4. **Lock not working**: verify lock command exists (`which swaylock`), check idle_timeout setting
5. **Plugin not loading**: check `~/.local/share/noctalia/plugins/` permissions, verify plugin compatibility with v5
6. **Config merge conflicts**: GUI overrides in `settings.toml` always win — edit there or delete the override
7. **High CPU**: check widget `interval` settings, reduce update frequency
8. **Memory leak**: v5 is much better than v4 (~50 MB vs ~300 MB), but check `noctalia ipc` for stale state

### Debug workflow

```bash
# Check if noctalia is running
ps aux | grep noctalia

# View logs
journalctl --user -u noctalia -e

# IPC smoke test
noctalia ipc bar reload

# Verify config syntax
noctalia validate          # if available

# Check bar state
noctalia ipc bar status
```

### Nuclear reset
```bash
noctalia ipc bar reload
# or
systemctl --user restart noctalia
```

## 11. First-run setup

Noctalia includes a **setup wizard** for first-time users — guides through:
- Compositor selection/detection
- Bar layout and widget selection
- Theme and wallpaper setup
- Lock screen configuration
- Plugin installation

## 12. Safety rules

- **Back up config before major changes**: `cp -r ~/.config/noctalia ~/.config/noctalia.bak.$(date +%s)`
- **GUI overrides always win** — to override them, edit `~/.local/state/noctalia/settings.toml` or delete it
- **TOML syntax matters** — a typo silently ignores the whole section; validate after edits
- **v4 and v5 configs are separate** — they can coexist but don't cross-reference
- **Plugin compatibility** — v5 plugins are NOT v4 plugins; check docs before installing
