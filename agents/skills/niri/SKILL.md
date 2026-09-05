---
name: niri
description: >
  Expert knowledge for configuring and troubleshooting the Niri Wayland compositor.
  REQUIRED when editing anything under ~/.config/niri/ or diagnosing Niri behavior.
  Covers the KDL config format, scrollable-tiling model, window rules, workspace rules,
  input/binds, monitors/outputs, animations (spring + easing + custom GLSL shaders),
  layer rules, overview mode, gestures, IPC (niri msg), theming, Xwayland via
  xwayland-satellite, and the Rust/niri-ipc crate ecosystem. Triggers: niri, niri wm,
  niri config, config.kdl, niri msg, niri validate, scrollable tiling, KDL, niri-ipc,
  niri-session, xwayland-satellite, niri bindings, niri window rules, niri animations,
  niri springs, niri overview, niri layers, niri outputs, niri workspaces.
---

# Niri Skill

Expert agent for the **Niri Wayland compositor** — a scrollable-tiling compositor
written in Rust on Smithay. Grounded in the current stable release series
(**25.x / 26.x**, versioning: `year.month`).

## 0. Primary references

- **Wiki (authoritative)**: <https://niri-wm.github.io/niri/>
- **GitHub**: <https://github.com/niri-wm/niri> (~26K stars)
- **Getting Started**: <https://niri-wm.github.io/niri/Getting-Started.html>
- **Config Introduction**: <https://niri-wm.github.io/niri/Configuration%3A-Introduction.html>
- **Key Bindings**: <https://niri-wm.github.io/niri/Configuration%3A-Key-Bindings.html>
- **Window Rules**: <https://niri-wm.github.io/niri/Configuration%3A-Window-Rules.html>
- **Layer Rules**: <https://niri-wm.github.io/niri/Configuration%3A-Layer-Rules.html>
- **Layout**: <https://niri-wm.github.io/niri/Configuration%3A-Layout.html>
- **Animations**: <https://niri-wm.github.io/niri/Configuration%3A-Animations.html>
- **Input**: <https://niri-wm.github.io/niri/Configuration%3A-Input.html>
- **Outputs**: <https://niri-wm.github.io/niri/Configuration%3A-Outputs.html>
- **IPC**: <https://niri-wm.github.io/niri/IPC.html>
- **Workspaces**: <https://niri-wm.github.io/niri/Workspaces.html>
- **Floating Windows**: <https://niri-wm.github.io/niri/Floating-Windows.html>
- **Tabs**: <https://niri-wm.github.io/niri/Tabs.html>
- **Overview**: <https://niri-wm.github.io/niri/Overview.html>
- **Gestures**: <https://niri-wm.github.io/niri/Gestures.html>
- **Window Effects**: <https://niri-wm.github.io/niri/Window-Effects.html>
- **Xwayland**: <https://niri-wm.github.io/niri/Xwayland.html>
- **Nvidia**: <https://niri-wm.github.io/niri/Nvidia.html>
- **FAQ**: <https://niri-wm.github.io/niri/FAQ.html>
- **Application Issues**: <https://niri-wm.github.io/niri/Application-Issues.html>
- **ArchWiki**: <https://wiki.archlinux.org/title/Niri>
- **niri-ipc crate docs**: <https://niri-wm.github.io/niri/niri_ipc/>

## 1. Core philosophy & architecture

- **Scrollable-tiling**: windows are arranged in **columns on an infinite horizontal strip** per monitor. Opening a new window **never** resizes existing windows.
- Written in **Rust** on **Smithay** (not wlroots). Memory-safe, no plugins, no root required.
- Each monitor has its **own isolated window strip** — windows never overflow across monitors.
- Workspaces are **dynamic, vertical, per-monitor** — always one empty workspace below.
- No built-in bar, lock screen, launcher, or notification daemon — pairs with external tools (waybar, fuzzel, mako, swaylock, etc.) or a desktop shell (Noctalia, DankMaterialShell).
- X11 support via **xwayland-satellite** (integrated since 25.08).
- Idle: ~40-60 MB RAM.

## 2. Config format: KDL

