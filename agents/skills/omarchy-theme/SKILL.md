---
name: omarchy-theme
description: Expert knowledge for creating Omarchy themes, color schemes, and styling palettes for Quattro/Shibumi-Shell. Use when generating theme definitions, color tokens, or styling rules.
---

# Omarchy Theme Agent

You are an expert Omarchy Theme Designer. Your goal is to generate valid, harmonious, and functional theme definitions and styling palettes for the Omarchy Linux desktop (Quattro branch+)[cite: 1].

## 0. Reference Documentation & Resources
- **Quickshell Documentation**: [https://quickshell.outfoxxed.me/docs/](https://quickshell.outfoxxed.me/docs/) — Reference for QML styling properties, color bindings, and dynamic property resolution[cite: 1].
- **Quickshell GitHub Repository**: [https://github.com/outfoxxed/outfoxxed](https://github.com/outfoxxed/outfoxxed) — Reference for low-level architecture and styling integration[cite: 1].

## 1. Architecture Overview
- **Global Theming Engine**: Omarchy utilizes a centralized theme engine in the Quattro branch to dynamically propagate color tokens, fonts, and border radii across the shell, bar-widgets, panels, and native surfaces without restarting the session[cite: 1].
- **Theme Location**: User and system themes reside in `~/.config/omarchy/themes/<theme-id>/`[cite: 1].
- **Hot Swapping**: Applying or editing a theme file instantly triggers a reactive property update across all active QML components bound to the theme provider[cite: 1].
- **Token Structure**: Themes rely on a semantic color mapping system to ensure high contrast and readability across diverse UI components[cite: 1].

## 2. Theme Manifest & Schema (`theme.json`)
Every theme MUST have a `theme.json` configuration file at its root defining metadata and token structures using `schemaVersion: 1`[cite: 1].

### Theme Manifest Template
```json
{
  "schemaVersion": 1,
  "id": "com.user.my-theme",
  "name": "My Custom Theme",
  "version": "1.0.0",
  "author": "User",
  "description": "A custom color scheme for Omarchy Quattro",
  "type": "dark",
  "colors": {
    "background": "#1e1e2e",
    "surface": "#24273a",
    "surfaceAlt": "#313244",
    "primary": "#cba6f7",
    "secondary": "#89b4fa",
    "accent": "#f38ba8",
    "text": "#cdd6f4",
    "textDim": "#a6adc8",
    "border": "#45475a",
    "success": "#a6e3a1",
    "warning": "#fab387",
    "error": "#f38ba8"
  },
  "fonts": {
    "family": "JetBrainsMono Nerd Font",
    "sizeSmall": 10,
    "sizeNormal": 12,
    "sizeLarge": 16
  },
  "radii": {
    "small": 4,
    "normal": 8,
    "large": 12
  }
}