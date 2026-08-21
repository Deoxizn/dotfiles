-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv('OMARCHY_PATH') or '/usr/share/omarchy') .. '/default/hypr/bootstrap.lua')

-- omartia-dots-remux: prevent default omarchy autostart (Caelestia handles shell launch).
-- Must be set AFTER bootstrap.lua: it clears package.loaded for default.hypr.*
-- on every load/reload, so a stub placed before it gets wiped. Replacements for
-- the non-shell parts of the default autostart live in hypr/autostart.lua.
package.loaded["default.hypr.autostart"] = true

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false

-- Load Omarchy defaults (includes default autostart which starts omarchy-launch-shell).
require('default.hypr.omarchy')

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require('hypr.monitors')
require('hypr.input')
require('hypr.bindings')
require('hypr.looknfeel')
require('hypr.autostart')

-- Toggle config flags dynamically.
require('default.hypr.toggles')

-- omartia-dots-remux: scrolling workspaces, added to the right
for i = 1, 10 do
  hl.workspace_rule({ workspace = tostring(i), layout = "scrolling", layout_opts = { direction = "right" }, default = i == 1 })
end

-- Launch apps in specific workspaces
hl.window_rule({ match = { class = "zen|chromium|brave-browser|brave-origin-beta" }, workspace = "1" })
hl.window_rule({ match = { class = "org.gnome.Nautilus|nautilus" }, workspace = "2" })
hl.window_rule({ match = { class = "spotify|Spotify|com.github.th_ch.youtube_music" }, workspace = "3" })
hl.window_rule({ match = { class = "Battle.net|World of Warcraft|steam_app_default" }, workspace = "4" })
hl.window_rule({ match = { class = "discord|vesktop" }, workspace = "6" })
