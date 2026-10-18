local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

-- AZERTY fix: the number-row keys emit symbols (& é " ' ...) without Shift, so
-- binding to the digit characters fails. Bind by physical keycode instead.
-- Digit d -> evdev keycode: 1..9 => 10..18, 0 => 19
local function digitCode(d)
    return "code:" .. (d == 0 and 19 or (9 + d))
end

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
-- [hexciri] hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
-- [hexciri] hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))

-- Change focus
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab",           hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Tab",   hl.dsp.exec_cmd(noctCall .. "window-switcher"))

-- Move active window around workspaces & monitors
hl.bind(mainMod .. " + SHIFT + Up",                   hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Right",                hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Left",                 hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Down",                 hl.dsp.window.move({ direction = "d" }))
-- [hexciri] hl.bind(mainMod .. " + SHIFT + " .. digitCode(1),     hl.dsp.window.move({ monitor = MONITOR1 }))
-- [hexciri] hl.bind(mainMod .. " + SHIFT + " .. digitCode(2),     hl.dsp.window.move({ monitor = MONITOR2 }))
-- [hexciri] hl.bind(mainMod .. " + SHIFT + " .. digitCode(3),     hl.dsp.window.move({ monitor = MONITOR3 })) -- (3rd monitor n/a on this desktop)
hl.bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor   = "-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor   = "+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }))
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + CONTROL + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i }))
end
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + ALT + " .. digitCode(key), hl.dsp.window.move({ workspace = "m~" .. i, follow = false }))
end

-- Move & Resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + Minus", function() zoomfunction(-0.3) end, { repeating = true})
hl.bind(mainMod .. " + Plus", function() zoomfunction(0.3) end, { repeating = true })

--# Zoom with keypad
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true })


------------------
---- LAUNCHER ----
------------------

-- [hexciri] hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
-- [hexciri] hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR))
-- [hexciri] hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind("XF86Calculator",           hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
-- [hexciri] hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER))
-- [hexciri] hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))
hl.bind(mainMod .. " + Z",          hl.dsp.exec_cmd(noctCall .. "settings-toggle"))
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind(mainMod .. " + period",     hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"))
-- [hexciri] hl.bind(mainMod .. " + L",          hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind(mainMod .. " + ALT + C",    hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),    { locked = true })

-- Media
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })

-------------------
---- UTILITIES ----
-------------------

-- Screen Capture
hl.bind(mainMod .. " + P",     hl.dsp.exec_cmd("hyprpicker -a -n"))
hl.bind("Print",               hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"))

-- Theming and Wallpaper
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"))

-- Clipboard
-- [hexciri] hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"))

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on monitors (this desktop has 2: DP-1 + HDMI-A-1 — no MONITOR3)
hl.bind(mainMod .. " + " .. digitCode(1), hl.dsp.focus({ monitor = MONITOR1 }))
hl.bind(mainMod .. " + " .. digitCode(2), hl.dsp.focus({ monitor = MONITOR2 }))

-- Focus on workspace number
-- Absolute
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + ALT + " .. digitCode(key), hl.dsp.focus({ workspace = i }))
end
-- Relative
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + CONTROL + " .. digitCode(key), hl.dsp.focus({ workspace = "m~" .. i }))
end

-- Move to adjacent workspaces and next empty on a given monitor
hl.bind(mainMod .. " + CONTROL + Right",       hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + Left",        hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + Down",        hl.dsp.focus({ workspace = "emptym" }))

-- Scroll through existing workspaces & monitors
hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }))

-- Special workspace (scratchpad)
-- [hexciri] hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }))
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special())

-- ── HEXCIRI binds ──
-- Hexciri core binds (machine-managed section — see sync_hyprland).
-- Mirrors config/niri/cfg/keybinds.kdl core. Uses stock mainMod.

-- Root menu / keybind reference / agent
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd("hexciri-menu"))
hl.bind(mainMod .. " + K",           hl.dsp.exec_cmd("hexciri-keybinds"))
hl.bind(mainMod .. " + grave",       hl.dsp.exec_cmd("hexciri-agent"))

-- Search / calculator (fuzzel providers)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hexciri-fuzzel search"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hexciri-fuzzel calc"))

