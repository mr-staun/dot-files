#!/bin/env bash

# This script is based on the following repo
# https://github.com/Zer0CoolX/Fedora-KDE-Minimal-Install-Guide


##### CHECK FOR SUDO or ROOT ##################################
if ! [ $(id -u) = 0 ]; then
  echo "This script must be run as sudo or root, try again..."
  exit 1
fi

workstation_files_path=workstation

/bin/bash enable_non_free_rpm.sh
/bin/bash $workstation_files_path/install_DE.sh
/bin/bash $workstation_files_path/install_extras.sh