---
name: omarchy-theme
description: Expert knowledge for creating Omarchy themes in Omarchy 4.5: colors.toml palettes, backgrounds, Plymouth boot logos, animated wallpapers, and the theme install/update flow. Use when building, fixing, or reviewing a theme.
---

# Omarchy Theme Agent

You are an expert Omarchy Theme Designer. Your goal is to generate valid, harmonious, and functional themes for the Omarchy Linux desktop (Omarchy 4.5).

Current as of 2026-11: **Omarchy 4.5** is current. Themes are defined by
**`colors.toml`**, not `theme.json` — there is no JSON manifest, no
`schemaVersion`, and no 24-color set. The palette is a flat TOML key list:
semantic background/foreground/accent keys, a `color0`–`color15` ANSI block,
and border/signal/data slots (Bloom Protocol 4.5 model). A machine-level
`~/.config/omarchy/shell.toml` override merges over the active theme and
survives theme switching.

Reference build: `Deoxizn/omarchy-nyarch-theme` (baby blue on black, 4 stills,
animated loop, intro clip, Plymouth boot logo). A theme must work on install
with no manual steps; an `install.sh` is only for optional privileged extras
(Plymouth set, Flatpak apps).

## 0. Reference Documentation & Resources
- **Quickshell Documentation**: https://quickshell.org/docs/ — QML styling properties, color bindings, dynamic property resolution.
- **Quickshell GitHub Repository**: https://github.com/outfoxxed/quickshell

## 1. Theme Folder Layout
User and system themes live in `~/.config/omarchy/themes/<theme-id>/`.

| File | What it is |
|---|---|
| `colors.toml` | The theme. Flat TOML palette, see §2. Required. |
| `.omarchy-theme.yml` | Registry metadata, e.g. `gallery: true` + `category: novelty`. |
| `backgrounds/` | Stills (`.jpg`/`.png`) plus loop video and `intros/` clip, see §5. |
| `preview.png` | Theme picker card. Use a real desktop screenshot (1280x720), not just a wallpaper. |
| `unlock.png` | **Plymouth boot logo only.** See §4, it is not the lock screen. |
| `preview-unlock.png` | Required for the theme to appear in Appearance > Unlock picker. Copy of `unlock.png`. |
| `shell.toml` / `shell.lock.toml` | Shell tweaks shipped with the theme. |
| `hyprland.conf` / `hyprland.lua` | Window/border rules shipped with the theme. |
| `btop.theme` / `icons.theme` / `keyboard.rgb` | App theming shipped with the theme. |
| `install.sh` | Optional extras only, never required for the theme itself. |

## 2. Palette (`colors.toml`)
Flat TOML, no sections. Keys from the nyarch build (all hex unless noted):

```toml
mode = "dark"
theme_type = "dark"

background = "#12161a"
dark_background = "#0d1114"
darker_background = "#090c0e"
lighter_background = "#1c2329"

foreground = "#d6e8ec"
dark_foreground = "#7a8f99"
light_foreground = "#e8f4f7"
bright_foreground = "#f2fbff"

accent = "#7cc7e8"
cursor = "#e8f4f7"
active_border_color = "#7cc7e8"
selection = "#1e3a4a"
selection_background = "#1e3a4a"
selection_foreground = "#e8f4f7"
muted = "#5a6b76"

red = "#ff5c7a"
yellow = "#ffd479"
orange = "#ff9e64"
green = "#7ddba3"
cyan = "#7cc7e8"
blue = "#4da3d8"
magenta = "#c084fc"
purple = "#c084fc"
brown = "#8a6d5c"

bright_red = "#ff8fa3"
bright_yellow = "#ffe08a"
bright_green = "#9be8c0"
bright_cyan = "#a5dcf5"
bright_blue = "#8ec9ee"
bright_magenta = "#d8b4fe"
bright_purple = "#d8b4fe"

warning = "#ffd479"
success = "#7ddba3"
signal = "#7cc7e8"
data = "#7a8f99"
border = "#2c3949"

hyprland_active_border = "rgba(7cc7e8ff) rgba(4da3d8ff) rgba(c084fcff) 45deg"
hyprland_inactive_border = "#2c3949"

color0 = "#12161a"
color1 = "#ff5c7a"
color2 = "#7ddba3"
color3 = "#ffd479"
color4 = "#4da3d8"
color5 = "#c084fc"
color6 = "#7cc7e8"
color7 = "#d6e8ec"
color8 = "#5a6b76"
color9 = "#ff8fa3"
color10 = "#9be8c0"
color11 = "#ffe08a"
color12 = "#8ec9ee"
color13 = "#d8b4fe"
color14 = "#a5dcf5"
color15 = "#f2fbff"
```

## 3. Install, Set, Update
```sh
omarchy theme install https://github.com/<user>/<theme>
omarchy theme set <theme-id>
```

Gotcha: `omarchy theme update` only does a `git pull` in the repo folder, it
does **not** re-stage the theme. The wallpaper picker reads the staged copy at
`~/.local/state/omarchy/current/theme/backgrounds/`, so new backgrounds will
not show until you re-run `omarchy theme set <theme-id>`. Confirm with
`ls ~/.local/state/omarchy/current/theme/backgrounds/` before opening the picker.

## 4. Boot Logo (`unlock.png`) vs Lock Screen
Verified against Omarchy source, 2026-11-13: `unlock.png` is the **Plymouth
boot logo only**, consumed by `omarchy plymouth set by theme <theme>`. The 4.5
lock screen has no badge image, it just shows the current wallpaper.

- Plymouth is set once and is independent of the active desktop theme: switch
  desktop themes freely, the boot logo stays until you set Plymouth again.
- A minimal theme folder works as a boot-logo carrier: just `colors.toml`
  plus `unlock.png` under `~/.config/omarchy/themes/<id>/`.
- The Unlock picker (Appearance > Unlock) only lists themes that have a
  `preview-unlock.png` in the folder. Copy `unlock.png` to
  `preview-unlock.png` or the theme is skipped.
- Art note: use the full original image for unlock art, do not crop it.
  Transparent PNGs sit clean on the boot background; square full-body art
  renders small, a wide/landscape composition reads better at boot size.

## 5. Backgrounds: Stills, Loops, Intros
- Stills live directly in `backgrounds/` and appear in the picker
  (`Super + Ctrl + W`).
- Loop video: `backgrounds/<name>-loop.mp4`, played natively by OWE in 4.5.
  Specs: H.264, `yuv420p`, `+faststart` (moov up front), no audio track,
  1248x704, 24 fps, ~10 s. Set directly with
  `omarchy theme bg set "$HOME/.config/omarchy/themes/<id>/backgrounds/<loop>.mp4"`.
- Intro clip: `backgrounds/intros/<name>.mp4`, ~5 s. Plays on login and on
  theme switch, then settles on the still, never loops. Disable under
  Appearance > Animations, or `omarchy theme bg intro toggle`.
- Registry limit: 50 MiB per file. Keep loops well under it.
- Seam stutter workaround (local only, do not ship): extend the loop so the
  player seeks once every couple of minutes instead of every 10 s:
  `ffmpeg -stream_loop 11 -i <loop>.mp4 -c copy /tmp/<name>-loop-long.mp4`.

## 6. Verification
- After any push, verify the live bytes match (commit hash + byte size), never
  push binaries through the GitHub connector (it stores them as base64 text);
  use the GitHub web upload UI or a local git push for PNG/MP4 files.
- After a theme update, re-stage with `omarchy theme set` and check the staged
  `backgrounds/` listing before declaring it done.
