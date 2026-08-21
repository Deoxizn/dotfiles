---
name: quickshell
description: >
  Expert knowledge for Quickshell (Qt6/QML desktop shell toolkit, v0.3.0 on
  this machine). Use when creating or debugging ANY Quickshell-based shell or
  widget — shell.qml entry points, PanelWindow/PopupWindow/FloatingWindow,
  singletons and qs.* root-relative imports, IpcHandler + `qs ipc`,
  CustomShortcut global shortcuts, WlSessionLock lockscreens, FileView/JsonAdapter
  persistence, Process/Socket IO, Wayland layer surfaces, ScreencopyView,
  Hyprland/Mpris/Pipewire/SystemTray/Notifications/PAM service modules, C++
  QML plugins, hot reload, logging, and crash handling. Triggers: quickshell,
  qs, shell.qml, QML shell, PanelWindow, layer shell, WlSessionLock, qs ipc,
  IpcHandler, CustomShortcut, FileView, JsonAdapter, qmlls, QML plugin.
---

# Quickshell Skill

Quickshell is a Qt6/QML toolkit for building custom desktop shells (bars,
launchers, lock screens) on Wayland. This machine runs **Quickshell 0.3.0**
(Arch package `quickshell 0.3.0-3`, binary `/usr/bin/qs`). Real-world reference
implementation installed here: **Caelestia** at `~/.config/quickshell/caelestia/`
(see the `caelestia` skill for its config system).

## 0. Authoritative references

- Docs (versioned): <https://quickshell.org/docs/v0.3.0/guide/> — types index: <https://quickshell.org/docs/v0.3.0/types>
- Changelog (feature gates like `qs.*` imports): <https://quickshell.org/changelog/>
- Source: <https://git.outfoxxed.me/quickshell/quickshell> (GitHub mirror: quickshell-mirror/quickshell)
- Example configs: <https://git.outfoxxed.me/outfoxxed/quickshell-examples>
- Local living example: `~/.config/quickshell/caelestia/` — grep it before inventing API usage.

## 1. Config discovery & running

- A config = a directory with `shell.qml`. Named configs live at
  `~/.config/quickshell/<name>/shell.qml`; run with `qs -c <name>`.
  `~/.config/quickshell/shell.qml` (if present) is the "default" config (`qs` alone).
- `-p /path/to/dir-or-file` runs any path directly (mutually exclusive with `-c`).
- Key flags: `-d` daemonize, `-n` no-duplicate (exit if instance already running),
  `-v/-vv` verbosity, `--log-rules` (QT_LOGGING_RULES syntax), `--debug PORT[:PORT]`
  (+ `--waitfordebug`) for QML debugger.
- Subcommands: `log`, `list [--all]`, `kill`, `ipc` (msg is deprecated alias).
- Instances are matched per config path + display; `qs list --all` shows PID,
  config path, WAYLAND_DISPLAY, launch time.

## 2. Language & project layout

- Entry `shell.qml` declares a `ShellRoot { }` holding top-level objects:
  windows, services, scopes.
- **Root-relative imports** (0.2+): `import qs.services` maps to
  `<configroot>/services`, `qs.components.controls` → `<configroot>/components/controls`.
  Sibling files need no import; subdirs use relative paths.
- Singletons: file starts with `pragma Singleton` + registered in that dir's
  `qmldir` (`singleton Name Name.qml`) OR wrapped in `Singleton { }` from
  `Quickshell`. One instance per engine; ideal for state/services
  (see caelestia `services/*.qml`).
- LSP: create `.qmlls.ini` in the shell root (quickshell populates it with import
  paths so qmlls works without `-E`). Gitignore it.
- Hot reload: files are watched by default; save → affected components reload.
  Disable with env `QS_DISABLE_FILE_WATCHER=1`. Per-config settings via
  `settings.watchFiles: true` etc. in shell.qml (QuickshellSettings).

## 3. Core types cheat sheet

Windows & layout:
- `PanelWindow` — layer-shell panel: `anchors` (top/left/right/bottom), `exclusiveZone`
  (or `ExclusionMode.Auto/Ignore`), `margins`, `screen` (ShellScreen), `WlrLayershell.layer`.
- `PopupWindow` — anchored popup (`anchor.item/anchor.edges/adjustment`), for menus/popouts.
- `FloatingWindow` — regular toplevel window.
- `Variants { model: Quickshell.screens; PanelWindow { required property ShellScreen modelData … } }`
  — the standard per-screen pattern.
