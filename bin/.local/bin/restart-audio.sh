#!/usr/bin/env bash

echo "⏳ Завершаем звуковые процессы..."

pkill -x pipewire
pkill -x pipewire-pulse
pkill -x wireplumber

sleep 1

echo "🔁 Запускаем снова..."
pipewire &
pipewire-pulse &
wireplumber &

echo "✅ Перезапуск завершён"
