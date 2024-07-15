#!/bin/bash
##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo "Initiating Sway base install"

dnf install \
    firefox \
    @Fonts \
    foot \
    git \
    @"Hardware Support" \
    htop \
    lm_sensors \
    NetworkManager-wifi \
    rofi \
    sway \
    thunar

echo "Install complete!"
