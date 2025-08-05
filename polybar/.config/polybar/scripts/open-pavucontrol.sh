#!/bin/bash

# Запускаем pavucontrol, ждём его окно и делаем его floating
pavucontrol &

# Ждём появления окна
sleep 0.3

# Получаем ID окна
wid=$(xdotool search --onlyvisible --class "Pavucontrol" | head -n1)

# Применяем флотинг через bspc
if [ -n "$wid" ]; then
    bspc node "$wid" -t floating
    bspc node "$wid" -l above
    bspc node "$wid" -g state=floating
fi

