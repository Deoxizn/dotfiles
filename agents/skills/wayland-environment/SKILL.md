---
name: wayland-environment
description: >
  Expert knowledge for the Wayland desktop environment layer on Arch Linux —
  XDG Desktop Portals (xdg-desktop-portal + backends), XDG Runtime dir/session
  environment, session management (graphical-session.target, environment.d),
  common Wayland protocols and conventions, and per-app Wayland enablement
  (env vars, socket modules). REQUIRED when diagnosing portal failures
  (screenshare, file pickers, global shortcuts), Wayland clipboard/DRAG&drop
  issues, Gtk/Electron/Qt Wayland quirks, XDG autostart, or environment
  variables for Wayland apps, complementary to the niri and systemd skills.
  Triggers: xdg-desktop-portal, xdg-desktop-portal-wlr/hyprland/gnome, portals,
  XDG_RUNTIME_DIR, WAYLAND_DISPLAY, XDG_SESSION_TYPE, environment.d,
  graphical-session, screenshare, pipewire portal, global shortcut portal,
  file picker portal, GTK Wayland, Electron Wayland, Qt Wayland, ozone,
  QT_QPA_PLATFORM, GDK_BACKEND, XDG_CURRENT_DESKTOP, XDG_SESSION_DESKTOP,
  xdg-desktop-portal-gtk, screenshot portal, remote desktop portal.
---

# Wayland Environment Skill

Expert agent for the **Wayland desktop environment layer** on this Arch + niri
machine. niri is the compositor and **noctalia** the shell; the "desktop
environment plumbing" between user apps and compositor is handled by the
XDG runtime, session environment, and **XDG Desktop Portals**. This skill is
the companion to the `niri`, `noctalia`, `sddm`, `systemd`, and `arch` skills.

## 0. Primary references

- **Arch Wiki — Wayland**: <https://wiki.archlinux.org/title/Wayland>
- **Arch Wiki — XDG Desktop Portal**: <https://wiki.archlinux.org/title/XDG_Desktop_Portal>
- **Arch Wiki — Environment variables**: <https://wiki.archlinux.org/title/Environment_variables>
- **Arch Wiki — Xwayland**: <https://wiki.archlinux.org/title/Xwayland>
- **wayland-protocols (green Steele)**: <https://gitlab.freedesktop.org/wayland/wayland-protocols>
- **XDG Base Directory spec**: <https://specifications.freedesktop.org/basedir-spec/latest/>
- **xdg-desktop-portal docs**: <https://flatpak.github.io/xdg-desktop-portal/>
- **freedesktop portals protocol (D-Bus)**: <https://flatpak.github.io/xdg-desktop-portal/portal-docs.html>
- See also the **niri** skill for compositor specifics and **systemd** skill
  for user-session wiring.

## 1. Core Wayland environment concepts

### Session variables
Set by the login/session manager (SDDM → niri-session):
- `WAYLAND_DISPLAY=wayland-1` — the Wayland socket in `$XDG_RUNTIME_DIR`.
- `XDG_RUNTIME_DIR=/run/user/<uid>` — the per-user runtime dir (must be
  owned by the user, mode 0700; systemd creates/sets it). Many Wayland apps
  hard-fail without it.
- `XDG_SESSION_TYPE=wayland`, `XDG_SESSION_DESKTOP=niri`,
  `XDG_CURRENT_DESKTOP=niri` — desktop hints for portal selection & app behavior.
- `DISPLAY` — empty/absent when not using Xwayland; niri starts
  `xwayland-satellite` on demand (see niri skill).

### XDG Base Directory spec
- `XDG_CONFIG_HOME` (`~/.config`), `XDG_DATA_HOME` (`~/.local/share`),
  `XDG_STATE_HOME` (`~/.local/state`),
  `XDG_CACHE_HOME` (`~/.cache`), `XDG_DESKTOP_DIR`, `XDG_DOCUMENTS_DIR`, etc.
- These matter for where shells (noctalia config in `~/.config/noctalia/`,
  state in `~/.local/state/noctalia/`) and apps store things. The niri/noctalia
  skills reference them directly.

## 2. XDG Desktop Portals (the modern API)

### What portals are
Portals let sandboxed or Wayland apps request privileged/desktop-wide services
over D-Bus: file open/save dialogs, screensharing, global shortcuts, screenshot
capture, color picker, wallpaper setting, printing, network location, power
profile, etc. The **portal service** (`xdg-desktop-portal`) dispatches to a
**backend** for the specific desktop environment:

| Portal backend | Used by |
|---|---|
| `xdg-desktop-portal-gtk` | GTK apps / minimal DEs |
| `xdg-desktop-portal-hyprland` | Hyprland |
| `xdg-desktop-portal-wlr` | wlroots compositors (sway, Hyprland pre-2024) |
| `xdg-desktop-portal-gnome` | GNOME |
| `xdg-desktop-portal-kde` | KDE (incl. org.kde.Kglobalaccel for global shortcuts) |
| `xdg-desktop-portal-lxqt`, etc. | |

