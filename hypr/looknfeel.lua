-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    -- Tighter gaps (Omarchy default was 5/10). Adjust to taste.
    gaps_in = 2,
    gaps_out = 2,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- Cursor theme
hl.env("XCURSOR_THEME", "Future-dark-cursors")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Future-dark-cursors")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
end)

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
-- Cursor theme
hl.env("XCURSOR_THEME", "Future-dark-cursors")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Future-dark-cursors")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
end)

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

-- Brave: fully opaque windows (override global transparency)
hl.window_rule({ match = { class = "brave-origin.*" }, opacity = "1.0 override" })