- `ShellScreen` — a monitor (`name`, width/height); `Quickshell.screens` lists all.
- `Scope`, `LazyLoader`, `ScriptModel`, `ObjectModel`, `BoundComponent`,
  `PersistentProperties` (persist state across reloads), `Retainable`,
  `SystemClock`, `EasingCurve`, `Region` (input/clip regions), `ColorQuantizer`.

Wayland (`Quickshell.Wayland`):
- `WlSessionLock` (`locked: bool`, `unlock()` signal) + `WlSessionLockSurface`
  (one auto-created per screen; content covers output while locked). Lock pattern:
  ```qml
  WlSessionLock {
      id: lock
      LockSurface { lock: lock }   // per-screen surface
  }
  // lock.locked = true to engage
  ```
- `ScreencopyView { captureSource: screen }` — live view of an output (used for
  blurred lock backgrounds). NOTE: first capture can fail if the lock is the first
  request — warm it up earlier (caelestia Lock.qml does this).
- `IdleMonitor`, `IdleInhibitor`, `ShortcutInhibitor`, `ToplevelManager`/`Toplevel`,
  `WlrKeyboardFocus`, `BackgroundEffect`.

IO & system (`Quickshell.Io`):
- `Process { command: [...]; stdout: SplitParser { onRead: d => … }; onExited: … }`;
  `StdioCollector` for full-output capture.
