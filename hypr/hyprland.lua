-- Workspaces per monitor with scrolling layout
hl.workspace_rule("1", { monitor = "DP-1", layout = "scrolling", layoutopt = { direction = "right" } })
hl.workspace_rule("2", { monitor = "DP-1", layout = "scrolling", layoutopt = { direction = "right" } })
hl.workspace_rule("3", { monitor = "DP-1", layout = "scrolling", layoutopt = { direction = "right" } })
hl.workspace_rule("4", { monitor = "DP-1", layout = "scrolling", layoutopt = { direction = "right" } })
hl.workspace_rule("5", { monitor = "DP-1", layout = "scrolling", layoutopt = { direction = "right" } })

hl.workspace_rule("6", { monitor = "HDMI-A-1", layout = "scrolling", layoutopt = { direction = "down" } })
hl.workspace_rule("7", { monitor = "HDMI-A-1", layout = "scrolling", layoutopt = { direction = "down" } })
hl.workspace_rule("8", { monitor = "HDMI-A-1", layout = "scrolling", layoutopt = { direction = "down" } })
hl.workspace_rule("9", { monitor = "HDMI-A-1", layout = "scrolling", layoutopt = { direction = "down" } })
hl.workspace_rule("10", { monitor = "HDMI-A-1", layout = "scrolling", layoutopt = { direction = "down" } })

-- Launch Apps in Specific Workspaces
hl.window_rule({ match = { class = "zen|chromium|brave-browser" }, workspace = "1" })
hl.window_rule({ match = { class = "org.gnome.Nautilus|nautilus" }, workspace = "2" })
hl.window_rule({ match = { class = "discord|vesktop" }, workspace = "6" })
hl.window_rule({ match = { class = "spotify|Spotify" }, workspace = "3" })
hl.window_rule({ match = { class = "Battle.net|World of Warcraft|steam_app_default" }, workspace = "4" })
hl.window_rule({ match = { class = "com.github.th_ch.youtube_music" }, workspace = "3" })

-- Cursor theme
hl.env("XCURSOR_THEME", "Future-dark-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.exec_once("gsettings set org.gnome.desktop.interface cursor-theme Future-dark-cursors")
hl.exec_once("gsettings set org.gnome.desktop.interface cursor-size 24")

-- Terminal float
hl.window_rule({ match = { class = "kitty" }, float = true, size = { 1600, 600 } })

-- Floating windows (Tags)
hl.window_rule({
  match = {
    class = "org.omarchy.bluetui|org.omarchy.impala|org.omarchy.wiremix|org.omarchy.btop|org.omarchy.terminal|org.omarchy.bash|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|Omarchy|About|TUI.float|imv|mpv"
  },
  tag = "+floating-window"
})

hl.window_rule({
  match = {
    class = "xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus",
    title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)"
  },
  tag = "+floating-window"
})

-- Apply floating behavior to tagged windows
hl.window_rule({
  match = { tag = "floating-window" },
  float = true,
  size = { 1000, 720 },
  center = true
})

-- Calculator float
hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true })
