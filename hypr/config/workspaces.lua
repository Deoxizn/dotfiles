-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- THIS DESKTOP: workspaces are split across the two monitors --
--   WS 1-5  -> DP-1     (ASUS VG28UQL1A 4K, primary)
--   WS 6-10 -> HDMI-A-1 (Dell P2212H, portrait)
-- persistent = always exist (shown even when empty); default = default ws on that monitor.

-- WS 1-5 on the ASUS (DP-1)
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = MONITOR1, default = true, persistent = true })
end

-- WS 6-10 on the Dell portrait (HDMI-A-1)
for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = MONITOR2, default = true, persistent = true })
end

-- ── HEXCIRI workspace names ──
-- Names ported from FW13 (hypr/config/workspaces.lua); glyphs render in
-- FantasqueSansM Nerd Font, the lion in Noto Color Emoji. Only the
-- workspaces with a designated app are named -- 5, 9, 10 stay numeric.
-- These layer on top of the monitor/persistent rules above.
-- Brave Origin
hl.workspace_rule({ workspace = "1", default_name = "🦁" })
-- Strata
hl.workspace_rule({ workspace = "2", default_name = "" })
-- Spotify
hl.workspace_rule({ workspace = "3", default_name = "󰽫󰽻󰽩" })
-- gaming (Steam / Battle.net / launchers — see config/windowrules.lua)
hl.workspace_rule({ workspace = "4", default_name = "󰺵" })
-- Vesktop
hl.workspace_rule({ workspace = "6", default_name = "" })
-- Messenger
hl.workspace_rule({ workspace = "7", default_name = "󰣋" })
-- AI (Muse/Gemini/ChatGPT)
hl.workspace_rule({ workspace = "8", default_name = "󱚟" })
-- ── END HEXCIRI workspace names ──
