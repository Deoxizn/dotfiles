# Caelestia shell.json schema — full reference

Generated from the C++ config plugin source at
`~/.config/quickshell/caelestia/plugin/src/Caelestia/Config/*.hpp` (v2.3.0).
Every option below can appear in `~/.config/caelestia/shell.json` (global) and,
unless marked **GLOBAL**, in `~/.config/caelestia/monitors/<SCREEN>/shell.json`
(per-screen overlay). GLOBAL options are shared across all screens by design.

Legend: `PROP` = per-screen overridable, `GLOBAL` = ignores monitor overlays.

## Root (config.hpp — GlobalConfig)

- `enabled: bool = true` — master switch for this screen. `false` removes the
  screen from `Screens.screens` → no bar/background/drawers there. Only useful
  in monitor overlays.

## appearance (appearanceconfig.hpp)

- `deformScale: qreal = 1`
- `rounding.scale`, `spacing.scale`, `padding.scale` (qreal, default 1)
- `font.scale: qreal = 1`, `font.mono {family="JetBrainsMono Nerd Font" default on this machine}`
- `font.headline|title|body|label` → FontConfig `{family,size=14,weight,italic,vaxes}`
- `font.icon` → FontStyleConfig + `extraLarge` FontConfig
- `font.clock = "Rubik"`, `font.workspaces = "Rubik"`
- `anim.durations.scale: qreal` (GLOBAL)
- `transparency.enabled: bool = false` (GLOBAL), `transparency.base: 0.85` (GLOBAL),
  `transparency.layers: 0.4` (GLOBAL)

## general (generalconfig.hpp)

- `apps.terminal[]=["foot"]`, `apps.audio[]=["pwvucontrol"]`, `apps.playback[]=["mpv"]`, `apps.explorer[]=["thunar"]` (GLOBAL)
- `idle.lockBeforeSleep=true` (GLOBAL), `idle.inhibitWhenAudio=true` (GLOBAL),
  `idle.inhibitWhenCharging=false` (GLOBAL)
- `idle.timeouts[]` (GLOBAL): list of `{timeout, idleAction, returnAction?}` — defaults:
  180s→lock, 300s→`dpms off` (+return `dpms on`), 600s→`suspendThenHibernate`
- `battery.warnLevels[]` (GLOBAL): `{level,title,message,icon,critical?}` (20/10/5 defaults), `battery.criticalLevel=3` (GLOBAL)

## background (backgroundconfig.hpp)

- `enabled=true`, `wallpaperEnabled=true`
- `desktopClock.enabled=false`, `.scale=1.0`, `.position="bottom-right"`, `.invertColors=false`,
  `.background{enabled=false,opacity=0.7,blur=true}`, `.shadow{enabled=true,opacity=0.7,blur=0.4}`
- `visualiser.enabled=false`, `.autoHide=true`, `.blur=false`, `.rounding=1`, `.spacing=1`

## bar (barconfig.hpp)

- `persistent=true`, `showOnHover=true`, `dragThreshold=20`
- `excludedScreens: [regex strings]` — screen names to never show the bar on
- `scrollActions{workspaces=true,volume=true,brightness=true}`
- `popouts{activeWindow=true,tray=true,statusIcons=true}`
- `workspaces.shown=5`, `.activeIndicator=true`, `.occupiedBg=false`, `.showWindows=true`,
  `.showWindowsOnSpecialWorkspaces=true`, `.maxWindowIcons=5`, `.activeTrail=false`,
  `.perMonitorWorkspaces=true` (GLOBAL), `.label`, `.occupiedLabel`, `.activeLabel`,
  `.capitalisation="preserve"`, `.specialWorkspaceIcons[]` (GLOBAL), `.windowIcons[]` (GLOBAL)
- `activeWindow{compact=false,inverted=false,showOnHover=true}`
- `tray{background=false,recolour=false,compact=false}`, `tray.iconSubs[]` (GLOBAL),
  `tray.hiddenIcons[]` (GLOBAL)
- `clock{background=false,showDate=false,showIcon=true}`

## border (borderconfig.hpp)

- `thickness=10`, `rounding=25`, `smoothing=20`

## dashboard (dashboardconfig.hpp)

