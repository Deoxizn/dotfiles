-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { 0xd2787dff, 0xaa5055ff },
                angle = 45,
            },
            inactive_border = 0x5f606cff,
        },
    },
    group = {
        col = {
            border_active = 0xd2787dff,
            border_inactive = 0x5f606cff,
            border_locked_active = 0xd2787dff,
            border_locked_inactive = 0x5f606cff,
        },
        groupbar = {
            col = {
                active = 0xd2787dff,
                inactive = 0x5f606cff,
                locked_active = 0xd2787dff,
                locked_inactive = 0x5f606cff,
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
