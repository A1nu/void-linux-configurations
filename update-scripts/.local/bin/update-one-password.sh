#!/bin/bash

set -e

WORKDIR="$HOME/.cache/1password-update"
DEB_URL="https://downloads.1password.com/linux/debian/amd64/stable/1password-latest.deb"
DEB_FILE="$WORKDIR/1password-latest.deb"
INSTALL_DIR="/opt/1Password"

mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Скачать
wget -N "$DEB_URL"

# Проверить, отличается ли от установленной версии
if [ -f "$INSTALL_DIR/version.txt" ]; then
  OLD_HASH=$(sha256sum "$INSTALL_DIR/version.txt" | awk '{print $1}')
  NEW_HASH=$(sha256sum "$DEB_FILE" | awk '{print $1}')
  [ "$OLD_HASH" = "$NEW_HASH" ] && echo "1Password is up-to-date." && exit 0
fi

# Удалить старую
sudo rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

# Распаковать
ar x "$DEB_FILE"
sudo tar -xf data.tar.xz -C /

# Обновить хеш
echo "$NEW_HASH" | sudo tee "$INSTALL_DIR/version.txt"

echo "✅ 1Password updated."
