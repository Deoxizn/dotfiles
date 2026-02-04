#!/bin/bash
# ~/.config/hypr/scripts/weather.sh
timeout 3 curl -s "wttr.in/Sierra+Vista,Arizona?format=%c%t" | sed 's/+//' || echo "🌤️ N/A"
