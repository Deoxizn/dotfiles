-- Window rules wiki https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Generic floating position
hl.window_rule({ match = { float = true }, persistent_size = true })

-- Picture-in-Picture
hl.window_rule({
    match             = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float             = true,
    keep_aspect_ratio = true,
    size              = { "max(monitor_w, monitor_h)*0.25", "min(monitor_w, monitor_h)*0.25" },
    pin               = true,
})

-- Gaming — all gaming windows live on WS4 (DP-1, named 󰺵).
-- NOTE: NO named "gaming" workspace. `workspace = "name:gaming"` used to
-- create a dynamic workspace with no monitor binding — it materialized on
-- whichever monitor was focused (usually the Dell/HDMI) and never matched
-- WS4. WS4 IS the gaming workspace; it is pinned to DP-1 in workspaces.lua.
local gamingApps = "^(steam_app.*|gamescope)$"
local gamingLaunchers = "^(steam|battle\\.net\\.exe|net\\.lutris\\.Lutris|com\\.heroicgameslauncher\\.hgl|heroic|retroarch|minecraft-launcher)$"
local gamingWorkspace = "4"

hl.window_rule({ match = { content = "game" }, workspace = gamingWorkspace })
hl.window_rule({ match = { xdg_tag = "^(.*game.*)$" }, workspace = gamingWorkspace, fullscreen_state = 2, content = "game", sync_fullscreen = true })
hl.window_rule({ match = { class = gamingApps }, workspace = gamingWorkspace })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Launching\\.{3})$" }, float = true, center = true, workspace = gamingWorkspace })
hl.window_rule({
    match = {
        class         = gamingApps,
        -- Battle.net is a launcher, not a game: all its Wine windows share
        -- class steam_app_battlenet, so without this exclusion the fullscreen
        -- treatment below hit its settings/messages popups too (stretched to
        -- monitor size, undecorated, laggy). See the battlenet rule below.
        initial_class = "negative:^(steam_app_battlenet|battle\\.net\\.exe)$",
        title         = "^(.+)$",
        initial_title = "negative:^(.*\\\\home\\\\.*)$",
    },
    content          = "game",
    decorate         = false,
    fullscreen_state = 2,
    size             = { "monitor_w", "monitor_h" },
    sync_fullscreen  = true,
})
hl.window_rule({
    match = {
        class         = "^(steam_app.*)$",
        initial_title = "^$",
    },
    center           = true,
    float            = true,
    fullscreen       = false,
    fullscreen_state = 0,
    workspace        = gamingWorkspace,
})

-- Launcher windows themselves (Steam, Battle.net, Lutris, Heroic, RetroArch,
-- Minecraft) also belong on the gaming workspace, not wherever you happen to be.
hl.window_rule({ match = { class = gamingLaunchers }, workspace = gamingWorkspace })

-- Battle.net launcher + all of its Wine dialogs (settings, messages, login,
-- agent popups — every window it opens is class steam_app_battlenet or
-- battle.net.exe): normal decorated floating windows, centered, natural size.
-- Excluded from the fullscreen game treatment above via initial_class
-- negative: on that rule.
local battlenetApps = "^(steam_app_battlenet|battle\\.net\\.exe)$"
hl.window_rule({
    match            = { class = battlenetApps },
    workspace        = gamingWorkspace,
    float            = true,
    center           = true,
    fullscreen_state = 0,
})

