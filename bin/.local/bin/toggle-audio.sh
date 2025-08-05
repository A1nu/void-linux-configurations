#!/usr/bin/env bash

# Названия устройств вывода (проверь через pactl list short sinks)
HEADPHONES="alsa_output.usb-SteelSeries_SteelSeries_Arctis_Nova_5-00.analog-stereo"
MONITOR="alsa_output.pci-0000_01_00.1.hdmi-stereo-extra2"

# Получаем активное устройство
CURRENT=$(pactl get-default-sink)

# Логика переключения
if [[ "$CURRENT" == "$HEADPHONES" ]]; then
    NEW_SINK="$MONITOR"
    echo "🔊 Переключаемся на монитор"
else
    NEW_SINK="$HEADPHONES"
    echo "🎧 Переключаемся на наушники"
fi

# Устанавливаем новое устройство по умолчанию
pactl set-default-sink "$NEW_SINK"

# Переносим активные потоки (если есть)
pactl list short sink-inputs | awk '{print $1}' | while read -r ID; do
    pactl move-sink-input "$ID" "$NEW_SINK" 2>/dev/null
done

