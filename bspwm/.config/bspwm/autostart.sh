#!/bin/sh

# PipeWire workaround for runit (no pam/systemd)
export XDG_RUNTIME_DIR=/run/user/$(id -u)
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

# PipeWire + Pulse bridge + session manager
start-if-not-exist.sh pipewire
start-if-not-exist.sh pipewire-pulse
start-if-not-exist.sh wireplumber

# Горячие клавиши, Polybar, обои
sxhkd &
~/.config/polybar/launch.sh &
wallpaper.sh &
picom &
# Bluetooth апплет
blueman-applet &

sleep 1

# --- Звук по умолчанию на Odyssey B65 ---
# Назначаем профиль HDMI выхода NVIDIA (B65)
pactl set-card-profile alsa_card.pci-0000_01_00.1 output:hdmi-stereo-extra2

# Назначаем соответствующий sink по умолчанию
pactl set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo-extra2

# Назначаем Arctis Nova 5 как дефолтный микрофон
pactl set-default-source alsa_input.usb-SteelSeries_SteelSeries_Arctis_Nova_5-00.mono-fallback

pw-jack easyeffects --gapplication-service &

# 1Password (если не запущен)
pgrep -x 1password > /dev/null || /opt/1Password/1password --silent --start-agent &

# Проверка обновлений (твоя логика)
check-nvidia-updates.sh &

