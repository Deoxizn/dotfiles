-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Swap SUPER+SPACE and SUPER+ALT+SPACE bindings.
hl.unbind("SUPER + SPACE")
hl.unbind("SUPER + ALT + SPACE")
o.bind("SUPER + SPACE", "Apps", "omarchy-shell omarchy.dock apps")
o.bind("SUPER + ALT + SPACE", "Omarchy menu", { menu = "root" })

-- Use SUPER+Q instead of SUPER+W to close windows.
hl.unbind("SUPER + W")

-- strata-installer: file-manager start
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + SHIFT + F", "File manager", { launch = "/home/devi/.local/bin/strata" })
o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)",
  "uwsm-app -- /home/devi/.local/bin/strata \"$(omarchy-cmd-terminal-cwd)\"")
-- strata-installer: file-manager end

-- Ported bindings from dotfiles (adapted to Omarchy).
o.bind("SUPER + U", "Previous workspace", hl.dsp.focus({ workspace = "m-1" }))
o.bind("SUPER + I", "Next workspace", hl.dsp.focus({ workspace = "m+1" }))
o.bind("CTRL + PRINT", "Screenshot to clipboard", "grim - | wl-copy")
o.bind("XF86Tools", "Fastfetch", "kitty --class app.fastfetch -o 'font_family=Ransom Mono Unruly NF' -o font_size=10 fish -c \"fastfetch; exec fish\"")
o.bind("XF86Launch5", "Muse", { webapp = "https://muse.ai", focus = true })
o.bind("XF86Launch6", "Photopea", { webapp = "https://www.photopea.com" })
o.bind("SUPER + SHIFT + R", "Restart shell", "omarchy restart shell")

-- Apps
hl.unbind("SUPER + RETURN")
o.bind("SUPER + SHIFT + M", "Music", { omarchy = "spotify" })
o.bind("SUPER + CTRL + M", "Messenger", { webapp = "https://www.messenger.com", focus = true })
o.bind("SUPER + CTRL + D", "Vesktop", { launch = "vesktop" })
o.bind("SUPER + RETURN", "Terminal", "/home/devi/.config/hypr/scripts/terminal-smart.sh")

-- BEGIN im0001gt.screens
hl.unbind("SUPER + SLASH")
hl.unbind("SUPER + ALT + SLASH")
o.bind("SUPER + SLASH", "Monitor scaling up", "/home/devi/.config/omarchy/plugins/im0001gt.screens/scripts/display-ctl scale up")
o.bind("SUPER + ALT + SLASH", "Monitor scaling down", "/home/devi/.config/omarchy/plugins/im0001gt.screens/scripts/display-ctl scale down")
-- END im0001gt.screens