- `FileView { path; watchChanges; blockLoading }` + adapters: `JsonAdapter`
  (typed JSON persistence with auto-save), `JsonObject`. The canonical
  config/state pattern (caelestia's whole config system builds on this).
- `IpcHandler` — expose functions to `qs ipc call`:
  ```qml
  IpcHandler {
      target: "lock"
      function lock(): void { … }
      function isLocked(): bool { return lock.locked }
  }
  ```
  Call: `qs -c <name> ipc call <target> <function> [args…]`. Errors come back as
  stdout strings ("Target not found.", "Function not found.", "Too few arguments…")
  often WITH exit 0 — check output text when scripting.
- `Socket`/`SocketServer`, `DataStream`/`SplitParser`.

Desktop services:
- `Quickshell.Services.Mpris` (`Mpris.players`), `.Pipewire` (nodes/links/peaks),
  `.SystemTray` (`SystemTray.items`, icons/menus via `QsMenuAnchor`/`QsMenuOpener`),
  `.Notifications` (`NotificationServer` — you implement the daemon),
  `.UPower`, `.Bluetooth`, `.Networking` (NetworkManager), `.Polkit` (PolkitAgent),
  `.Greetd`, `Quickshell.DBusMenu`.
- `Quickshell.Services.Pam` — `PamContext { configDirectory }` for lockscreen auth;
  custom PAM service files can ship in config assets (caelestia: `assets/pam.d/{passwd,fprint,howdy}`).
- `Quickshell.Hyprland` — `Hyprland.event(s)` socket events, `Hyprland.monitorFor()`,
  `HyprlandWorkspace/Toplevel/Window`, `GlobalShortcut` (portal-based; pairs with
  Hyprland binds: `hl.dsp.global("caelestia:lock")` style), `HyprlandFocusGrab`.
- `Quickshell.Widgets` — IconImage, ClippingRectangle, Wrapper* helpers.
- `DesktopEntries` — freedesktop app lookup (launchers).

## 4. Pragmas & environment (shell.qml header comments)

- `//@ pragma Env VAR=VAL` / `//@ pragma DefaultEnv VAR=VAL` — set/fallback env for
  the shell process only (not spawned children).
- `//@ pragma UseQApplication` — needed for QtWidgets-based controls.
- `//@ pragma DropExpensiveFonts`, `IconTheme <t>`, `AppId <id>`, `ShellId <id>`,
  `DataDir/StateDir/CacheDir <dir>` ($BASE supported).
- `//@ if <js condition> … //@ endif` — preprocessor blocks (`hasVersion()`, `env()`).
- Env vars: `QS_NO_RELOAD_POPUP=1`, `QS_DISABLE_FILE_WATCHER`, `QS_CRASHREPORT_URL`
  (redirect crash reports, e.g. to your repo's issue template),
  `QS_DISABLE_CRASH_HANDLER`, `QS_CONFIG_PATH`, `QS_DROP_EXPENSIVE_FONTS`.
- Crash handler auto-relaunches crashed shells and writes reports — useful for
  flaky QML; disable deliberately in embedded/kiosk setups.

## 5. State & XDG dirs

- `Quickshell.stateDir/dataDir/cacheDir` — per-shell-id dirs under XDG state/data/cache.
- Caelestia convention worth copying: user config in `~/.config/<project>/`,
  runtime state in `~/.local/state/<project>/` (scheme.json, sqlite, symlinks).

## 6. C++ plugins (native QML modules)

- Pattern (as used by caelestia `plugin/`): cmake project → `qt_add_qml_module`
  per module URI (e.g. `Caelestia.Config`), C++ types exposed via
  `QML_ELEMENT`/`QML_SINGLETON` + properties/signals; build emits
  `build/qml/<URI>/qmldir` + `.qmltypes` + plugin .so.
- Import resolution: put modules on `QML2_IMPORT_PATH`, or keep them in a
  config-local `build/qml` dir (observed working on this machine — caelestia's
  running instance imports `Caelestia.Config` from there with no env vars set).
- Regenerating `.qmltypes` keeps qmlls completion working for native types.
- For typed config systems, study `plugin/src/Caelestia/Config/configobject.hpp`
  (`CONFIG_PROPERTY` vs `CONFIG_GLOBAL_PROPERTY`) and `configattached.cpp`
  (attached-property propagation with `QQuickAttachedPropertyPropagator` — the
  clean way to do per-screen config overlays).

## 7. Debugging workflow

```bash
qs list --all                     # what's running, which config/path
qs -c <name> log                  # follow logs (also: journalctl --user -u <unit> -e)
qs -c <name> ipc call <t> <f>     # smoke-test IPC handlers
QS_LOGGING_RULES="*.debug=true" qs -c <name>   # verbose categories (--log-rules too)
```

- QML errors on load: shown in log with component stack; hot reload keeps last
  good state until fixed (file watcher reloads on save).
- Non-deterministic breakage after edits: restart instance (`systemctl --user
  restart <unit>` or `qs kill` + relaunch) — some singletons/timers survive hot
  reload in odd states.
- QML debugger: launch with `--debug 1234` (+ `--waitfordebug`), attach from
  Qt Creator / qmlls tooling.
- Performance: prefer `LazyLoader` for heavy popups, avoid per-frame JS in
  bindings, use `DropExpensiveFonts`, watch memory (a full shell can balloon —
  caelestia idles ~hundreds of MB; leaks show as steady growth).

## 8. Minimal examples

Bar window on every screen:

```qml
//@ pragma UseQApplication
import QtQuick
import Quickshell

ShellRoot {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            required property ShellScreen modelData
            screen: modelData
            anchors { top: true; left: true; right: true }
            implicitHeight: 40
            color: "#20202a"
            Text { anchors.centerIn: parent; text: modelData.name }
        }
    }
}
```

Persistent JSON state:

```qml
import Quickshell.Io

FileView {
    id: store
    path: Quickshell.stateDir + "/settings.json"
    watchChanges: true
    JsonAdapter { id: state; property int count: 0 }
}
// read/write: state.count = state.count + 1  (auto-saves)
```

IPC + global shortcut pair:

```qml
CustomShortcut { name: "ping"; description: "Ping"; onPressed: doThing() }  // bind: hl.dsp.global("myshell:ping")
IpcHandler    { target: "ctl"; function ping(): void { doThing() } }        // qs -c myshell ipc call ctl ping
```

## 9. Gotchas learned the hard way (on this machine)

- `qs ipc` matches instances by config path AND display; callers without
  WAYLAND_DISPLAY (SSH/TTY/systemd units) must recover it from
  `$XDG_RUNTIME_DIR/wayland-*` (omarchy-shell does exactly this).
- IPC failures may exit 0 — parse the stdout strings, not just exit codes.
- `pragma ComponentBehavior: Bound` (modern QML) changes ID resolution in
  delegates — caelestia uses it everywhere; expect `required property` patterns.
- Attached-property propagation only flows parent→child AFTER initialization
  ordering is right; setting `contentItem.Config.screen` style props must happen
  before children resolve config values (see caelestia LockSurface.qml).
- Session locks cover ALL outputs unconditionally — per-screen behavior inside
  the lock must be done via per-screen surface config, not by excluding screens.
