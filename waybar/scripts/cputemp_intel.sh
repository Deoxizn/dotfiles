#!/bin/bash
temp=$(cat /sys/class/thermal/thermal_zone4/temp | awk '{print $1/1000}')
usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
printf '{"text":"%.0fᶜ","tooltip":"Overall Usage: %s%%"}\n' "$temp" "${usage:-0}"
