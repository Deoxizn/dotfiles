-- Omarchy-compatible window rules ported from dotfiles.
-- Window rules only: how windows look and behave. Workspace assignments
-- (which monitor a workspace lives on, which apps open on which
-- workspace) are not window rules, so they live in workspaces.lua (4.5)
-- and workspaces-classic.lua (classic) in this same directory, and
-- bin/mode keeps exactly one of those as .lua. This file is the same in
-- both modes.

-- Picture-in-Picture
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, keep_aspect_ratio = true, size = { "max(monitor_w, monitor_h)*0.25", "min(monitor_w, monitor_h)*0.25" }, pin = true })

-- Media player floating (follows native resolution)
hl.window_rule({ match = { class = "^(mpv)$", title = "negative:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, center = true })

hl.window_rule({ match = { class = "^(app\\.fastfetch)$" }, float = true, size = { "1910", "720" }, center = true })

-- Opacity Overrides, restored from CachyOS dotfiles (hypr/config/windowrules.lua).
-- The Omarchy port dropped this whole section, which is why games and browsers
-- went transparent. These are the original rules, verbatim.
hl.window_rule({ match = { class = "^(firefox|zen|brave-origin|brave-.+)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "^(steam_app.*|gamescope|wine.*|.*\\.exe)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { content = "game" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "^(mpv|imv)$" }, opacity = "1.0 override" })


-- Gaming, ported from CachyOS dotfiles (hypr/config/windowrules.lua).
-- Fullscreen treatment omitted per request: no fullscreen_state,
-- sync_fullscreen, decorate=false, or monitor-size rules. Which
-- workspace the games land on is in workspaces.lua / workspaces-classic.lua.

-- Steam dialogs: Friends List floats; Launching... floats centered.
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Launching\\.{3})$" }, float = true, center = true })

-- Blank-title steam_app windows: centered, floating (windowed).
hl.window_rule({ match = { class = "^(steam_app.*)$", initial_title = "^$" }, center = true, float = true })

-- Battle.net launcher + Wine dialogs: floating, centered. Title negative
-- keeps the WoW client out (same class when launched directly).
hl.window_rule({ match = { class = "^(steam_app_battlenet|battle\\.net\\.exe)$", title = "negative:^(World of Warcraft)$" }, float = true, center = true })

-- WoW launched directly: keep tiled, not floating.
hl.window_rule({ name = "world-of-warcraft", match = { class = "^(steam_app_battlenet)$", title = "^(World of Warcraft)$" }, float = false, center = false, content = "game" })