-- Apps
hl.window_rule({ match = { class = "^(.*\\.exe)$", float = true }, monitor = PRIMARY_MONITOR, center = true, fullscreen_state = 0 })
hl.window_rule({ match = { class = "^(.*[Ll]auncher.*)$" }, float = true, monitor = PRIMARY_MONITOR })
-- vesktop/discord: pinned to WS6 (Dell portrait) — see the hexciri
-- named-workspace assignments at the bottom. A monitor rule here would fight
-- the workspace rule (WS6 lives on HDMI-A-1, not PRIMARY_MONITOR).
hl.window_rule({ match = { class = "^(.*[Cc]alc.*)$" }, float = true, size = { "max(monitor_w, monitor_h)*0.17", "min(monitor_w, monitor_h)*0.43" } })
hl.window_rule({ match = { class = "^(org\\.kde\\.keditfiletype)$" }, float = true })
hl.window_rule({ match = { class = "^(org\\.kde\\.ark)$" }, size = { "max(monitor_w, monitor_h)*0.40", "min(monitor_w, monitor_h)*0.40" } })
hl.window_rule({ match = { class = "^(.*swash)$", title = "^(Swash)$" }, min_size = { "max(monitor_w, monitor_h)*0.35", "min(monitor_w, monitor_h)*0.35" }, float = true })
hl.window_rule({ match = { class = "^(dev\\.)?(noctalia\\.Noctalia(\\.Settings)?)$" }, float = true, size = { "monitor_w*0.70", "monitor_h*0.70" } })
hl.window_rule({
    match = {
        class = "^(org\\.kde\\.dolphin)$",
        title = "negative:^(Moving.*|Create New.*|Extract.*|Compress.*|Copying.*|Progress.*|Configure.*|Properties.*|Choose\\sApplication.*)$",
    },
    float = true,
    size = { "max(monitor_w, monitor_h)*0.50", "min(monitor_w, monitor_h)*0.55" },
    move = {
        "max(20, min(cursor_x - (window_w*0.50), monitor_w - window_w + 20))", -- X axis clamping
        "max(20, min(cursor_y - 50, monitor_h - window_h + 20))" -- Y axis clamping
    },
})

-- Opacity Overrides
local terminals = "^(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)$"

-- Browsers stay fully opaque: Firefox/Zen plus every Brave window — the main
-- browser (brave-origin) and --app webapps (class brave-<slug>-Default).
hl.window_rule({ match = { class = "^(firefox|zen|brave-origin|brave-.+)$" }, opacity = "1.0 override" })

