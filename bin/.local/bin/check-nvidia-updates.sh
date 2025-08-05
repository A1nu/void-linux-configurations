#!/bin/bash

# Путь до локального void-packages
VP_DIR="$HOME/void-packages"
LOG="$HOME/.cache/void-nvidia-check.log"

# Переход в директорию nonfree и обновление шаблонов
cd "$VP_DIR" || exit 1
git fetch origin

# Проверка на обновления пакета NVIDIA
if ! git diff --quiet origin/master -- srcpkgs/nvidia; then
    if [ ! -f "$LOG" ] || [ "$(cat $LOG)" != "$(git rev-parse origin/master)" ]; then
        notify-send "NVIDIA Driver Update" "Доступна новая версия NVIDIA драйвера в void-packages"
        git rev-parse origin/master > "$LOG"
    fi
fi
