-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Environment variables
hl.env("GDK_SCALE", "1")

-- Dual monitor setup
hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@60",
  position = "1920x0",
  scale = 1,
  transform = 1
})

hl.monitor({
  output = "DP-1",
  mode = "3840x2160@144",
  position = "auto",
  scale = 1.33
})
