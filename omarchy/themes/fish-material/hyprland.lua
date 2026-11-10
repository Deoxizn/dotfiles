local active_border_color = "rgb(7694b7)"
local inactive_border_color = "rgba(595959aa)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  decoration = {
    active_opacity = 0.95,
    inactive_opacity = 0.85,
    rounding = 7,

    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      noise = 0.0,
      contrast = 1.07,
      brightness = 0.83,
      vibrancy = 0.23,
      vibrancy_darkness = 0.75,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },
})