**On niri** you typically run `xdg-desktop-portal-gtk` as the backend; niri
itself provides no portal backend (it's not required). Some DE backends must be
set as the default via an env var.

### Installation & service (Arch)
```bash
sudo pacman -S xdg-desktop-portal xdg-desktop-portal-gtk
# user service (run as your user session service):
systemctl --user enable --now xdg-desktop-portal xdg-desktop-portal-gtk
# or just let the session start it (graphical-session.target Wants)
```

### Key backends for niri
- **File dialogs**: the Gtk backend provides `org.freedesktop.portal.FileChooser`.
- **Screen capture / screenshare**: apps request a PipeWire `ScreenCast` via
  `org.freedesktop.portal.ScreenCast`; the portal grants the stream. On niri,
  the compositor exposes capture to e.g. `grim`/`wf-recorder` (native pipewire,
  often no portal needed for simple CLI), but **browser screenshare** (Meet,
  Discord, etc.) uses the portal + PipeWire. If screenshare fails, the portal
  backend or pipewire node is the usual culprit.
- **Global shortcuts**: `org.freedesktop.portal.GlobalShortcuts` lets apps bind
  global keys (this is also what Quickshell's `GlobalShortcut` uses). The
  `kde` backend implements it most fully; on niri you may need
  `XDG_CURRENT_DESKTOP=...` to select the right backend, or fall back to
  capturing via niri binds (see niri skill).

### Troubleshooting portals
```bash
# is the portal service running?
systemctl --user status xdg-desktop-portal xdg-desktop-portal-gtk
# logs
journalctl --user -u xdg-desktop-portal -e --no-pager
journalctl --user -u xdg-desktop-portal-gtk -e --no-pager
# which backend is being selected? check `dbus-monitor` on the D-Bus session,
# or run the portal daemons with verbose logging.

# environment hint (niri): set these in ~/.config/environment.d/*.conf
# XDG_CURRENT_DESKTOP=niri
# (portal backends read this to pick behavior)
```
- **Portal started at wrong time**: the portal must start after the session
  bus is up. Ensure it's WantedBy=`graphical-session.target` (user unit) and
  that `XDG_SESSION_TYPE=wayland` is set — a common cause of no-screenshare is
  the portal thinking it's an X11 session.
- **Multiple backends conflict**: two backends claiming the same portal
  (e.g. both `gtk` and `hyprland` installed) → only one should be enabled.
  Mask the unused one: `systemctl --user mask xdg-desktop-portal-hyprland`.

## 3. Per-app Wayland enablement (env vars)

Arch Wiki table: <https://wiki.archlinux.org/title/Wayland#GUI_libraries>.
Common env for Wayland sessions (put in `~/.config/environment.d/*.conf`):

```ini
# GTK
# (default; GDK_BACKEND=wayland only forces it)
# GDK_BACKEND=wayland,x11

# Qt
QT_QPA_PLATFORM=wayland;xcb
QT_WAYLAND_DISABLE_WINDOWDECORATION=1

# Electron / Chromium
ELECTRON_OZONE_PLATFORM_HINT=auto
# CHROME_OZONE_PLATFORM_HINT=auto  (older name)

# Java/AWT (Xwayland needs non-reparenting)
_JAVA_AWT_WM_NONREPARENTING=1

# nvidia/libva
LIBVA_DRIVER_NAME=nvidia
__GLX_VENDOR_LIBRARY_NAME=nvidia
WLR_NO_HARDWARE_CURSORS=1          # only if cursors glitch on wlroots

# misc
MOZ_ENABLE_WAYLAND=1               # Firefox
OBS_USE_EGL=1
```

- Environment set via `environment.d` applies to the user systemd manager →
  inherited by graphical session and user services. It does NOT apply to apps
  you launch from SSH or a bare TTY (use the session-level approach for those).
- niri sets `ELECTRON_OZONE_PLATFORM_HINT auto` in its default config; see the
  niri skill.

## 4. Screenshot / screen capture (Wayland)

- **Shortcuts** on niri: `niri msg action screenshot` (full output) or use
  `grim` + `slurp` via `spawn-sh`. See niri skill §Binds (`screenshot`,
  `screenshot-screen`, `screenshot-window`).
- **Portal-based capture**: `grim -g "$(slurp)"` works directly; recording via
  `wf-recorder` also direct. Browsers use the portal (`ScreenCast`); that path
  fails when the portal backend isn't configured — see §2.

## 5. Clipboard (Wayland)

- `wl-clipboard` (`wl-copy`, `wl-paste`) is the standard clip util.
- Noctalia provides a clipboard manager section in its config if enabled.
- **Clipboard across apps/sessions**: wl-clipboard on Wayland uses the
  `wlr-data-control` protocol (or the compositor's implementation). If pasting
  between a Qt app and browser fails, the compositor or a `wl-paste -w`/`wl-paste
  --watch` daemon may be the issue. niri supports `clipboard disable-primary`
  (see niri skill §Top-level options).

## 6. Wayland protocols quick map

| Protocol | Meaning | Typical need |
|---|---|---|
| `wl_surface`/`wl_shell` (legacy) | base window | all apps |
| `xdg-shell` | modern toplevels (titles, rules) | most GUIs |
| `wlr-layer-shell` | bars/overlays/launchers | noctalia, waybar |
| `wlr-foreign-toplevel` | window management clients | taskbars, scripting |
| `ext-workspace-v1` | workspace info | noctalia workspaces widget |
| `zwlr_screencopy_v1` | screenshots/recording | grim, wf-recorder |
| `zwp_pointer_constraints` | pointer lock | games, remote desktop |
| `wp_presentation` | vsync timing | compositors |
| `zt_global_shortcuts` / InterpolatedShortcuts | global keys | shell shortcuts |
| `ghost_XDragon` (not standard) | drag&drop | unusual case |
| `wayland-drm` | buffers for NVIDIA | older wlroots |

Noctalia/niri require `ext-workspace-v1` for the workspace widget — verify your
compositor implements it (niri does).

## 7. Xwayland on niri

- niri uses **xwayland-satellite** (integrated since 25.08). X11 apps appear as
  regular windows; set `DISPLAY` automatically.
- See the niri skill §Xwayland or <https://niri-wm.github.io/niri/Xwayland.html>.
- Portal `ScreenCast` on X11 windows: some apps must run native Wayland to
  benefit from KMS screen capture; otherwise captures go through the Xwayland
  path only if the tool supports it.

## 8. Session autostart (XDG autostart / graphical-session)

Ways apps start with the desktop:
- **`~/.config/systemd/user/*.service`** (preferred on niri; see systemd skill):
  `WantedBy=graphical-session.target`, `PartOf=graphical-session.target`.
- **`~/.config/autostart/*.desktop`** (XDG autostart) — works via a handler
  like `dex`/`bypass-launch` or in the shell; noctalia does NOT run these
  automatically — niri spawns via `spawn-at-startup` in config.kdl.
- **niri `spawn-at-startup` / `spawn-sh-at-startup`** — the standard niri way.
- Service ordering: put session-critical user services (wireplumber, portal,
  noctalia) WantedBy/After `graphical-session.target`.

## 9. Troubleshooting workflow

```bash
# 1. Session env sanity (does the desktop know it's Wayland?)
echo $XDG_SESSION_TYPE $XDG_SESSION_DESKTOP $XDG_CURRENT_DESKTOP $WAYLAND_DISPLAY
# 2. Runtime dir
ls -ld "$XDG_RUNTIME_DIR"; ls "$XDG_RUNTIME_DIR" | grep wayland
# 3. Portal running?
systemctl --user status xdg-desktop-portal xdg-desktop-portal-gtk
# 4. Portals seen by an app?
dbus-send --session --dest=org.freedesktop.DBus \
  --print-reply /org/freedesktop/DBus \
  org.freedesktop.DBus.ListNames | grep -i portal
# 5. Wayland socket/protocol issue in an app?
wayland-info            # protocol list + globals
# 6. XDG autostart/services not starting at login?
journalctl --user -b | grep -i portal
```

### Common failure classes
- **No file picker / app "can't open files"** → portal backend missing or
  wrong; ensure `xdg-desktop-portal-gtk` enabled.
- **Browser screenshare black / no share** → portal ScreenCast backend;
  check `journalctl --user -u xdg-desktop-portal*`; check pipewire running
  (`systemctl --user status pipewire wireplumber`).
- **Global shortcuts don't fire in apps (Discord PTT, etc.)** → portal
  GlobalShortcuts backend; on niri bind in niri config instead.
- **App launches but is not Wayland** → it fell back to Xwayland; set its env
  var (`ELECTRON_OZONE_PLATFORM_HINT=auto`, `MOZ_ENABLE_WAYLAND=1`, ...) and
  restart the app.
- **Screenshot gives black/empty on NVIDIA** → use portal/`grim` KMS path;
  check `nvidia-drm.modeset=1` and `GAMING`.
- **Portal service race**: make sure `graphical-session.target` ordering is
  sane (portal After=session), else the first app requesting a portal may hang.

## 10. Safety rules

- **Never start the portal as root.** User services under `--user` only.
- Don't install two conflicting backends (hyprland + gtk) without masking one.
- Prefer user-scoped `environment.d` for env vars; avoid polluting `/etc/environment`.
- Test env-var changes by relaunching the app, not by assuming reload.
- Read <https://wiki.archlinux.org/title/XDG_Desktop_Portal> before reconfiguring.

## Example requests

- "Screenshare in browser shows nothing" → portal ScreenCast backend + pipewire checks above.
- "No file-picker when app opens a file" → ensure `xdg-desktop-portal-gtk` user service.
- "Discord PTT doesn't work globally" → GlobalShortcuts portal; else niri bind.
- "Why is Firefox running X11?" → `MOZ_ENABLE_WAYLAND=1` via environment.d.
- "App can't write config anywhere" → XDG dirs misconfigured; verify `echo $XDG_CONFIG_HOME`.
- "Portal service fails to start" → check ordering + session env; logs in `journalctl --user`.