-- Games stay fully opaque too: the global decoration opacity (0.95/0.85) makes
-- them washy and shows the wallpaper through them mid-fight. `content = "game"`
-- only matches apps that advertise their content type (WoW under XWayland
-- reports `none`), so match game classes as well:
--   steam_app_*  — every Steam/Proton game, but ALSO WoW, because Battle.net is
--                  launched by Steam and all of its windows inherit
--                  steam_app_battlenet (launcher + game share the class).
--   gamescope    — nested gamescope sessions.
--   wine* / *.exe — games launched outside Steam (Lutris, Heroic, plain Wine).
hl.window_rule({ match = { class = "^(steam_app.*|gamescope|wine.*|.*\\.exe)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { content = "game" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = terminals }, opacity = "1.0 override" }) -- Override opacity in favor of terminal settings for opacity. If your terminal doesn't support transparency, you can remove this rule.
hl.window_rule({ match = { class = "^(mpv|org.kde.haruna|.*plex.*|org\\.kde\\.gwenview|.*vlc.*)$" }, opacity = "1.0 override" })

-- Float Utility Windows
local floatApps = {
    { class = "^(kvantummanager|qt[56]ct|nwg-look)$" },
    { class = "^(org.pulseaudio.pavucontrol|blueman-manager|nm-applet|nm-connection-editor)$" },
    { title = "^(Winetricks.*|Protontricks.*)$" },
}
for _, m in ipairs(floatApps) do hl.window_rule({ match = m, float = true }) end

-- Float Common Modals
local modalMatches = {
    { title = "^(Open|Authentication Required|Add Folder to Workspace|Choose Files|Save As|Confirm to replace files|File Operation Progress)$" },
    { initial_title = "^(Open File)$" },
    { class = "^([Xx]dg-desktop-portal-gtk)$" },
    { title = "^(File Upload|Choose wallpaper|Library)(.*)$" },
    { class = "^(.*dialog.*)$" },
    { title = "^(.*dialog.*)$" },
    { class = "^(hyprland-share-picker)$"},
}
for _, m in ipairs(modalMatches) do hl.window_rule({ match = m, float = true }) end

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Noctalia layer rule
hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

-- ── HEXCIRI windowrules ──
-- Hexciri window rules (machine-managed section — seed-once).
-- Mirrors the niri window-rules TUI/float habits.

-- TUI apps — float at 1000x720, centered.
-- Used by hexciri-agent (opencode), install/remove menus, maintenance,
-- network QR, reminders, share, hw disk-speedtest, setup, system, etc.
-- All of them launch via `xdg-terminal-exec --app-id=TUI.float`, so one
-- rule catches every TUI. Niri equivalent: match app-id="TUI\\.float",
-- open-floating + fixed 1000x720.
hl.window_rule({ match = { class = "^(TUI\\.float)$" }, float = true, size = { "1000", "720" }, center = true })

-- Fastfetch terminal (Mod+Alt+F) — float at 1210x720, centered.
hl.window_rule({ match = { class = "^(app\\.hexciri\\.ff)$" }, float = true, size = { "1870", "720" }, center = true })

-- Media player — floating; the window follows the video's native resolution
-- (mpv's own autofit-larger=100%x100% in ~/.config/mpv/mpv.conf), so no size here.
-- PiP is excluded by title so it keeps the stock size/pin treatment above.
-- Niri equivalent: match app-id="mpv", open-floating.
hl.window_rule({ match = { class = "^(mpv)$", title = "negative:^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, center = true })

-- ── END HEXCIRI windowrules ──

-- ── workspace pins (personal — dotfiles, not hexciri) ──
-- Each named workspace owns its app(s); they only ever open there. Workspace
-- map is in config/workspaces.lua:
--   1 🦁 Brave Origin · 2  Strata · 3 󰽫󰽻󰽩 Spotify · 4 󰺵 gaming ·
--   6  Vesktop · 7 󰣋 Messenger · 8 󱚟 AI (Muse/Gemini/ChatGPT)
-- Rules apply in order and the LAST match wins, so the webapp rules MUST
-- come after the generic brave-origin rule (a webapp tab in the browser
-- window is also brave).
local workspaceApps = {
    { match = { class = "^(brave-origin)$" },                 workspace = "1" },
    { match = { class = "^(io\\.github\\.lgse\\.Strata)$" },  workspace = "2" },
    { match = { class = "^(Spotify)$" },                      workspace = "3" },
    { match = { class = "^(vesktop|discord)$" },              workspace = "6" },
}
for _, r in ipairs(workspaceApps) do
    hl.window_rule({ match = r.match, workspace = r.workspace })
end

-- Webapp windows (brave --app=..., launched via hexciri-launch-or-focus-webapp)
-- do NOT keep the browser's own class: Chromium derives a per-URL WM_CLASS
-- from the host — brave-www.messenger.com__-Default for messenger, NOT
-- brave-origin. The old rule matched brave-origin + title, so it never
-- fired and every webapp opened on whichever workspace happened to be
-- focused (Messenger was supposed to live on WS7). Route by the host baked
-- into the class; the title match stays as a net for webapps opened as a
-- plain tab inside the regular browser window.
local workspaceWebapps = {
    { host = "messenger\\.com",     title = "(?i)messenger", workspace = "7" }, -- 󰣋 Messenger
    { host = "muse\\.ai",           title = "(?i)^muse",     workspace = "8" }, -- 󱚟 Muse
    { host = "gemini\\.google\\.com", title = "(?i)^gemini",  workspace = "8" }, -- 󱚟 Gemini
    { host = "chatgpt\\.com",       title = "(?i)^chatgpt",  workspace = "8" }, -- 󱚟 ChatGPT
    { host = "xbox\\.com",          title = "(?i)^xbox",     workspace = "4" }, -- 󰺵 Xbox Cloud Gaming
}
for _, r in ipairs(workspaceWebapps) do
    -- Chromium app window: the URL host lives in the WM_CLASS.
    hl.window_rule({ match = { class = "^brave-(www\\.)?" .. r.host .. "__.*$" }, workspace = r.workspace })
    -- Same app as a plain tab in the regular browser window.
    hl.window_rule({ match = { class = "^(brave-origin)$", title = r.title }, workspace = r.workspace })
end
-- ── END workspace pins ──
