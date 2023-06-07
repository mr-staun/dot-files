#!/bin/bash
konsole_path=./local/share/konsole

##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

dnf install \
numix-icon-theme-circle
cascadia-code-font

cp ./terminal/inputrc ~/.inputrc
cp ./terminal/Edna.colorscheme $konsole_path
cp ./terminal/Blue.profile $konsole_path
