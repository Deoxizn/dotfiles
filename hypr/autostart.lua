-- Extra autostart processes
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm-app -- hyprpaper")
  -- stellarchy-dots-remux: hypridle drives screensaver + caelestia-system-lock (see hypridle.conf)
  hl.exec_cmd("uwsm-app -- hypridle")
  hl.exec_cmd("/home/deoxizn/appimg/openrgb/OpenRGB_1.0rc3_x86_64_6fbcf62.AppImage --profile \"/home/deoxizn/.config/OpenRGB/deoxizn.orp\"")
  -- stellarchy-dots-remux: disabled (Caelestia provides bar)
  -- hl.exec_cmd("quickshell -n -p /home/deoxizn/.config/quickshell/bar")
end)

-- stellarchy-dots-remux: Caelestia Shell (auto-injected)
-- Replaces omarchy-shell. The default autostart is stubbed out in
-- hyprland.lua, so the non-shell parts it used to launch are replicated here.
hl.on("hyprland.start", function()
  hl.exec_cmd("bash -c 'systemctl --user import-environment $(env | cut -d\"=\" -f 1) && dbus-update-activation-environment --systemd --all && systemctl --user start caelestia-shell.service'")
  hl.exec_cmd("omarchy-provision-first-run")
  hl.exec_cmd("omarchy-powerprofiles-init")
  hl.exec_cmd(o.launch("omarchy-hyprland-monitor-watch"))
  hl.exec_cmd(o.launch("udiskie --automount --no-notify --no-tray"))
  hl.exec_cmd("sleep 2 && omarchy-hook post-boot")
end)
