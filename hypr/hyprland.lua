-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Caelestia: prevent default omarchy autostart (Caelestia handles shell launch).
-- Must be set AFTER bootstrap.lua: it clears package.loaded for default.hypr.*
-- on every load/reload, so a stub placed before it gets wiped. Replacements for
-- the non-shell parts of the default autostart live in hypr/autostart.lua.
package.loaded["default.hypr.autostart"] = true

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Workspaces per monitor with scrolling layout
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, layout = "scrolling", layout_opts = { direction = "right" } })
hl.workspace_rule({ workspace = "2", monitor = "DP-1", layout = "scrolling", layout_opts = { direction = "right" } })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", layout = "scrolling", layout_opts = { direction = "right" } })
hl.workspace_rule({ workspace = "4", monitor = "DP-1", layout = "scrolling", layout_opts = { direction = "right" } })
hl.workspace_rule({ workspace = "5", monitor = "DP-1", layout = "scrolling", layout_opts = { direction = "right" } })

hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", default = true, layout = "scrolling", layout_opts = { direction = "down" } })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1", layout = "scrolling", layout_opts = { direction = "down" } })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", layout = "scrolling", layout_opts = { direction = "down" } })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", layout = "scrolling", layout_opts = { direction = "down" } })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1", layout = "scrolling", layout_opts = { direction = "down" } })

-- Launch Apps in Specific Workspaces
hl.window_rule({ match = { class = "zen|chromium|brave|brave-origin-beta" }, workspace = "1" })
hl.window_rule({ match = { class = "org.gnome.Nautilus|nautilus" }, workspace = "2" })
hl.window_rule({ match = { class = "spotify|Spotify" }, workspace = "3" })
-- Games & game launchers -> WS 4
-- IMPORTANT: keep class patterns PLAIN (alternations only, no [...] char
-- classes or (?i) inline flags) -- they silently never match on this build,
-- and one bad pattern kills the whole rule.
-- Steam client + games launched through Steam (steam_app_<id>)
hl.window_rule({ match = { class = "steam|Steam|steamwebhelper|steam_app_" }, workspace = "4" })
-- Lutris + its Wine prefixes: Battle.net launcher, World of Warcraft
hl.window_rule({
  match = { class = "lutris|Lutris|net.lutris.Lutris|Battle.net|World of Warcraft" },
  workspace = "4",
})
-- WowUp CF addon manager
hl.window_rule({ match = { class = "WowUpCf|wowupcf|WowUp|wowup-cf" }, workspace = "4" })
-- Gamescope sessions
hl.window_rule({ match = { class = "gamescope" }, workspace = "4" })
hl.window_rule({ match = { class = "kitty" }, workspace = "8" })
hl.window_rule({ match = { class = "discord|vesktop" }, workspace = "6" })
hl.window_rule({ match = { class = "Messenger" }, workspace = "7" })

