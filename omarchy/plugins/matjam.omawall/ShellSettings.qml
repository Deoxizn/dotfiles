import Quickshell
import Quickshell.Io
import QtQml

FileView {
  id: root

  property string pluginId: ""
  property var _settings: ({})
  readonly property var settings: _settings
  property bool reading: false
  property bool reloadPending: false
  property Timer trailingReload: Timer {
    interval: 100
    onTriggered: {
      root.reloadSettings()
    }
  }

  property string configPath: Quickshell.env("HOME") + "/.config/omarchy/shell.json"
  path: configPath
  watchChanges: true
  printErrors: false
  preload: true

  // The service reads shell.json directly, while the panel gets its entry
  // from the shell, so the two must agree on where that entry can live.
  // Upstream only checked bar.layout left/center/right and plugins[].
  // A widget in tray, centerBegin or centerEnd (the tray is where this
  // plugin actually sits on a real desktop) was invisible to the service:
  // the panel showed the folder, the service saw no settings at all, and
  // the status read "No images found in that folder" for a folder full of
  // images. Search the whole config, in document order, so any section
  // works and bar entries still win over plugins[] entries.
  function lookupSettings(config, id) {
    if (!config || !id) return null
    function search(node) {
      if (typeof node === "string") return node === id ? { id: id } : null
      if (!node || typeof node !== "object") return null
      if (String(node.id) === id) return node
      if (Array.isArray(node)) {
        for (var i = 0; i < node.length; i++) {
          var found = search(node[i])
          if (found) return found
        }
        return null
      }
      for (var k in node) {
        var hit = search(node[k])
        if (hit) return hit
      }
      return null
    }
    return search(config)
  }

  function reloadSettings() {
    if (reading) {
      reloadPending = true
      return
    }
    reading = true
    reload()
  }

  function finishReload() {
    reading = false
    if (reloadPending) {
      reloadPending = false
      reloadSettings()
    }
  }

  onFileChanged: {
    reloadSettings()
    trailingReload.restart()
  }
  onLoaded: {
    var config = null
    try { config = JSON.parse(text()) } catch (e) {}
    if (config && !Array.isArray(config) && typeof config === "object" && config.version === 1) {
      var found = lookupSettings(config, pluginId)
      _settings = found || ({})
    }
    finishReload()
  }

  onLoadFailed: {
    finishReload()
  }

}
