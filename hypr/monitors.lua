-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Managed by im0001gt.screens (Screens bar panel).

local omarchy_gdk_scale = 1
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- BEGIN im0001gt.screens
hl.monitor({ output = "desc:Dell Inc. DELL P2212H 174R737OC7CM", mode = "1920x1080@60.00", position = "0x0", scale = 1, transform = 1, vrr = 0 })
hl.monitor({ output = "desc:ASUSTek COMPUTER INC VG28UQL1A SBLMTF015615", mode = "3840x2160@144.00", position = "1080x0", scale = 1.333, vrr = 1, bitdepth = 10, supports_hdr = 1, cm = "hdr", sdr_min_luminance = 0.005, sdr_max_luminance = 203, sdrbrightness = 1, min_luminance = 0.0199, max_luminance = 400, max_avg_luminance = 400 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.config({ misc = { vrr = 1 }, render = { cm_auto_hdr = 0 } })
-- END im0001gt.screens

