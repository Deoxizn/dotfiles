#!/bin/bash
# ~/.config/hypr/scripts/song.sh
timeout 2 playerctl metadata --format "🎵 {{artist}} - {{title}}" 2>/dev/null || echo "🎵 No music"
