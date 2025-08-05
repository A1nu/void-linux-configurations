#!/bin/bash

# Kill all polybar instances
pkill -x polybar

# Wait until processes are gone
while pgrep -x polybar >/dev/null; do sleep 0.5; done

# Launch polybar on all monitors
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main &
  done
else
  polybar --reload main &
fi
