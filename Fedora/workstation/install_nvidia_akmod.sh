#!/bin/env bash

# This script is based on the following repo
# https://github.com/Zer0CoolX/Fedora-KDE-Minimal-Install-Guide


##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo "Installing Nvidia akmod"

# Install KDE Packages
dnf install \
  kenel-devel \
  akmod-nvidia \
  xorg-x11-drv-nvidia-cuda
