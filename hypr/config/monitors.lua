-- Monitors — THIS MACHINE (ported from niri monitors.kdl)
-- Desktop: ASUS VG28UQL1A 4K@144 (right) + Dell P2212H 1080p@60 portrait (left).
-- NOTE: this box enumerates them as DP-1 / HDMI-A-1 (the niri cfg said DP-4 /
-- HDMI-A-2 — older enumeration). Confirm names with `hyprctl monitors`.

-- ASUS VG28UQL1A — 4K at 144Hz, VRR on, scaled 1.33 (≈2887x1620 logical),
-- positioned to the right of the rotated 1080p portrait monitor.
-- HDR — recovered from dotfiles c8daeb7 ("fix hdr for gamescope and always
-- enable it"). 10-bit output + hdr preset; the sdr_* values control how SDR
-- content is tonemapped inside HDR mode. Dell below stays SDR.
hl.monitor({
    output   = MONITOR1,          -- "DP-1"
    mode     = "3840x2160@144",
    position = "1080x0",          -- left edge sits at x=1080 (portrait width)
    scale    = 1.33,
    vrr      = 1,                 -- variable-refresh-rate (tear-free in games)
    bitdepth = 10,                -- 10-bit output (required for HDR)
    cm       = "hdr",             -- HDR color management preset
    supports_hdr      = 1,
    sdr_min_luminance = 0.005,
    sdr_max_luminance = 203,
    sdrbrightness     = 1.0,
    sdrsaturation     = 1.0,
})

-- Dell P2212H — 1080p at 60Hz, rotated 90° (portrait), on the left.
hl.monitor({
    output    = MONITOR2,         -- "HDMI-A-1"
    mode      = "1920x1080@60",
    position  = "0x0",
    scale     = 1,
    transform = 1,                -- 1 = 90° clockwise (portrait)
})
