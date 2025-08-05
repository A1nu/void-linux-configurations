#!/bin/bash

# Название монитора (частичное или полное)
MONITOR_NAME="Samsung B65"

# Ищем карту NVIDIA (по PCI-адресу)
CARD_ID=$(pactl list cards | awk -v RS= '/alsa_card.pci-0000_01_00.1/ { for (i=1;i<=NF;i++) if ($i=="Name:") print $(i+1) }')

if [[ -z "$CARD_ID" ]]; then
  echo "❌ Не найдена звуковая карта NVIDIA"
  exit 1
fi

# Ищем нужный HDMI профиль, ассоциированный с монитором B65
PROFILE=$(pactl list cards | awk -v RS= "/Card.*$CARD_ID/" -v mon="$MONITOR_NAME" '
  match($0, /output:hdmi-stereo[^ ]*/) {
    prof = substr($0, RSTART, RLENGTH)
  }
  /Description:.*"Samsung B65"/ {
    print prof
    exit
  }')

# Fallback: просто используем hdmi-stereo-extra2
if [[ -z "$PROFILE" ]]; then
  echo "⚠️  Монитор $MONITOR_NAME не найден, назначаю fallback: hdmi-stereo-extra2"
  PROFILE="output:hdmi-stereo-extra2"
fi

# Применяем профиль
echo "🎚 Устанавливаю профиль $PROFILE на $CARD_ID"
pactl set-card-profile "$CARD_ID" "$PROFILE"
