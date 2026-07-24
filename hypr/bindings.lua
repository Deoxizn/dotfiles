-- Unbind keys
hl.unbind("SUPER + W")
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + SHIFT + M")
hl.unbind("SUPER + P")
hl.unbind("SUPER + A")

-- Application bindings
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("uwsm-app -- xdg-terminal-exec --dir=\"$(omarchy-cmd-terminal-cwd)\""), { description = "Terminal" })
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("uwsm-app -- nautilus --new-window"), { description = "File manager" })
hl.bind("SUPER + ALT + SHIFT + F", hl.dsp.exec_cmd("uwsm-app -- nautilus --new-window \"$(omarchy-cmd-terminal-cwd)\""), { description = "File manager (cwd)" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("omarchy-launch-browser"), { description = "Browser" })
hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd("omarchy-launch-browser --private"), { description = "Browser (private)" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("omarchy-launch-editor"), { description = "Editor" })
hl.bind("SUPER + CTRL + D", hl.dsp.exec_cmd("hyprctl dispatch workspace 6 && vesktop"), { description = "Vesktop" })
hl.bind("SUPER + CTRL + M", hl.dsp.exec_cmd("hyprctl dispatch workspace 6 && omarchy-launch-webapp \"https://www.messenger.com\""), { description = "Messenger" })
hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd("uwsm-app -- xdg-terminal-exec --dir=\"$(omarchy-cmd-terminal-cwd)\" tmux"), { description = "Tmux" })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("hyprctl dispatch workspace 3 && spotify"), { description = "Music" })

-- Custom media / F-key bindings
hl.bind("XF86Tools", hl.dsp.exec_cmd("kitty fish -c \"ff; exec fish\""))
hl.bind("XF86Launch5", hl.dsp.exec_cmd("omarchy-launch-webapp \"https://gemini.google.com/app\""))
hl.bind("XF86Launch6", hl.dsp.exec_cmd("omarchy-launch-webapp \"https://photopea.com\""))
hl.bind("XF86Launch7", hl.dsp.exec_cmd("omarchy-launch-webapp \"https://learn.omacom.io/2/the-omarchy-manual\""))

-- Kill active window
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })

-- Reload wallpaper / hyprpaper
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd("pkill -x hyprpaper && setsid uwsm-app -- hyprpaper -c ~/.config/hypr/hyprpaper.conf >/dev/null 2>&1 &"), { description = "Reload hyprpaper" })