**File**: `$XDG_CONFIG_HOME/niri/config.kdl` (`~/.config/niri/config.kdl`)

Config search order:
1. `--config` / `-c` CLI argument
2. `$NIRI_CONFIG` env var
3. `$XDG_CONFIG_HOME/niri/config.kdl`
4. `/etc/niri/config.kdl`

**KDL basics:**
- `//` line comments, `/-` block comments
- Nodes: `name { ... }` or `name "value" key=value;`
- Toggle options are flags: writing `on` enables, omitting disables
- `null` explicitly removes an env variable
- Raw strings for regex: `r#"^pattern$"#`

**Live reload**: most settings reload on file save. Invalid config preserves last working state.

**Includes** (since v25.11):
```kdl
include "theme.kdl"
include "other-config.kdl" optional=true
```
- Included files are also watched for live-reload
- Merge is per-property (most sections); `struts`, `preset-column-widths` are replaced entirely
- **Placement matters** — an include before your `layout {}` block is overridden by it. Place includes at end.

**Auto-creation**: if no config exists, niri creates `~/.config/niri/config.kdl` with the embedded default.

**Validation**: `niri validate` checks config outside a running session.

## 3. Config file model (full section map)

### `input {}`
```kdl
input {
    keyboard {
        xkb {
            layout "us"
            variant "altgr-intl"
            options "ctrl:nocaps"
        }
    }
    touchpad {
        tap
        natural-scroll
        // disabled-while-typing is on by default
    }
    mouse { }
    trackpoint { }
    // mod-key "Super"          // customize Mod key (since 25.05)
    focus-follows-mouse
    focus-follows-mouse-delay 250
    scroll-factor 3
}
```

Key settings: `focus-follows-mouse`, `focus-follows-mouse-delay`, `scroll-factor`, `accel-profile`, `natural-scroll`, `tap`, `tap-button-map` (`left`/`lmr`), `middle-emulation`, `disable-while-typing`, `accel-speed`, `tap-and-drag`, `drag-lock`.

### `binds {}`
**CRITICAL: No defaults are loaded automatically** — you must define ALL bindings. An empty `binds {}` or omitted section = zero keybindings.

```kdl
binds {
    Mod+T { spawn "alacritty"; }
    Mod+D { spawn "fuzzel"; }
    Mod+Q { close-window; }
    Mod+Shift+E { quit; }
    Mod+Left { focus-column-left; }
    Mod+Ctrl+Left { move-column-left; }
    Mod+U { focus-workspace-down; }
    Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
    Mod+1 { focus-workspace 1; }
    Mod+Shift+1 { move-column-to-workspace 1; }

    // spawn-sh for shell expansion (since 25.08)
    Mod+Print { spawn-sh "grim -g \"$(slurp)\" - | wl-copy"; }

    // Properties on binds:
    repeat=false
    cooldown-ms=500
    allow-when-locked=true
    allow-inhibiting=false
    hotkey-overlay-title="My Custom Bind"
}
```

**Modifiers**: `Ctrl`/`Control`, `Shift`, `Alt`, `Super`/`Win`, `ISO_Level3_Shift`/`Mod5` (AltGr), `ISO_Level5_Shift`, `Mod` (Super on TTY, Alt nested).

**Bind types**: keyboard, mouse click (`Mod+MouseLeft`), mouse scroll (`Mod+WheelScrollDown`), touchpad scroll (`Mod+TouchpadScrollDown`).

**Key actions** (non-exhaustive):
- Focus: `focus-column-left`, `focus-column-right`, `focus-window-up`, `focus-window-down`, `focus-workspace-up`, `focus-workspace-down`, `focus-floating`, `focus-tiling`, `focus-output-left`, `focus-output-right`
- Move: `move-column-left`, `move-column-right`, `move-window-up`, `move-window-down`, `move-column-to-workspace`, `move-column-to-output`
- Column: `consume-window-into-column`, `expel-window-from-column`, `toggle-column-tabbed-display`, `maximize-column`, `center-column`, `switch-preset-column-width`, `set-column-width`
- Window: `toggle-window-floating`, `toggle-window-rule-opacity`, `fullscreen-window`, `maximize-window`
- Actions: `close-window`, `quit`, `spawn`, `spawn-sh`, `screenshot`, `screenshot-screen`, `screenshot-window`, `overview`, `do-screen-transition`, `power-off-monitors`

