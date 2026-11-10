# Changelog

## [1.4.4](https://github.com/Deoxizn/omawall) (2026-11-03, fork)

### Bug Fixes

* The background service loads again after Omarchy removed
  `ScreenMoveRemap` on 2026-11-01, when Hyprland 0.57 started moving
  layer surfaces with their monitor. The leftover reference made the
  whole service fail with "ScreenMoveRemap is not a type", so no
  wallpaper was drawn on either display and the panel reported no
  outputs. The guard is gone, matching the built-in background service.

## [1.4.3](https://github.com/Deoxizn/omawall) (2026-10-29, fork)

### Bug Fixes

* The background service now finds the plugin's settings in any bar
  section (tray, centerEnd, centerBegin, …), not just left/center/right.
  A widget in tray previously looked fine in the panel while the service
  saw no folder at all and reported "No images found in that folder".
* Browse no longer tries zenity at all: it opens the built-in panel
  folder browser directly, so a Strata portal routing zenity's dialog
  can no longer turn Browse into just opening Strata.

## [1.4.2](https://github.com/Deoxizn/omawall) (2026-10-29, fork)

### Bug Fixes

* Browse no longer depends on zenity/Nautilus: falls back to a built-in
  panel folder browser, and picker failures are shown in the panel.
* Single-mode thumbnails load for `~/…` folders and filenames with spaces
  or special characters; the grid loads on panel open and reports empty.
* Switching to Single now pins the image on screen, and a "Pin current
  wallpaper" button covers the old unpinned case, so the image survives
  a shell restart instead of resetting.
* A display in Single mode with no pin saved keeps its current image on
  rescan instead of dropping it.

## [1.4.1](https://github.com/matjam/omawall/compare/v1.4.0...v1.4.1) (2026-09-15)


### Bug Fixes

* integrate scoped shell compatibility improvements ([ff4144f](https://github.com/matjam/omawall/commit/ff4144f69798265affa24a499e032a434e4e3147))
* restore wallpaper settings with scoped shell API ([759b81f](https://github.com/matjam/omawall/commit/759b81f33c425b61198cd08cca50855d5611f668))

## [1.4.0](https://github.com/matjam/omawall/compare/v1.3.0...v1.4.0) (2026-08-12)


### Bug Fixes

* stop reshuffling when another plugin saves a setting ([39002d2](https://github.com/matjam/omawall/commit/39002d29f849c1a90443f62f79e6cd9fb97c7ebf))

## [1.3.0](https://github.com/matjam/omawall/compare/v1.2.0...v1.3.0) (2026-08-12)


### Features

* next image, and a hover card showing what is coming ([7bd5748](https://github.com/matjam/omawall/commit/7bd5748c26da15f0a29ee4b05e81c1835a2cbb03))

## [1.2.0](https://github.com/matjam/omawall/compare/v1.1.0...v1.2.0) (2026-08-11)


### Features

* add Pixabay as a wallpaper source ([862823e](https://github.com/matjam/omawall/commit/862823e60d30b887238ee627fbf2268c215b9b98))
* per-display single mode and scaling ([ce2f12e](https://github.com/matjam/omawall/commit/ce2f12e00b96a8083d4c0edb73651d91f4abf108))
* tabbed panel with per-display settings ([2102d22](https://github.com/matjam/omawall/commit/2102d224db29988eb1d46a16e74ba8edf6352388))


### Bug Fixes

* stop the advisory CI step from failing the build ([b914eaf](https://github.com/matjam/omawall/commit/b914eaf4bc03e71f235cc53963aa8b08d32af1e7))
* write display settings to the display shown as selected ([191b059](https://github.com/matjam/omawall/commit/191b059bb7bac1599618061c205d7b7c21fe3b2f))
