-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { 0x6580daff, 0x3d58b2ff },
                angle = 45,
            },
            inactive_border = 0x616369ff,
        },
    },
    group = {
        col = {
            border_active = 0x6580daff,
            border_inactive = 0x616369ff,
            border_locked_active = 0x6580daff,
            border_locked_inactive = 0x616369ff,
        },
        groupbar = {
            col = {
                active = 0x6580daff,
                inactive = 0x616369ff,
                locked_active = 0x6580daff,
                locked_inactive = 0x616369ff,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 10,
        active_opacity = 0.98,
        inactive_opacity = 0.75,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            passes = 4,
            special = true,
        },
    },
})
