#!/bin/bash
##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo "Initiating Sway base install"

dnf group install hardware-support

dnf install \
    bash-completion \
    firefox \
    foot \
    git \
    gvfs-mtp \
    htop \
    imv \
    jetbrains-mono-fonts \
    lm_sensors \
    NetworkManager-wifi \
    nmtui \
    rofi \
    sway \
    tar \
    thunar \
    unzip \
    vim \
    waybar

echo "Install complete!"
