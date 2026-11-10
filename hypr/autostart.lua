-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Wayland has no primary-monitor concept; keep DP-1 marked as the XWayland
-- primary so X11/Proton games don't default to HDMI-A-1.
o.exec_on_start((os.getenv("HOME") or "") .. "/.config/hypr/scripts/xwayland-primary.sh")
