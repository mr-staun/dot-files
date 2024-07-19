#!/bin/bash
##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo "Enabling repository for notifications"
dnf copr enable erikreider/SwayNotificationCenter

echo "Initiating Sway base install"

dnf install \
    bash-completion \
    firefox \
    foot \
    git \
    gvfs-mtp \
    @"Hardware Support" \
    htop \
    imv \
    jetbrains-mono-fonts \
    lm_sensors \
    NetworkManager-wifi \
    rofi \
    sway \
    SwayNotificationCenter \
    tar \
    thunar \
    unzip \
    vim

echo "Install complete!"
