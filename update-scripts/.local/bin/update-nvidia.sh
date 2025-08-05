#!/usr/bin/env bash

# Script to check for updates to NVIDIA packages and rebuild DKMS if needed
# Requires: xbps-install, xbps-query, xbps-reconfigure, notify-send

set -e

# Path to local void-packages output repo (adjust if necessary)
REPO_PATH="$HOME/void-packages/hostdir/binpkgs/nonfree"

# Add local repo to the install command using -R
XBPS_INSTALL="sudo xbps-install -R $REPO_PATH -U"

# List of NVIDIA packages to track
PACKAGES=(
  nvidia
  nvidia-dkms
  nvidia-libs
  nvidia-firmware
  nvidia-opencl
  nvidia-gtklibs
)

updated=()

echo "[INFO] Checking for NVIDIA package updates..."

for pkg in "${PACKAGES[@]}"; do
  file_path=$(find "$REPO_PATH" -name "${pkg}-*.xbps" | sort | tail -n1)
  if [[ -n "$file_path" ]]; then
    if sudo xbps-install -n "$file_path" > /dev/null; then
      echo "[UPDATE] New version of $pkg found: installing..."
      $XBPS_INSTALL "$file_path"
      updated+=("$pkg")
    else
      echo "[SKIP] $pkg is up to date."
    fi
  else
    echo "[WARN] No .xbps file found for $pkg"
  fi
done

if [[ ${#updated[@]} -gt 0 ]]; then
  echo "[INFO] Reconfiguring DKMS module..."
  sudo xbps-reconfigure -f nvidia-dkms

  echo "[INFO] Regenerating initramfs..."
  sudo dracut -f

  notify-send "NVIDIA drivers updated" "Updated: ${updated[*]}\nDKMS rebuilt and initramfs regenerated."
else
  echo "[INFO] No NVIDIA updates found."
fi
