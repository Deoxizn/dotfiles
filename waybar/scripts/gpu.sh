#!/bin/bash
temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
echo "{\"text\":\"${temp}ᶜ\",\"tooltip\":\"GPU Usage: ${util}%\"}"