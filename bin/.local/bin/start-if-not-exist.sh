#!/bin/bash

COMMAND="$1"

if ! pgrep -x "$COMMAND" > /dev/null; then
  echo "Starting $COMMAND..."
  setsid "$COMMAND" >/dev/null 2>&1 &
else
  echo "$COMMAND is already running."
fi

