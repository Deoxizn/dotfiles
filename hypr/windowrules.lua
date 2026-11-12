-- Omarchy-compatible window rules ported from dotfiles.
-- DP-1 is monitor block 1, so its workspaces are 11-20.

-- Picture-in-Picture
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, keep_aspect_ratio = true, size = { "max(monitor_w, monitor_h)*0.25", "min(monitor_w, monitor_h)*0.25" }, pin = true })

-- Media player floating (follows native resolution)
hl.window_rule({ match = { class = "^(mpv)$", title = "negative:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, center = true })

-- Workspace pins (DP-1 block: +10)
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

hl.window_rule({ match = { class = "^(app\\.fastfetch)$" }, float = true, size = { "1910", "720" }, center = true })

-- Opacity Overrides, restored from CachyOS dotfiles (hypr/config/windowrules.lua).
-- The Omarchy port dropped this whole section, which is why games and browsers
-- went transparent. These are the original rules, verbatim.
hl.window_rule({ match = { class = "^(firefox|zen|brave-origin|brave-.+)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "^(steam_app.*|gamescope|wine.*|.*\\.exe)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { content = "game" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "^(mpv|imv)$" }, opacity = "1.0 override" })


-- Gaming, ported from CachyOS dotfiles (hypr/config/windowrules.lua).
-- Remapped to workspace 14 (Omarchy DP-1 block). Fullscreen treatment omitted
-- per request: no fullscreen_state, sync_fullscreen, decorate=false, or monitor-size
-- rules. Launcher pin to 14 is already in the workspace pins above.
local gamingApps = "^(steam_app.*|gamescope)$"

-- Game windows live on the gaming workspace.
hl.window_rule({ match = { content = "game" }, workspace = "14" })
hl.window_rule({ match = { xdg_tag = "^(.*game.*)$" }, workspace = "14" })
hl.window_rule({ match = { class = gamingApps }, workspace = "14" })

-- Steam dialogs: Friends List floats; Launching... floats centered on 14.
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Launching\\.{3})$" }, float = true, center = true, workspace = "14" })

-- Blank-title steam_app windows: centered, floating, on 14 (windowed).
hl.window_rule({ match = { class = "^(steam_app.*)$", initial_title = "^$" }, center = true, float = true, workspace = "14" })

-- Battle.net launcher + Wine dialogs: floating, centered, on 14. Title negative
-- keeps the WoW client out (same class when launched directly).
hl.window_rule({ match = { class = "^(steam_app_battlenet|battle\\.net\\.exe)$", title = "negative:^(World of Warcraft)$" }, workspace = "14", float = true, center = true })

-- WoW launched directly: keep tiled on 14, not floating.
hl.window_rule({ name = "world-of-warcraft", match = { class = "^(steam_app_battlenet)$", title = "^(World of Warcraft)$" }, workspace = "14", float = false, center = false, content = "game" })