-- System monitor (bottom)
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btm"))

-- Default apps (terminal/editor/browser/file manager via hexciri defaults layer)
-- Mod+Return = smart terminal: tab into a live kitty (focused one first,
-- else the newest), and only spawn via hexciri-terminal when none is up.
-- Liveness is hyprctl ground truth (no tabbing into windowless leftovers).
hl.bind(mainMod .. " + Return",   hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/terminal-smart.sh"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("zeditor"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("xdg-open https://"))
hl.bind(mainMod .. " + CONTROL + B", hl.dsp.exec_cmd("brave-origin --incognito"))
-- NOTE: stock Mod+W (launchPrefix .. BROWSER with BROWSER="firefox") is dead
-- — firefox is replaced by Brave Origin — and is neutralized at deploy with
-- NO replacement: browser already lives on Mod+Shift+B. One browser launcher.
-- Mod+Shift+F = File manager, niri verb. Dispatches the user's Defaults pick
-- (strata on hyprland boxes, nautilus on niri) via hexciri-defaults run files.
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hexciri-defaults run files"))

-- Floating toggle on Mod+T (Omarchy parity): the niri verb and the stock
-- float slot agree here — tiling/floating flip, no menus involved.
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

-- Layout cycle (dwindle/scrolling/monocle) on Mod+L (Omarchy parity): takes
-- over the stock session-lock slot — neutralized at deploy like the other
-- owned combos, since lock already lives on Mod+Ctrl+L (hexciri-lock, with
-- the panel-off loop) and needs no plain-L duplicate.
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hexciri-hyprland-layout"))

-- Monocle stack flipping: every window is fullscreen, so directional focus
-- is useless — cycle the stack instead (forward/back, wrapping). Alt+Tab
-- does this globally too; these are the Mod-driven equivalents. Brackets, not
-- PageUp/PageDown: laptop Fn-combos for paging don't reach the compositor
-- with Mod held, but [ ] are physical keys everywhere.
-- Per the wiki's monocle quirks, plain cycle_next() does NOT work in monocle
-- (focus moves without restacking — invisible): the layout messages
-- cyclenext/cycleprev are the anointed path (verified live: ok under
-- monocle, unknown-message under dwindle as expected).
hl.bind(mainMod .. " + bracketright", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("cycleprev"))

-- Workspaces: niri verbs (Mod+digit switch / Mod+SHIFT+digit move). Stock
-- CachyOS binds Mod+ALT+digit to switch and Mod+SHIFT+CONTROL|ALT+digit to
-- move, and its Mod+SHIFT+digit(1-3) nudges windows between MONITORS — the
-- deploy patch removes those three so the move verb is unambiguous. Digit
-- binds use keycodes (code:10..18 = the number row) exactly like stock
-- digitCode()/Omarchy, so they work on every layout (AZERTY included).
hl.bind(mainMod .. " + code:10", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + code:11", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + code:12", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + code:13", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + code:14", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + code:15", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + code:16", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + code:17", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + code:18", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + code:19", hl.dsp.focus({ workspace = "10" })) -- 0 key -> WS10 (Dell portrait)
hl.bind(mainMod .. " + SHIFT + code:10", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + code:11", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + code:12", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + code:13", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + code:14", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + code:15", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + code:16", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + code:17", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + code:18", hl.dsp.window.move({ workspace = "9" }))
hl.bind(mainMod .. " + SHIFT + code:19", hl.dsp.window.move({ workspace = "10" })) -- 0 key -> WS10

-- Window close (same as stock — harmless duplicate, keeps muscle memory)
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Power menu (stock kill on this combo is patched out at deploy — see header)
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hexciri-power"))

-- Lock (hexciri-lock adds the panel-off loop on top of the shell lock)
hl.bind(mainMod .. " + CONTROL + L", hl.dsp.exec_cmd("hexciri-lock"))

-- Clipboard history
hl.bind(mainMod .. " + CONTROL + V", hl.dsp.exec_cmd("hexciri-clipboard"))
-- Clipboard panel (moved off Mod+V for universal paste — same family)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))

