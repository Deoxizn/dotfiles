-- Input — THIS MACHINE (ported from niri input.kdl)
-- Desktop, so touchpad block is kept for completeness but is a no-op here.

hl.config({
    input = {
        kb_layout = "us",            -- Keyboard layout
        -- kb_options = "ctrl:nocaps", -- Uncomment to make CapsLock act as Ctrl
        numlock_by_default = true,   -- Enable Num Lock on startup (niri: numlock)
        accel_profile = "flat",      -- No mouse acceleration
        -- follow_mouse = 1,         -- Focus follows mouse (niri: focus-follows-mouse, off)
        -- scroll_factor = 3,        -- Multiply scroll speed (niri, commented)
        touchpad = {
            tap_to_click = true,        -- niri: tap
            natural_scroll = true,      -- niri: natural-scroll
            -- disable_while_typing is on by default (niri default too)
        },
    },
    cursor = {
        hide_on_key_press = true,       -- niri: hide-when-typing
        inactive_timeout = 1.0,         -- niri: hide-after-inactive-ms 1000
    },
})
