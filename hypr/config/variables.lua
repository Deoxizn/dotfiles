-- Device variables — THIS MACHINE (desktop: RTX 4080 SUPER + AMD iGPU)
-- Ported from niri fragments. Edit monitor outputs here, not in monitors.lua.

-- Default apps (from this device's niri keybinds.kdl)
TERMINAL     = "kitty"              -- Mod+Return opens terminal-smart.sh (kitty)
FILE_MANAGER = "~/.local/bin/strata" -- Mod+Shift+F
BROWSER      = "xdg-open https://"   -- Mod+Shift+B (default browser)
EDITOR       = "zeditor"             -- Mod+Shift+E (Zed)
CALCULATOR   = "gnome-calculator"

-- Monitors (this machine — see monitors.lua)
--   DP-1     = ASUS VG28UQL1A 4K@144  (right, primary)
--   HDMI-A-1 = Dell P2212H 1080p@60   (left, portrait)
MONITOR1 = "DP-1"
MONITOR2 = "HDMI-A-1"
PRIMARY_MONITOR = MONITOR1

-- Workspaces: flat 1..10 set (1-5 on DP-1, 6-10 on HDMI-A-1), so binds target
-- explicit workspace ids. NUM_WPM drives the relative/loop binds.
NUM_WPM = 10
