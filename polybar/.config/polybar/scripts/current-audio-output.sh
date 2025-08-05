#!/bin/bash

sink=$(pactl get-default-sink)
description=$(pactl list sinks | grep -A10 "Name: $sink" | grep "Description" | cut -d ':' -f2- | sed 's/^ *//')

if echo "$description" | grep -qi "headphone"; then
  icon="🎧"
elif echo "$description" | grep -qi "Odyssey\|monitor"; then
  icon="🖥"
else
  icon="🔊"
fi

echo "$icon $description"

