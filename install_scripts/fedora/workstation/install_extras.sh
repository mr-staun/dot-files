#!/bin/env bash

# This script is based on the following repo
# https://github.com/Zer0CoolX/Fedora-KDE-Minimal-Install-Guide


##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo "Removing unnecessary packages"

dnf remove nano-default-editor

echo "Installing extra packages"

# Install KDE Packages
dnf install \
  @"Input Methods" \
  @Multimedia \
  @"Printing Support" \
  ark \
  firefox \
  git \
  gwenview \
  kcalc \
  spectacle \
  vim \
  vim-default-editor \
  vlc

