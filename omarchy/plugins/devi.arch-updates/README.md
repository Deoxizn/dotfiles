# Arch Updates
Icon badge for the Omarchy quattro bar. Package icon when clean
(dimmed), package-variant icon plus count when updates are waiting.

## What it shows

- Bar pill: package icon () when up to date (dimmed), package-variant icon (󰏖) plus `N` when N updates are pending.
- Tooltip: the breakdown, e.g. `Repo: 8 · AUR: 4 · Mise: 2 · Plugins: 1 · Themes: 0 · Click to update`.
- Left click: opens `omarchy update` in your default terminal (via `xdg-terminal-exec`).
- Middle click: forces an immediate recheck.

## How it checks

`check-updates.sh` counts pending updates and prints
`<total> <repo> <aur> <mise> <plugins> <themes>`:

- Repo: `checkupdates` (from pacman-contrib).
- AUR: `yay -Qua` (falls back to `paru -Qua`).
- Mise: `mise outdated --json` (with `MISE_MINIMUM_RELEASE_AGE=0`, so the
  count matches what an update installs; falls back to plain `mise outdated`
  when `jq` is not installed).
- Shell plugins: git checkouts in `~/.config/omarchy/plugins` whose tracked
  branch is behind after a fetch (same approach as techspawn.updates).
- Themes: git themes from `omarchy-theme-extras` whose upstream branch is
  behind after a fetch.

Checking only counts; nothing here installs anything. Click runs
`omarchy update`, which covers system, AUR, and mise. Shell plugins and
themes are counted here but updated separately (`omarchy plugin update`,
theme git pull), so the badge can still show those after an `omarchy update`
until they are updated.

Mise, plugin, and theme counting was inspired by
[techspawn.updates](https://github.com/RajShimpi/omarchy-updates) (MIT).

## Install

```bash
omarchy plugin add https://github.com/Deoxizn/Arch-Updates.git --enable
chmod +x ~/.config/omarchy/plugins/devi.arch-updates/check-updates.sh
command -v checkupdates || omarchy-pkg-add pacman-contrib
omarchy restart shell
```

If you installed the tarball manually first, remove
`~/.config/omarchy/plugins/devi.arch-updates/` before the `plugin add`
so the clone lands clean. If the pill doesn't appear on the right,
place it with `omarchy bar put devi.arch-updates --section right`.

## Settings

Check interval: edit `intervalMinutes` at the top of `BarWidget.qml`
(minutes between checks, default 60), then restart the shell if it does
not pick it up live.

Update command: `updateCommand` at the top of `BarWidget.qml` runs
`omarchy update` in your default terminal via `xdg-terminal-exec`;
edit it to pin a specific terminal (e.g. `kitty omarchy update`).

## Notes

- First check can take a while: `checkupdates` syncs the package
  databases, the AUR query takes a moment, and plugin/theme checks fetch
  each git remote.
- If you renamed the plugin directory, update the script path in
  `BarWidget.qml` (`checkProc.command`) to match.
- Designed for a horizontal (top/bottom) bar. The pill follows the bar
  font like any other widget, and the icons are Nerd Font glyphs, so the
  bar monospace font needs to be a Nerd Fonts v3 font. The package-variant
  icon lives in the supplementary plane (U+F03D6), so an older v2 Nerd
  Font will show the clean icon and a box for the pending icon.
- If your bar hides non-workspace widgets on a secondary monitor, this
  badge only appears on the monitors that show the full bar.