- `enabled=true`, `showOnHover=true`, `showDashboard=true`, `showMedia=true`,
  `showPerformance=true`, `showWeather=true`, `dragThreshold=50`
- `mediaUpdateInterval=500` (GLOBAL), `resourceUpdateInterval=1000` (GLOBAL)
- `performance{showBattery,showGpu,showCpu,showMemory,showStorage,showNetwork}` (all true)

## launcher (launcherconfig.hpp)

- `enabled=true`, `showOnHover=false`, `maxShown=7`, `maxWallpapers=9`
- `specialPrefix="@"`, `actionPrefix=">"`, `enableDangerousActions=false`, `vimKeybinds=false`
- `favouriteApps[]`, `hiddenApps[]` (this machine hides a long list incl. Basecamp/Discord/HEY webapps)
- `useFuzzy{apps,actions,schemes,variants,wallpapers}` (all false, GLOBAL)
- `actions[]` — default action list (see hpp for full table)

## lock (lockconfig.hpp)

- `enabled=true` — gates ONLY the lock UI card (`lockContent.visible` in LockSurface.qml);
  background always renders. Set false per-monitor for "blurred wallpaper only".
- `useWallpaper=false` — background source: screencopy of the screen (false) vs current
  wallpaper image (true)
- `recolourLogo=true`, `hideNotifs=false`
- `enableFprint=true`, `maxFprintTries=3`, `enableHowdy=true`, `maxHowdyTries=3`,
  `triggerHowdyOnWake=true` (all GLOBAL)

## nexus (nexusconfig.hpp)

- `wallpapersPerRow=4`, `maxNetworksShown=5`, `networkRescanInterval=15000`

## notifs (notifsconfig.hpp)

- `expire=true`, `fullscreen="on"` ("on"/"off"/"expire"), `defaultExpireTimeout=5000`,
  `fullscreenExpireTimeout=2000`, `clearThreshold=0.3`, `expandThreshold=20`,
  `actionOnClick=false`, `groupPreviewNum=3`, `openExpanded=false`

## osd (osdconfig.hpp)

- `enabled=true`, `hideDelay=2000`, `enableBrightness=true`, `enableMicrophone=false`

## services (serviceconfig.hpp) — ALL GLOBAL

- `weatherLocation`, `useFahrenheit`, `useFahrenheitPerformance=false`
- `gpuType` (e.g. "nvidia"/"amd"/"intel"), `visualiserBars=60`
- `audioIncrement=0.1`, `brightnessIncrement=0.1`, `maxVolume=1.0`
- `smartScheme=true` (auto dark/light from wallpaper), `defaultPlayer="Spotify"`,
  `playerAliases[]`, `lyricsBackend="Auto"`

## session (sessionconfig.hpp)

- `enabled=true`, `dragThreshold=30`, `vimKeybinds=false`
- `icons{logout="logout",shutdown="power_settings_new",hibernate="downloading",reboot="cached"}`
- `commands.logout[]=["loginctl","terminate-user","$USER"]` (this machine),
  `commands.shutdown[]=["poweroff"]`, `commands.hibernate[]=["hibernate"]`, `commands.reboot[]=["reboot"]`

## sidebar (sidebarconfig.hpp)

- `enabled=true`, `showOnHover=false`, `minHoverThreshold=200`, `dragThreshold=80`

## utilities (utilitiesconfig.hpp)

- `cards.recorder=true`, `cards.quickToggles=true`, `cards.keepAwake=true`
- `cards.vpn{provider[],selectedProvider=""}`
- `toasts` toggles: `configLoaded,chargingChanged,gameModeChanged,dndChanged,audioOutputChanged,
  audioInputChanged,capsLockChanged,numLockChanged,kbLayoutChanged,kbLimit,vpnChanged` (default true),
  `nowPlaying=false`; plus `fullscreen="off"` mode flag

## paths (userpaths.hpp)

- `lyricsDir=~/Music/Lyrics/` (GLOBAL)
- `sessionGif="root:/assets/kurukuru.gif"`, `mediaGif="root:/assets/bongocat.gif"`,
  `noNotifsPic="root:/assets/dino.png"`, `lockNoNotifsPic="root:/assets/dino.png"`
  (`root:/` resolves into the shell checkout's assets/)

## winfo (winfoconfig.hpp)

- Empty today (placeholder section).