-- Universal copy/paste (Omarchy parity): Super chords work everywhere —
-- terminals get Ctrl+Shift, everything else gets Ctrl+C/V. Synthetic keys go
-- down/up split (50ms oneshot) so key state never sticks or repeats.
-- Terminals are matched by window class (no tag system here).
local function send_key_once(mods, key)
  return function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end
end
local TERMINAL_CLASSES = { kitty = true, foot = true, ghostty = true, Alacritty = true,
  ["tui.float"] = true, ["app.hexciri.ff"] = true }
local function active_is_terminal()
  local ok, w = pcall(hl.get_active_window)
  if not ok or not w then return false end
  return TERMINAL_CLASSES[w.class] == true
end
local function universal_key(gui_mods, gui_key, term_mods, term_key)
  return function()
    if active_is_terminal() then
      send_key_once(term_mods, term_key)()
    else
      send_key_once(gui_mods, gui_key)()
    end
  end
end
hl.bind(mainMod .. " + C", universal_key("CTRL", "C", "CTRL SHIFT", "C"))
hl.bind(mainMod .. " + V", universal_key("CTRL", "V", "CTRL SHIFT", "V"))

-- Messenger webapp
hl.bind(mainMod .. " + CONTROL + M", hl.dsp.exec_cmd("hexciri-launch-or-focus-webapp messenger https://www.messenger.com"))

-- Screen record (region/screenshot stay on stock noctalia binds)
hl.bind("ALT + Print", hl.dsp.exec_cmd("hexciri-screenrecord"))

-- Notifications (same verbs as the niri binds)
hl.bind(mainMod .. " + comma",            hl.dsp.exec_cmd("noctalia msg notification-clear-active"))
hl.bind(mainMod .. " + CONTROL + period", hl.dsp.exec_cmd("noctalia msg notification-clear-history"))
hl.bind(mainMod .. " + CONTROL + S",      hl.dsp.exec_cmd("noctalia msg settings-toggle"))

-- ── Ported from niri keybinds.kdl (restored 2026-10-17 — were dropped in the
-- initial FW13-derived port). Same chords/actions as the niri set. ──

-- Apps
hl.bind(mainMod .. " + SHIFT + M",     hl.dsp.exec_cmd(launchPrefix .. "spotify"))
hl.bind(mainMod .. " + CONTROL + D",   hl.dsp.exec_cmd(launchPrefix .. "vesktop"))
-- Fastfetch in a floating window (key emits via XF86Tools). Class app.hexciri.ff
-- is matched in TERMINAL_CLASSES for universal paste. fish -c keeps the window
-- open on a shell after fastfetch exits (mirrors the niri bind's ff → exec fish).
-- Per-launch kitty -o overrides give this window FW13's font (Ransom Mono
-- Unruly NF at 10) without touching kitty.conf — every other kitty stays on
-- Maple Mono NF at 9.0. The FONT field in fastfetch just reads kitty.conf, so
-- it will still *report* Maple Mono; the rendering is what changes.
hl.bind("XF86Tools",                   hl.dsp.exec_cmd(launchPrefix ..
    "kitty --class app.hexciri.ff -o 'font_family=Ransom Mono Unruly NF' -o font_size=10 fish -c \"fastfetch; exec fish\""))
-- Webapps (same hexciri-launch-or-focus-webapp helper as messenger on Mod+Ctrl+M)
hl.bind("XF86Launch5",                 hl.dsp.exec_cmd("hexciri-launch-or-focus-webapp muse https://muse.ai"))
hl.bind("XF86Launch6",                 hl.dsp.exec_cmd("hexciri-launch-or-focus-webapp photopea https://photopea.com"))

-- Workspace navigation (niri Mod+U / Mod+I muscle memory; maps to prev/next
-- workspace on the current monitor, matching the Ctrl+Left/Right m±1 pair)
hl.bind(mainMod .. " + U",             hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + I",             hl.dsp.focus({ workspace = "m+1" }))

-- Screenshots: full screen straight to clipboard (niri Ctrl+Print grim | wl-copy)
hl.bind("CONTROL + Print",             hl.dsp.exec_cmd("grim - | wl-copy"))
-- ── END HEXCIRI binds ──
