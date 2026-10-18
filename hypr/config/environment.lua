-- Environmental variables (for reference https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/)
-- if you use UWSM, define your variables in ~/.config/uwsm/env
-- if you don't use UWSM, define your variables here (e.g. hl.env("QT_QPA_PLATFORM", "wayland"))

-- if you have an NVIDIA GPU uncomment the following lines:

-- hl.env("GBM_BACKEND", "nvidia-drm") -- force GBM as a backend
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia") -- force GBM as a backend
-- hl.env("LIBVA_DRIVER_NAME", "nvidia") -- Hardware acceleration on NVIDIA GPUs
-- hl.env("__GL_GSYNC_ALLOWED", "1") -- Controls if your GPU supports VRR

-- ── HEXCIRI PATH ──
-- ~/.local/bin is NOT in the systemd/uwsm session PATH (only in the fish
-- interactive PATH), so every hexciri-* binary was unreachable from binds —
-- Mod+Esc / Mod+Alt+Space / Mod+Ctrl+L spawned "command not found" and nothing
-- appeared. Prepend it here so it applies to every process Hyprland spawns.
-- Guarded: config reloads re-run this, so skip when already present to avoid
-- stacking duplicate entries.
local _path = os.getenv("PATH") or ""
if not _path:find("/home/devi/.local/bin", 1, true) then
    hl.env("PATH", "/home/devi/.local/bin:" .. _path)
end
-- ── END HEXCIRI PATH ──
