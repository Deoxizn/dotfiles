-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    -- Import the full session env into systemd + dbus (mirrors niri autostart).
    hl.exec_cmd("systemctl --user import-environment $(env | cut -d= -f1) && dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
end)

-- ── HEXCIRI autostart ──
-- Hexciri autostart (machine-managed section — see sync_hyprland).
-- Mirrors config/niri/cfg/autostart.kdl.

hl.on("hyprland.start", function()
    hl.exec_cmd("hexciri-theme-ensure")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
-- ── END HEXCIRI autostart ──
