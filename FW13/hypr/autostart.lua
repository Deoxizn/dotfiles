-- omartia-dots-remux: Autostart
-- Caelestia Shell replaces omarchy-shell (default autostart stubbed out in hyprland.lua)

hl.on("hyprland.start", function()
  -- Systemd / D-Bus environment setup
  hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")

  -- Launch Caelestia Shell via systemd (auto-restarts on crash or update)
  hl.exec_cmd("systemctl --user start caelestia-shell.service")

  -- omartia-dots-remux: hypridle drives screensaver + caelestia-system-lock (see hypridle.conf)
  hl.exec_cmd("uwsm-app -- hypridle")

  -- Omarchy services
  -- PolicyKit authentication agent (GUI privilege prompts)
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

  hl.exec_cmd("omarchy-provision-first-run")
  hl.exec_cmd("omarchy-powerprofiles-init")
  hl.exec_cmd(o.launch("omarchy-hyprland-monitor-watch"))
  hl.exec_cmd(o.launch("udiskie --automount --no-notify --no-tray"))

  -- Post-boot hooks
  hl.exec_cmd("sleep 2 && omarchy-hook post-boot")
end)
