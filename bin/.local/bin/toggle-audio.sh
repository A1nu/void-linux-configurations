#!/usr/bin/env bash

# Ключевые слова для поиска
HEADPHONES_KEY="SteelSeries"
MONITOR_KEY="hdmi-stereo"

# Получаем имя текущего sink
CURRENT_SINK=$(pactl get-default-sink)

echo "🎚️  Текущее устройство: $CURRENT_SINK"

# Определяем целевой sink
if echo "$CURRENT_SINK" | grep -qi "$HEADPHONES_KEY"; then
    TARGET_KEY="$MONITOR_KEY"
    echo "🔊 Переключаемся на монитор..."
else
    TARGET_KEY="$HEADPHONES_KEY"
    echo "🎧 Переключаемся на наушники..."
fi

# Ищем новое устройство по ключу
NEW_SINK=$(pactl list short sinks | grep -i "$TARGET_KEY" | awk '{print $2}' | head -n1)

# Проверка на пустой результат
if [[ -z "$NEW_SINK" ]]; then
    echo "❌ Не найден sink с ключом: $TARGET_KEY"
    exit 1
fi

# Переключаем устройство по умолчанию
pactl set-default-sink "$NEW_SINK"

# Перемещаем активные потоки
pactl list short sink-inputs | awk '{print $1}' | while read -r ID; do
    pactl move-sink-input "$ID" "$NEW_SINK"
done

echo "✅ Переключение завершено: $NEW_SINK"

