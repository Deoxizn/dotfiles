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
-- BEGIN omartia-dots-remux managed rounding (auto-synced by upgrade.sh)
-- Rounded corners matching Caelestia's panel aesthetic. Hyprland's rounding
-- is a single global value in physical px, so derive it from the highest
-- connected monitor scale (~12 logical px) and recompute on hotplug.
local function apply_rounding()
  local target, max_scale = 12, 1
  local ok, mons = pcall(hl.get_monitors)
  if ok and type(mons) == "table" then
    for _, m in ipairs(mons) do
      if (m.scale or 1) > max_scale then
        max_scale = m.scale
      end
    end
  end
  hl.config({ decoration = { rounding = math.floor(target * max_scale + 0.5) } })
end

apply_rounding()
hl.on("monitor.added", apply_rounding)
hl.on("monitor.removed", apply_rounding)
-- END omartia-dots-remux managed rounding

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
hl.config({
  scrolling = {
    -- Two columns split the screen exactly (2x 0.5 = 1.0). Below 0.5 the
    -- layout centers the pair, leaving dead space on both sides.
    column_width = 0.5,
  },
})

-- Cursor theme
hl.env("XCURSOR_THEME", "Future-dark-cursors")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme Future-dark-cursors")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
end)

-- FF/fastfetch terminal float (XF86Tools)
hl.window_rule({ match = { class = "org.omarchy.ff" }, float = true, size = { 1617, 600 } })

-- Floating windows (Tags)
hl.window_rule({
  match = {
    class = "org.omarchy.bluetui|org.omarchy.impala|org.omarchy.wiremix|org.omarchy.btop|org.omarchy.terminal|org.omarchy.bash|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|Omarchy|About|TUI.float|TUI.snaptui|imv|mpv"
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

-- Screensaver (power menu): fullscreen TTE art, same treatment as stock Omarchy
hl.window_rule({ match = { class = "org.omarchy.screensaver" }, fullscreen = true })
hl.window_rule({ match = { class = "org.omarchy.screensaver" }, float = true })
hl.window_rule({ match = { class = "org.omarchy.screensaver" }, animation = "slide" })

-- Brave: fully opaque windows (override global transparency)
hl.window_rule({ match = { class = "brave-origin.*" }, opacity = "1.0 override" })
