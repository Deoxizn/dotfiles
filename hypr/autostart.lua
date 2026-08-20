-- Extra autostart processes
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm-app -- hyprpaper")
  hl.exec_cmd("/home/deoxizn/appimg/openrgb/OpenRGB_1.0rc3_x86_64_6fbcf62.AppImage --profile \"deoxizn\" --startminimized")
  -- omartia-dots-remux: disabled (Caelestia provides bar)
  -- hl.exec_cmd("quickshell -n -p /home/deoxizn/.config/quickshell/bar")
end)

-- omartia-dots-remux: Caelestia Shell (auto-injected)
-- Replaces omarchy-shell (plugins disabled via shell.json)
-- Commands are chained to ensure env is imported BEFORE the service starts
-- After Caelestia starts, kill the omarchy shell (default autostart launches it)
hl.on("hyprland.start", function()
  hl.exec_cmd("bash -c 'systemctl --user import-environment $(env | cut -d\"=\" -f 1) && dbus-update-activation-environment --systemd --all && systemctl --user start caelestia-shell.service && sleep 3 && pkill -f \"quickshell -n -p .*/omarchy/shell\" 2>/dev/null'")
end)
