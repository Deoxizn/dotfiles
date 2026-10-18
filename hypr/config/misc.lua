hl.config({
    dwindle = {
        preserve_split = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    misc = {
        col = {
            splash = CACHYLGREEN,
        },
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
        vrr = 3,
    },
    render = {
        direct_scanout = 2,
        -- Use the option below if you find games constantly black screening for a couple seconds whenever direct scanout enables/disables
        -- non_shader_cm = 0,
    },
    xwayland = {
        force_zero_scaling = true
    },
})

-- ── HEXCIRI layout ──
hl.config({
    general = {
        layout = "scrolling",
    },
})
-- ── END HEXCIRI layout ──

-- ── HEXCIRI focus ──
hl.config({
    misc = {
        focus_on_activate = true,
    },
})
-- ── END HEXCIRI focus ──

-- ── HEXCIRI dpms wake ──
-- Without these, `dpms off` is a one-way trip: monitors go dark and NO input
-- brings them back (the whole point of hexciri-lock's panel-off loop is that
-- a bump of the mouse re-lights them). Both default to false here, so the
-- lock loop's power-off left the session on a black screen that only a
-- compositor restart cleared. Re-enable wake-on-input explicitly.
hl.config({
    misc = {
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
    },
})
-- ── END HEXCIRI dpms wake ──
