#/bin/bash
set -e

config_dir=~/.config
target_dir=./config

if [ ! -d  ${config_dir} ]; then
    echo "Configuration folder does not exist"
    exit 1
fi

echo "Copying configurations..."

# Get font configuration
current_conf=fontconfig
if [ -d ${config_dir}/${current_conf} ]; then
    mkdir -p ${target_dir}/${current_conf}
    cp ${config_dir}/${current_conf}/fonts.conf ${target_dir}/${current_conf}
    echo "Completed copy of '${current_conf}' configuration!"
fi

# Get Foot Terminal configuration
current_conf=foot
if [ -d ${config_dir}/${current_conf} ]; then
    mkdir -p ${target_dir}/${current_conf}
    cp ${config_dir}/${current_conf}/foot.ini ${target_dir}/${current_conf}
    echo "Completed copy of '${current_conf}' configuration!"
fi

# Get rofi Terminal configuration
current_conf=rofi
if [ -d ${config_dir}/${current_conf} ]; then
    mkdir -p ${target_dir}/${current_conf}
    cp ${config_dir}/${current_conf}/config.rasi ${target_dir}/${current_conf}
    echo "Completed copy of '${current_conf}' configuration!"
fi

# Get Sway configuration
current_conf=sway
if [ -d ${config_dir}/${current_conf} ]; then
    mkdir -p ${target_dir}/${current_conf}
    cp ${config_dir}/${current_conf}/config ${target_dir}/${current_conf}
    echo "Completed copy of '${current_conf}' configuration!"
fi

# Get Waybar configuration
current_conf=waybar
if [ -d ${config_dir}/${current_conf} ]; then
    echo "Waybar configuration was found. This cannot be backed up automatically. Make sure you backup changes accordingly"
fi


