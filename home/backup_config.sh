#/bin/bash
set -e

backup_home_config () {
    if [[ ! -f $1 ]]; then
        echo "File '$1' does not exist or is invalid! Copy failed."
    else
        echo "Copying file '$1' from home directory..."
        cp ~/.$1 $1
    fi
}

config_dir=~/.config
target_dir=./config

if [ ! -d  ${config_dir} ]; then
    echo "Configuration folder does not exist"
    exit 1
fi

backup_home_config bashrc;
backup_home_config inputrc;
backup_home_config bash_profile;

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
    cp ${config_dir}/${current_conf}/* ${target_dir}/${current_conf}/
    echo "Completed copy of '${current_conf}' configuration!"
fi

# Get Sway configuration
current_conf=sway
if [ -d ${config_dir}/${current_conf} ]; then
    echo "Waybar configuration was found. This cannot be backed up automatically. Make sure you backup changes accordingly"
fi

# Get Waybar configuration
current_conf=waybar
if [ -d ${config_dir}/${current_conf} ]; then
    echo "Waybar configuration was found. This cannot be backed up automatically. Make sure you backup changes accordingly"
fi
