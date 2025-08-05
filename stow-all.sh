#!/bin/bash
cd "$(dirname "$0")"

for dir in bspwm polybar picom starship shell x11; do
  echo "🔗 Linking $dir ..."
  stow "$dir"
done

