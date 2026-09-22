-- Input configuration

hl.config({
    input = {
        -- sensitivity = -0.25,
        accel_profile = "flat",
        -- MACHINE CUSTOM 2026-09-22 (ported from niri backup): tap-to-click
        -- and disable-while-typing are already Hyprland defaults; slower
        -- scroll + natural direction carry over.
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.4,
        },
    },
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    -- cursor = {
    --     no_hardware_cursors = 1,
    -- },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