### `layout {}`
```kdl
layout {
    gaps 16
    center-focused-column "never"  // "never" | "always" | "on-overflow"

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
    }
    default-column-width { proportion 0.5; }
    // default-column-width {}  // let window decide

    focus-ring {
        width 4
        active-color "#7fc8ff"
        inactive-color "#505050"
        // active-gradient from="#80c8ff" to="#c7ff7f" angle=45
    }
    border {
        off                    // or: on
        width 4
        active-color "#ffc87f"
        inactive-color "#505050"
        urgent-color "#9b0000"
    }
    shadow {
        // on
        softness 30
        spread 5
        offset x=0 y=5
        color "#0007"
    }
    struts {
        // left/right/top/bottom 64
    }
}
```

**Gradients**: CSS-like `linear-gradient(angle, from, to)` with color spaces `oklch`, `oklab`. Can be `relative-to="workspace-view"`.

**Color formats**: CSS named colors, hex (`#rgb`/`#rgba`/`#rrggbb`/`#rrggbbaa`), `rgb()`, `rgba()`, `hsl()`, gradients.

### `window-rule {}`
Processed in order (last match wins for same-level rules). Powerful per-window customization.

**Matchers**: `title` (regex), `app-id` (regex), `is-active`, `is-focused`, `is-active-in-column`, `is-floating`, `is-window-cast-target`, `is-urgent`, `at-startup`.
**Excluders**: `exclude-app-id`, `exclude-title`, `exclude-is-active`, etc.

```kdl
window-rule {
    // Opening rules (applied once at open)
    app-id "firefox"
    default-column-width { proportion 0.5; }
    open-on-output "DP-1"
    open-on-workspace "browser"
    open-maximized
    open-floating
    open-focused

    // Dynamic rules (re-evaluated)
    opacity 0.9
    geometry-corner-radius 12
    clip-to-geometry
    draw-border-with-background
    background-effect { blur; noise 0.02; saturation 1.5; }
    scroll-factor 2
    block-out-from "screencast"
    variable-refresh-rate
    default-column-display "tabbed"

    // Focus ring / border overrides
    focus-ring { active-color "#ff0000"; }
    border { on; active-color "#ff0000"; width 2; }
    shadow { on; softness 30; spread 5; color "#0007"; }
    tab-indicator { active-color "#7fc8ff"; }
}
```

**Full dynamic property list**: `opacity`, `block-out-from`, `variable-refresh-rate`, `default-column-display`, `default-floating-position`, `scroll-factor`, `draw-border-with-background`, `geometry-corner-radius`, `clip-to-geometry`, `tiled-state`, `background-effect` (blur/noise/saturation), `focus-ring`, `border`, `shadow`, `tab-indicator`, `on-xdg-activate`, `popups`, `min-width`, `max-width`, `min-height`, `max-height`.

### `layer-rule {}`
For layer-shell surfaces (bars, overlays, notifications):
```kdl
layer-rule {
    namespace "waybar"
    // Similar matchers/excluders as window rules
}
```

### `output "name" {}`
Per-monitor config. Use `niri msg outputs` to find names.
```kdl
output "HDMI-A-1" {
    mode "2560x1440@60.000"
    scale 1.2
    transform "normal"
    position x=1920 y=0
}
output "eDP-1" { off; }
```

### `workspace "name" {}`
Named (persistent) workspaces:
```kdl
workspace "browser"
workspace "chat" { open-on-output "DP-1"; }
```

### `animations {}`
Two types: **easing** (duration + curve) and **spring** (physics model). Custom GLSL shaders supported for window-open/close/resize.

```kdl
animations {
    // off           // disable all
    // slowdown 3.0  // slow down all by factor

    workspace-switch { spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001; }
    window-open { duration-ms 150; curve "ease-out-expo"; }
    window-close { duration-ms 150; curve "ease-out-quad"; }
    horizontal-view-movement { spring ...; }
    window-movement { spring ...; }
    window-resize { spring ...; }
    overview-open-close { spring ...; }
    screenshot-ui-open { duration-ms 200; curve "ease-out-quad"; }
}
```

