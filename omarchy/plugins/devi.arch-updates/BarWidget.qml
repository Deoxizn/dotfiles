import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

// Arch Updates: icon badge for pending updates.
// No updates: nf-oct-package. Updates: nf-md-package_variant + count.
//
// Why this failed on Caelestia and should work on Omarchy:
// Caelestia draws bar icons with Material Symbols Rounded and bar text
// with Rubik, neither of which contains Nerd Font private-use glyphs, so
// a Nerd glyph pasted into a Caelestia module had no font to fall back
// to. Omarchy's bar text uses the system monospace font, and upstream
// Omarchy's monospace is a Nerd Font, so the same glyphs have a font
// to resolve against. The second glyph is the catch: it lives in the
// supplementary plane, U+F03D6, so it needs a Nerd Fonts v3 font. An
// older v2 Nerd Font will show the first icon and tofu on the second.
// Test on the live bar before pushing: if the second icon is a box,
// the font is the problem, not the codes.
//
// Glyphs are written literally here on purpose. Writing the second one
// as "\udb80\udfd6" is also correct QML, but that escape has been
// mangled by JSON/shell layers before, while a literal UTF-8 glyph
// survives a plain file copy. Codes, for reference:
//   no updates: nf-oct-package, U+F487, \uf487
//   updates:    nf-md-package_variant, U+F03D6, \udb80\udfd6
//
// How it works: check-updates.sh counts repo (checkupdates), AUR
// (yay/paru -Qua), mise dev tools (mise outdated), git shell plugins
// (tracked branch behind) and git themes (upstream behind), and prints
// "<total> <repo> <aur> <mise> <plugins> <themes>". This widget polls it on
// a timer, shows the icon plus total as a badge, and puts the breakdown
// in the tooltip. Left click opens the updater, middle click forces a
// refresh.
//
// Settings: edit intervalMinutes below (minutes between checks). Default 60.
// If you rename this plugin, update the script path in checkProc.command.

BarWidget {
  id: root
  moduleName: "devi.arch-updates"

  // Command run on left click. Uses Omarchy's presentation wrapper, same
  // as the stock SystemUpdate widget: it shows the Omarchy logo, runs the
  // update, then waits for a keypress on Done/Failed, so the terminal
  // stays open after a clean run instead of closing the second the
  // update exits. Plain xdg-terminal-exec closed instantly on success,
  // which looked like a crash at the AUR stage (the last step).
  // Note: omarchy update covers system, AUR and mise. Shell plugins and
  // themes are counted here but updated separately (omarchy plugin update,
  // theme git pull), so the badge can still show those after an update.
  property string updateCommand: "omarchy-launch-floating-terminal-with-presentation omarchy update"

  // Minutes between update checks. Change this number to suit.
  property int intervalMinutes: 60

  // Nerd Font icons, literal UTF-8 glyphs, see header comment.
  property string noUpdatesIcon: ""
  property string updatesIcon: "󰏖"

  property int totalCount: 0
  property int repoCount: 0
  property int aurCount: 0
  property int miseCount: 0
  property int pluginsCount: 0
  property int themesCount: 0
  property bool checked: false

  readonly property bool hasUpdates: root.totalCount > 0

  implicitWidth: badge.implicitWidth
  implicitHeight: badge.implicitHeight

  function runCheck() {
    if (!checkProc.running) checkProc.running = true
  }

  Process {
    id: checkProc
    // Run via bash so the check works even if the script loses its
    // executable bit on a plugin update (git does not always preserve it).
    command: ["bash", Quickshell.env("HOME") + "/.config/omarchy/plugins/devi.arch-updates/check-updates.sh"]
    stdout: StdioCollector {
      onStreamFinished: {
        var parts = String(text || "").trim().split(/\s+/)
        if (parts.length !== 3 && parts.length !== 6) return
        var total = parseInt(parts[0], 10)
        var repo = parseInt(parts[1], 10)
        var aur = parseInt(parts[2], 10)
        var mise = parts.length === 6 ? parseInt(parts[3], 10) : 0
        var plugins = parts.length === 6 ? parseInt(parts[4], 10) : 0
        var themes = parts.length === 6 ? parseInt(parts[5], 10) : 0
        if (isNaN(total) || isNaN(repo) || isNaN(aur) || isNaN(mise) || isNaN(plugins) || isNaN(themes)) return
        root.totalCount = total
        root.repoCount = repo
        root.aurCount = aur
        root.miseCount = mise
        root.pluginsCount = plugins
        root.themesCount = themes
        root.checked = true
      }
    }
  }

  Timer {
    id: checkTimer
    interval: root.intervalMinutes * 60000
    running: true
    repeat: true
    onTriggered: root.runCheck()
  }

  Component.onCompleted: root.runCheck()

  WidgetButton {
    id: badge
    bar: root.bar
    text: root.hasUpdates ? root.updatesIcon + " " + root.totalCount : root.noUpdatesIcon
    opacity: root.hasUpdates ? 1 : 0.45
    horizontalMargin: 8
    verticalPadding: 6
    fixedHeight: root.barSize
    tooltipText: !root.checked ? "Checking for updates…"
      : root.hasUpdates ? "Repo: " + root.repoCount + " · AUR: " + root.aurCount + " · Mise: " + root.miseCount + " · Plugins: " + root.pluginsCount + " · Themes: " + root.themesCount + " · Click to update"
      : "No updates pending · Click to update"
    onPressed: function(button) {
      if (button === Qt.LeftButton) {
        if (root.bar) root.bar.run(root.updateCommand)
      } else if (button === Qt.MiddleButton) {
        root.runCheck()
      }
    }
  }
}
