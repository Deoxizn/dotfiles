-- Hexciri autostart overlay for Hyprland.
-- Runs alongside the stock autostart (see config/autostart.lua): the stock
-- file owns noctalia + dbus env; this file owns the hexciri layer needs.
-- Mirrors config/niri/cfg/autostart.kdl.

hl.on("hyprland.start", function()
    hl.exec_cmd("hexciri-theme-ensure")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
