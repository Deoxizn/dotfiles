-- Workspace rules for Omarchy 4.5 mode (per-monitor blocks).
-- Installed by the plugin's scripts/setup-classic.sh into
-- ~/.config/hypr/, and loaded by hyprland.lua. Only live while this file
-- is .lua: bin/mode renames the other workspaces file to .bak on switch,
-- so exactly one of workspaces.lua / workspaces-classic.lua loads at a
-- time. Workspace assignments are not window rules: they live here, not
-- in windowrules.lua. No default_name glyphs: the bar's workspace
-- settings own the labels now.

-- Monitor pinning: WS 1-10 on HDMI-A-1 (block 0), WS 11-20 on DP-1
-- (block 1). default + persistent so the workspaces always exist on
-- their monitors.
for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", default = true, persistent = true })
end
for i = 11, 20 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1", default = true, persistent = true })
end

-- App pins (4.5 block ids).
local workspaceApps = {
    { match = { class = "^(brave-origin)$" },                 workspace = "11" },
    { match = { class = "^(io\\.github\\.lgse\\.Strata)$" },  workspace = "12" },
    { match = { class = "^(Spotify)$" },                      workspace = "13" },
    { match = { class = "^(steam|battle\\.net\\.exe|net\\.lutris\\.Lutris|com\\.heroicgameslauncher\\.hgl|heroic|retroarch|minecraft-launcher)$" }, workspace = "14" },
    { match = { class = "^(vesktop|discord)$" },              workspace = "1" },
}
for _, r in ipairs(workspaceApps) do
    hl.window_rule({ match = r.match, workspace = r.workspace })
end

-- Webapp windows (brave --app=...)
local workspaceWebapps = {
    { host = "messenger\\.com",       title = "(?i)messenger", workspace = "2" },
    { host = "muse\\.ai",             title = "(?i)^muse",     workspace = "3" },
    { host = "gemini\\.google\\.com",  title = "(?i)^gemini",   workspace = "3" },
    { host = "chatgpt\\.com",         title = "(?i)^chatgpt",  workspace = "3" },
    { host = "xbox\\.com",            title = "(?i)^xbox",     workspace = "14" },
}
for _, r in ipairs(workspaceWebapps) do
    hl.window_rule({ match = { class = "^brave-(www\\.)?" .. r.host .. "__.*$" }, workspace = r.workspace })
    hl.window_rule({ match = { class = "^(brave-origin)$", title = r.title }, workspace = r.workspace })
end

-- Gaming: everything on workspace 14 (DP-1, block 1).
hl.window_rule({ match = { content = "game" }, workspace = "14" })
hl.window_rule({ match = { xdg_tag = "^(.*game.*)$" }, workspace = "14" })
hl.window_rule({ match = { class = "^(steam_app.*|gamescope)$" }, workspace = "14" })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Launching\\.{3})$" }, workspace = "14" })
hl.window_rule({ match = { class = "^(steam_app.*)$", initial_title = "^$" }, workspace = "14" })
hl.window_rule({ match = { class = "^(steam_app_battlenet|battle\\.net\\.exe)$", title = "negative:^(World of Warcraft)$" }, workspace = "14" })
hl.window_rule({ name = "world-of-warcraft", match = { class = "^(steam_app_battlenet)$", title = "^(World of Warcraft)$" }, workspace = "14" })
