#!/bin/bash
temp=$(sensors | awk '/k10temp/ {found=1} found && /Tctl/ {print $2; exit}' | sed 's/+//;s/°C//')
usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
printf '{"text":"%sᶜ","tooltip":"Overall Usage: %s%%"}\n' "$temp" "${usage:-0}"
