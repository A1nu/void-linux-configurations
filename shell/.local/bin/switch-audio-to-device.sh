#!/bin/bash

TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "Usage: $0 \"SteelSeries\""
  exit 1
fi

# Парсим sink'и по блокам, ищем TARGET и берём соответствующее имя
SINK=$(pactl list sinks | awk -v t="$TARGET" '
  BEGIN { RS="Sink #"; IGNORECASE=1 }
  t && index($0, t) {
    match($0, /Name: ([^\n]+)/, arr)
    print arr[1]
    exit
  }
')

if [ -n "$SINK" ]; then
  echo "✅ Found sink: $SINK"
  pactl set-default-sink "$SINK"
  for input in $(pactl list short sink-inputs | awk "{print \$1}"); do
    pactl move-sink-input "$input" "$SINK"
  done
  echo "🎧 Switched to: $TARGET"
else
  echo "❌ No matching sink found for \"$TARGET\""
fi

