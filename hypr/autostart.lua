-- Extra autostart processes
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm-app -- hyprpaper")
  hl.exec_cmd("/home/deoxizn/appimg/openrgb/OpenRGB_1.0rc3_x86_64_6fbcf62.AppImage --profile \"deoxizn\" --startminimized")
end)
