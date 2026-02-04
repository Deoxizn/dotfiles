#!/bin/bash
# ~/.config/hypr/scripts/weather.sh
result=$(timeout 3 curl -s "wttr.in/Sierra+Vista,Arizona?format=%c%t" 2>/dev/null | sed 's/+//')
if [ -z "$result" ]; then
    echo "🌤️ N/A"
else
    echo "🌤️ $result"
fi
