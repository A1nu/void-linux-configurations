#!/bin/bash

# Запустить, только если не работает
pgrep -x 1password > /dev/null && exit 0

# Убедиться, что D-Bus и keyring живы
[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && eval "$(dbus-launch --sh-syntax --exit-with-session)"
pgrep -x gnome-keyring-daemon > /dev/null || eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
export SSH_AUTH_SOCK

# Подождать чуть-чуть
sleep 1

# Запуск 1Password
/opt/1Password/1password --start-agent --silent 2>/dev/null &

