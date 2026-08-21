-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

hl.config({
  input = {
    touchpad = {
      -- Use natural (inverse) scrolling.
      natural_scroll = true,

      -- omartia-dots-remux: classic two-button touchpad behavior.
      -- Bottom-right zone press = right click (button areas, not clickfinger);
      -- two-finger tap = right click, three-finger tap = middle; no middle-click emulation.
      clickfinger_behavior = false,
      tap_button_map = "LRM",
      middle_button_emulation = false,

      -- Disable the touchpad while typing.
      disable_while_typing = true,
    },
  },
})

hl.device({
  name = "pixa3854:00-093a:0274-touchpad",
  tap_button_map = "LRM",
})

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
