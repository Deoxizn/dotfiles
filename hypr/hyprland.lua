-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Omarchy tags mpv as a generic floating window, and the tag carries a fixed
-- 875x600 size that overrides mpv's autofit-larger (the window stops following
-- the video's resolution). Drop mpv from the default "+floating-window" tag
-- list before Omarchy loads; hypr/windowrules.lua floats and centers it instead.
-- Written as a wrapper so it survives Omarchy updates (and fails safe: worst
-- case mpv just goes back to the 875x600 default float).
require("default.hypr.helpers")
local omarchy_window = o.window
o.window = function(match, rules)
  if type(match) == "string" and rules and rules.tag == "+floating-window" then
    local stripped = match:gsub("|mpv", "")
    if stripped ~= match then
      return omarchy_window(stripped, rules)
    end
  end
  return omarchy_window(match, rules)
end

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.windowrules")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
