#!/bin/bash

HEADPHONES="alsa_output.usb-SteelSeries_SteelSeries_Arctis_Nova_5-00.analog-stereo"
MONITOR="alsa_output.pci-0000_01_00.1.hdmi-stereo-extra2"

# Проверка, подключены ли наушники
if pactl list short sinks | grep -q "$HEADPHONES"; then
    pactl set-default-sink "$HEADPHONES"
else
    pactl set-default-sink "$MONITOR"
fi

