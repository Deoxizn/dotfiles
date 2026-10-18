-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 0,                     -- no gaps — windows sit flush (was 3/8)
        gaps_out = 0,
        border_size = 0,                 -- borders off (niri looknfeel: no visible border)
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { 0x798186ff, 0x51595eff },
                angle = 45,
            },
            inactive_border = 0x63666dff,
        },
    },
    group = {
        col = {
            border_active = 0x798186ff,
            border_inactive = 0x63666dff,
            border_locked_active = 0x798186ff,
            border_locked_inactive = 0x63666dff,
        },
        groupbar = {
            col = {
                active = 0x798186ff,
                inactive = 0x63666dff,
                locked_active = 0x798186ff,
                locked_inactive = 0x63666dff,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 10,
        active_opacity = 0.95,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            passes = 4,
            special = true,
        },
    },
})
