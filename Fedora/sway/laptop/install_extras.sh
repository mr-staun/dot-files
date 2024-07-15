#!/bin/bash
##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

echo "Installing extras"

dnf install \
    light

echo "Extras installed successfully!"
