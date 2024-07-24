#!/bin/bash
konsole_path=~/.local/share/konsole

sudo dnf install \
numix-icon-theme-circle \
cascadia-code-fonts

cp ./terminal/inputrc ~/.inputrc
cp ./terminal/Edna.colorscheme $konsole_path
cp ./terminal/Blue.profile $konsole_path
