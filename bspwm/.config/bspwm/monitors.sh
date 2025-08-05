#!/bin/sh

# Set layout of monitors (from left to right)
xrandr --output DP-4 --mode 2560x1440 --rate 165 --pos 0x0 --rotate normal \
       --output DP-2 --primary --mode 2560x1440 --rate 120 --pos 2560x0 --rotate normal \
       --output DP-0 --mode 2560x1440 --rate 165 --pos 5120x0 --rotate normal