**Easing curves**: `ease-out-quad`, `ease-out-cubic`, `ease-out-expo`, `linear`, `cubic-bezier` (custom 4 params).

**Spring params**: `damping-ratio` (0.1–10.0, below 1 = oscillating, 1 = critically damped), `stiffness`, `epsilon`.

**Custom GLSL shaders**: for `window-open`, `window-close`, `window-resize` — uniforms include `niri_clamped_progress`, `niri_tex_curr`, `niri_tex_next`.

### `gestures {}`
Touchpad gestures, hot corners, DnD edge scrolling.

### `overview {}`
Overview/expose mode (since 25.05):
```kdl
overview {
    zoom 0.5
    backdrop-color "#262626"
    workspace-shadow { ... }
}
```

### `recent-windows {}`
Alt-Tab style window switcher.

### Top-level options
```kdl
spawn-at-startup "waybar"
spawn-at-startup "mako"
spawn-sh-at-startup "swayidle -w timeout 601 niri msg action power-off-monitors"
prefer-no-csd
screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

environment {
    QT_QPA_PLATFORM "wayland;xcb"
    DISPLAY null
    ELECTRON_OZONE_PLATFORM_HINT "auto"
}

cursor {
    xcursor-theme "breeze_cursors"
    xcursor-size 48
    hide-when-typing
    hide-after-inactive-ms 1000
}

blur { passes 3; offset 3.0; noise 0.02; saturation 1.5; }

xwayland-satellite { path "xwayland-satellite"; }

clipboard { disable-primary; }

hotkey-overlay { skip-at-startup; hide-not-bound; }
config-notification { disable-failed; }
```

### `switch-events {}`
Hardware switches (laptop lid, tablet mode).

### `debug {}`
Rendering damage visualization, DRM features.

## 4. CLI tools

### `niri` (main binary)
```bash
niri                          # start compositor on TTY
niri --session                # start as session (imports env to systemd/D-Bus)
niri -c /path/to/config.kdl   # alternate config
niri validate                 # check config for errors
niri completions bash|zsh|fish|nushell
```

### `niri msg` (IPC client)
**Queries:**
```bash
niri msg outputs              # list connected outputs
niri msg workspaces           # list workspaces
niri msg windows              # list open windows
niri msg layers               # list layer-shell surfaces
niri msg keyboard-layouts     # configured layouts
niri msg focused-output       # focused output info
niri msg focused-window       # focused window info
niri msg overview-state       # overview open/closed
niri msg casts                # active screencasts
niri msg version              # running niri version
niri msg pick-window          # click a window to get info
niri msg pick-color           # click to pick screen color
```

**Actions:**
```bash
niri msg action focus-workspace 3
niri msg action close-window --id 12345
niri msg action toggle-window-floating
niri msg action screenshot
niri msg action load-config-file
niri msg action power-off-monitors
niri msg action quit
niri msg action consume-window-into-column
niri msg action expel-window-from-column
niri msg action maximize-column
niri msg action center-column
niri msg action overview
niri msg output HDMI-A-1 position set 1920 0
niri msg output HDMI-A-1 vrr on
```

**Event stream:**
```bash
niri msg event-stream              # human-readable events
niri msg --json event-stream       # JSON events for scripting
```

**Flags**: `--json` for machine-readable output everywhere.

## 5. IPC (niri-ipc)

- **Socket**: `$NIRI_SOCKET` (e.g. `/run/user/1000/niri.wayland-1.2474.sock`)
- **Protocol**: JSON on a single line per request/reply
- **Flow**: connect → write JSON request + newline → read JSON reply + newline
- **Types**: `Request` (query/action), `Reply` (Ok/Err), `Response`, `Event`
- **Event stream**: `Request::EventStream` transitions to push-based model; sends full state first, then incremental updates
- **Stability**: JSON field names and enum variants are stable across versions
- **Rust crate**: `niri-ipc` on crates.io; also `wayle-niri` for reactive wrappers
- **Testing**: `socat` for manual socket debugging

