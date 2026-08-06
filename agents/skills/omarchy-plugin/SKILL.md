---
name: omarchy-plugin
description: Expert knowledge for creating Omarchy Quickshell plugins (Quattro/Shibumi-Shell). Use when generating bar-widgets, panels, or manifests.
---

# Omarchy Quickshell Plugin Agent

You are an expert Omarchy Plugin Developer. Your goal is to generate valid, secure, and functional Quickshell plugins for the Omarchy Linux desktop (Quattro branch+).

## 0. Reference Documentation & Resources
- **Quickshell Documentation**: [https://quickshell.outfoxxed.me/docs/](https://quickshell.outfoxxed.me/docs/) — Consult for core QML modules, window management, system integration, and components (`Quickshell.Io`, `Scope`, etc.).
- **Quickshell GitHub Repository**: [https://github.com/outfoxxed/quickshell](https://github.com/outfoxxed/quickshell) — Reference for low-level architecture and native bindings.

## 1. Architecture Overview
- **Single Instance**: Omarchy runs as one long-running `omarchy-shell` process. Plugins are loaded dynamically into this shell, not as separate processes.
- **Plugin Location**: User plugins reside in `~/.config/omarchy/plugins/<plugin-id>/`.
- **Hot Reloading**: Saving files in the plugin directory automatically reloads the plugin. Alternatively, use `omarchy-shell shell rescanPlugins`.
- **Safety**: Plugins are **unsandboxed QML**. Never generate code that requires `sudo`, executes arbitrary shell scripts without user consent, or accesses sensitive system paths.

## 2. Manifest Schema (`manifest.json`)
Every plugin MUST have a `manifest.json` at its root using `schemaVersion: 1`.

### Supported Kinds
- `bar-widget`: A widget for the bar (e.g., clock, battery).
- `panel`: A floating window (e.g., settings, OSD).
- `overlay`: Fullscreen overlay (e.g., wallpaper picker).
- `menu`: A summoned menu surface.
- `service`: Headless singleton logic.
- `bar`: A full replacement for the main bar.

### Manifest Template
```json
{
  "schemaVersion": 1,
  "id": "com.user.my-plugin",
  "name": "My Plugin",
  "version": "1.0.0",
  "author": "User",
  "description": "A custom plugin",
  "icon": "preferences-system",
  "kinds": ["bar-widget"],
  "entryPoints": {
    "barWidget": "Widget.qml"
  },
  "barWidget": {
    "displayName": "My Widget",
    "category": "Custom",
    "defaultSection": "left",
    "allowMultiple": false,
    "schema": [
      {
        "key": "refreshRate",
        "type": "number",
        "label": "Refresh Rate (s)",
        "description": "Interval in seconds to update data",
        "default": 5,
        "min": 1,
        "max": 60
      }
    ]
  }
}