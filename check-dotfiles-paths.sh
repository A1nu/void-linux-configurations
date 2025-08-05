#!/usr/bin/env bash

# check-dotfiles-paths.sh
# Проверяет, что все вызываемые .sh скрипты существуют

set -euo pipefail

# Цвета
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔍 Searching for .sh calls in tracked dotfiles..."

# Собираем все упоминания .sh скриптов
grep -rEho '\~?/?[\.a-zA-Z0-9/_-]+\.sh' . \
  --exclude-dir=".git" \
  --exclude="check-dotfiles-paths.sh" |
  sort -u > /tmp/dotfiles-called-scripts.txt

echo "📦 Checking for file existence..."

ALL_OK=true

while IFS= read -r script; do
  # Убираем ~ и подставляем текущий путь, если нужно
  full_path="$script"
  [[ $script == ~/* ]] && full_path="${HOME}${script:1}"
  
  # Приведение к относительному пути
  rel_path="${script/#\~/$HOME}"
  rel_path="${rel_path/#$HOME/}"

  # Удаляем возможный ведущий /
  rel_path="${rel_path#/}"

  if [ -f "$rel_path" ]; then
    echo -e "${GREEN}✔ $script exists${NC}"
  else
    echo -e "${RED}✘ $script NOT FOUND → expected: $rel_path${NC}"
    ALL_OK=false
  fi
done < /tmp/dotfiles-called-scripts.txt

if $ALL_OK; then
  echo -e "\n✅ ${GREEN}All script references resolved correctly.${NC}"
else
  echo -e "\n⚠️  ${RED}Some script paths are broken or missing.${NC}"
fi


