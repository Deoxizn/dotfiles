-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { omarchy = "walker -m symbols" })

-- Unbind keys
hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + ALT + SPACE")
hl.unbind("SUPER + W")
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + SHIFT + M")
hl.unbind("SUPER + P")
hl.unbind("SUPER + A")
hl.unbind("SUPER + RETURN")
hl.unbind("SUPER + SHIFT + RETURN")
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + ALT + SHIFT + F")
hl.unbind("SUPER + SHIFT + B")
hl.unbind("SUPER + SHIFT + ALT + B")
hl.unbind("SUPER + SHIFT + N")
hl.unbind("SUPER + CTRL + D")
hl.unbind("SUPER + ALT + RETURN")

-- Application bindings
o.bind("SUPER + SPACE", "Apps menu", "omarchy-menu toggle apps")
o.bind("SUPER + ALT + SPACE", "Omarchy root menu", "omarchy-menu toggle root")
o.bind("SUPER + RETURN", "Terminal", "foot")
o.bind("SUPER + SHIFT + RETURN", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + F", "File manager", { omarchy = "nautilus" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
o.bind("SUPER + SHIFT + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", "omarchy-launch-browser --private")
o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })
o.bind("SUPER + CTRL + D", "Vesktop", "vesktop")
o.bind("SUPER + CTRL + M", "Messenger", { webapp = "https://www.messenger.com" })
o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
o.bind("SUPER + SHIFT + M", "Music", { omarchy = "spotify" })

-- Custom media / F-key bindings
o.bind("XF86Tools", "Fastfetch", "foot --app-id=org.omarchy.ff fish -c 'ff; exec fish'")
o.bind("XF86Launch5", nil, { webapp = "https://gemini.google.com/app" })
o.bind("XF86Launch6", nil, { webapp = "https://photopea.com" })
o.bind("XF86Launch7", nil, { webapp = "https://learn.omacom.io/2/the-omarchy-manual" })

-- Kill active window
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())

-- Reload wallpaper / hyprpaper
o.bind("SUPER + ALT + W", "Reload hyprpaper", "pkill -x hyprpaper; uwsm-app -- hyprpaper -c ~/.config/hypr/hyprpaper.conf")


-- Keybinding list: omarchy-menu-keybindings summons the removed omarchy-shell
-- for its UI; this fork uses fuzzel instead.
hl.unbind("SUPER + K")
o.bind("SUPER + K", "Keybindings", "omartia-keybinds")

-- Power menu
o.bind("SUPER + ESCAPE", "Power menu", "omartia-power")

-- BEGIN omartia-dots-remux managed keybinds (auto-synced by upgrade.sh — personal edits belong outside this block)
-- omartia-dots-remux: Keybindings
-- Minimal overrides — replaces omarchy-menu with the Caelestia launcher and
-- the omartia fuzzel menu suite. Everything else inherits from omarchy
-- defaults (window mgmt, workspaces, apps).
-- Add your own personal bindings below.

-- Caelestia launcher (replaces omarchy-menu)
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Caelestia launcher", hl.dsp.global("caelestia:launcher"))

-- Omartia menu suite (fuzzel)
o.bind("SUPER + ALT + SPACE", "Omartia menu", "omartia-menu")

-- Caelestia sidebar / notifications shade
o.bind("SUPER + N", "Notifications shade", hl.dsp.global("caelestia:sidebar"))

-- Caelestia dashboard
o.bind("SUPER + ALT + D", "Dashboard", hl.dsp.global("caelestia:dashboard"))

-- Lock via Caelestia (replaces omarchy-system-lock). Uses the full
-- caelestia-system-lock script, not the bare caelestia:lock IPC — the bare IPC
-- never turns the monitors off after locking.
hl.unbind("SUPER + CTRL + L")
o.bind("SUPER + CTRL + L", "Lock system", "caelestia-system-lock")

-- Keybinding list (fuzzel; omarchy's summons the removed omarchy-shell)
hl.unbind("SUPER + K")
o.bind("SUPER + K", "Keybindings", "omartia-keybinds")

-- Power menu (fuzzel)
o.bind("SUPER + ESCAPE", "Power menu", "omartia-power")
-- END omartia-dots-remux managed keybinds
