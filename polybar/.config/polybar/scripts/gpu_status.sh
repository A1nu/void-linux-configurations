#!/bin/bash

if ! command -v nvidia-smi &> /dev/null; then
  echo "%{F#ff5555}GPU: N/A%{F-}"
  exit 0
fi

if ! nvidia-smi &> /dev/null; then
  echo "%{F#ff5555}GPU: ERR%{F-}"
  exit 0
fi

LOAD=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)
echo "GPU: ${LOAD}%"