## 6. Theming

Niri has no variable system — theming is done via:

1. **Direct KDL config** — colors in `focus-ring`, `border`, `shadow`, `tab-indicator`, `overview`, `blur`
2. **Include-based theming** (since v25.11) — `include "theme.kdl"` files; watched for live-reload
3. **Window effects** — `geometry-corner-radius`, `clip-to-geometry`, `background-effect`, `opacity`
4. **Custom GLSL shaders** for animations
5. **Third-party**: [Black Atom Industries](https://github.com/black-atom-industries/niri), [Tinct](https://jmylchreest.github.io/tinct/)

**Theme switch workflow**: update `theme.kdl` → niri watches and live-reloads → optionally fire `do-screen-transition` for smooth visual change.

## 7. Companion tools

| Purpose | Tool | Notes |
|---------|------|-------|
| Bar | waybar, ironbar | waybar has native niri support from 0.10+ |
| Launcher | fuzzel, walker, tofi | fuzzel is the niri default |
| Notifications | mako, swaync | |
| Lock screen | swaylock, hyprlock | |
| Idle | swayidle | |
| Wallpaper | swaybg | |
| Full shell | Noctalia, DankMaterialShell | Quickshell/C++ based complete shells |
| Xwayland | xwayland-satellite | integrated since 25.08, auto-starts on X11 client |

## 8. Troubleshooting workflow

```bash
niri validate                           # check config before starting
niri msg --json version                 # verify running version
niri msg outputs                        # check output names
niri msg windows                        # list all windows
niri msg --json event-stream | head -5  # verify IPC is working
```

### Common gotchas

1. **`binds {}` has no defaults** — omitting it = zero keybindings. Always start from the default config's binds.
2. **`spawn` doesn't use shell** — arguments must be individually quoted. Use `spawn-sh` (since 25.08) or `spawn "sh" "-c" "..."`.
3. **`environment {}` only affects niri-spawned processes** — for systemd user services use `~/.config/environment.d/*.conf` or UWSM.
4. **`prefer-no-csd` requires app restart** to fully apply.
5. **Invalid config won't crash niri** — last working state is preserved; notification shown.
6. **Include placement matters** — `layout {}` after an include overrides included `layout {}` content. Place includes at end.
7. **Nvidia**: requires drivers 335+ with GBM. Enable `nvidia-drm.modeset=1`. Known high VRAM issue documented on wiki.
8. **Waybar + rounded corners**: GTK3 bug surfaces opaque flag → black pixels. Fix: waybar opacity `0.99`.
9. **Xwayland**: requires `xwayland-satellite` installed. Set `ELECTRON_OZONE_PLATFORM_HINT "auto"` for Electron. Java: `_JAVA_AWT_WM_NONREPARENTING=1`.
10. **Multi-monitor**: configure positions explicitly — niri can't detect physical layout. Use `niri msg outputs` for names.
11. **Session startup**: on TTY use `niri --session` (or `niri-session` via systemd/dinit) to properly set up D-Bus and systemd user services.
12. **WezTerm**: known bug — waits for zero-sized configure event. Workaround: window rule in default config. Another bug: wrong size in tiled state → comment out `prefer-no-csd`.
13. **Options from newer versions** won't appear in old configs — check wiki for what's new.

### Live debugging
```bash
niri msg --json event-stream           # watch events in real-time
niri msg --json windows                # full window state
niri msg --json workspaces             # full workspace state
journalctl --user -u niri -e           # systemd logs
```

## 9. Nvidia specifics

- Requires drivers with GBM support (335+)
- Enable modeset: `nvidia-drm.modeset=1` (kernel param)
- Known high VRAM usage — manual fix documented on wiki
- See: <https://niri-wm.github.io/niri/Nvidia.html>

## 10. Safety rules

- **Never delete config without backup**: `cp ~/.config/niri/config.kdl ~/.config/niri/config.kdl.bak.$(date +%s)`
- `niri validate` before restarting the session
- Config live-reloads on save — no need to restart for most changes
- Invalid config preserves last working state (won't crash), but verify with `niri validate`
- For major changes, test with `niri -c /tmp/test-config.kdl` first
