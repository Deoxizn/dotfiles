-- Hexciri core binds for Hyprland (additive overlay).
-- Required AFTER the stock binds (see hyprland.lua). Combos that hexciri must
-- own outright (Mod+Alt+Space root menu, Mod+Escape power menu, Mod+Return
-- terminal, Mod+Shift+S web search, Mod+Shift+1-3 workspace-move) have their
-- stock lines patched OUT at deploy time (sync_hyprland → binds.lua.hexciri.bak):
-- in this shell duplicate combo binds STACK (both actions fire), so "required
-- later = wins" is a myth for shared combos. Mirrors config/niri/cfg/keybinds.kdl core.
--
-- Deliberately NOT duplicated from stock binds.lua:
--   * media/brightness keys (stock routes them via noctalia; niri uses
--     wpctl/playerctl/brightnessctl directly — each WM keeps its own)
--
-- Window close (Mod+Q) is duplicated on purpose: same action in both files, so
-- stacking is invisible and Q keeps the niri muscle memory.

local mainMod = "SUPER"

-- Root menu / keybind reference / agent
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd("hexciri-menu"))
hl.bind(mainMod .. " + K",           hl.dsp.exec_cmd("hexciri-keybinds"))
hl.bind(mainMod .. " + grave",       hl.dsp.exec_cmd("hexciri-agent"))

-- Search / calculator (fuzzel providers)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hexciri-fuzzel search"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hexciri-fuzzel calc"))

-- Default apps (terminal/editor/browser/file manager via hexciri defaults layer)
-- MACHINE CUSTOM 2026-09-22: Return runs scripts/terminal-smart.sh (ported
-- from the niri backup: new tab in a live kitty instead of stacking windows)
-- instead of stock hexciri-terminal. NOTE: editing this overlay marks it
-- custom — future hexciri overlay refreshes stop landing here (delete the
-- "! hexciri-binds.lua" line in config/.hexciri-manifest to rejoin).
hl.bind(mainMod .. " + Return",   hl.dsp.exec_cmd("/home/devi/.config/hypr/scripts/terminal-smart.sh"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("zeditor"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("xdg-open https://"))
-- NOTE: stock Mod+W (launchPrefix .. BROWSER with BROWSER="firefox") is dead
-- — firefox is replaced by Brave Origin — and is neutralized at deploy with
-- NO replacement: browser already lives on Mod+Shift+B. One browser launcher.
-- Mod+Shift+F = File manager, niri verb. Dispatches the user's Defaults pick
-- (dolphin on hyprland boxes, nautilus on niri) via hexciri-defaults run files.
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hexciri-defaults run files"))

-- Floating toggle on Mod+T (Omarchy parity): tiling/floating flip.
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

-- Layout cycle (dwindle/scrolling/monocle) on Mod+L (Omarchy parity):
-- takes over the stock session-lock slot (neutralized at deploy; lock lives
-- on Mod+Ctrl+L via hexciri-lock).
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
hl.bind(mainMod .. " + SHIFT + code:10", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + code:11", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + code:12", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + code:13", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + code:14", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + code:15", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + code:16", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + code:17", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + code:18", hl.dsp.window.move({ workspace = "9" }))

-- Window close (same as stock — harmless duplicate, keeps muscle memory)
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Power menu (stock kill on this combo is patched out at deploy — see header)
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hexciri-power"))

-- Lock (hexciri-lock adds the panel-off loop on top of the shell lock)
hl.bind(mainMod .. " + CONTROL + L", hl.dsp.exec_cmd("hexciri-lock"))

-- Clipboard history
hl.bind(mainMod .. " + CONTROL + V", hl.dsp.exec_cmd("hexciri-clipboard"))

-- Messenger webapp
hl.bind(mainMod .. " + CONTROL + M", hl.dsp.exec_cmd("hexciri-launch-or-focus-webapp messenger https://www.messenger.com"))

-- Screen record (region/screenshot stay on stock noctalia binds)
hl.bind("ALT + Print", hl.dsp.exec_cmd("hexciri-screenrecord"))

-- Notifications (same verbs as the niri binds)
hl.bind(mainMod .. " + comma",            hl.dsp.exec_cmd("noctalia msg notification-clear-active"))
hl.bind(mainMod .. " + CONTROL + period", hl.dsp.exec_cmd("noctalia msg notification-clear-history"))
hl.bind(mainMod .. " + CONTROL + S",      hl.dsp.exec_cmd("noctalia msg settings-toggle"))