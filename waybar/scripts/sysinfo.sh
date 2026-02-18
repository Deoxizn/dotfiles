#!/bin/bash

cpu_temp=$(sensors | awk '/k10temp/ {found=1} found && /Tctl/ {print $2; exit}' | sed 's/+//;s/°C//')
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
cpu_usage=${cpu_usage:-0}

gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")
gpu_util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null || echo "N/A")

mem_used=$(free --giga | awk '/^Mem:/ {printf "%.1f", $3}')
mem_total=$(free --giga | awk '/^Mem:/ {printf "%.1f", $2}')
mem_percent=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2*100}')

swap_used=$(free --giga | awk '/^Swap:/ {printf "%.1f", $3}')
swap_total=$(free --giga | awk '/^Swap:/ {printf "%.1f", $2}')
swap_percent=$(free | awk '/^Swap:/ {printf "%.0f", $3/$2*100}')

tooltip="CPU: ${cpu_temp}C | ${cpu_usage}%"
tooltip="${tooltip}\nGPU: ${gpu_temp}C | ${gpu_util}%"
tooltip="${tooltip}\nRAM: ${mem_used}G / ${mem_total}G (${mem_percent}%)"
tooltip="${tooltip}\nSWAP: ${swap_used}G / ${swap_total}G (${swap_percent}%)"

printf '{"tooltip":"%s"}\n' "$tooltip"
