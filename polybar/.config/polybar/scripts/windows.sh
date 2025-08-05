#!/bin/bash

active_win_id=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
current_desktop=$(xprop -root _NET_CURRENT_DESKTOP | awk '{print $3}')

wmctrl -l | while read -r id desktop host title; do
  if [ "$desktop" = "$current_desktop" ]; then
    if [ "$id" = "$active_win_id" ]; then
      echo -n " [*${title}*] "
    else
      echo -n " ${title} "
    fi
  fi
done
