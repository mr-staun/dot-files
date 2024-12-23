#/bin/bash
set -e

# Function that copies a file into "~/.[filename]"
copy_user_home_config_file () {
    if [[ ! -f $1 ]]; then
        echo "File '$1' does not exist or is invalid! Copy failed."
    else
        echo "Copying file '$1' to home directory..."
        cp $1 ~/.$1
    fi
}

home_config_dir=~/.config
master_config_dir=./config
custom_config_dir=./custom_config

# Check flags
if [[ "$1" == "rome" ]]; then
    is_laptop=0
    temperature_file=/sys/class/thermal/thermal_zone1/temp
    echo "Creating configuration for '$1'"
elif [[ "$1" == "genoa" ]]; then
    is_laptop=1
    echo "Creating configuration for '$1'"
elif [[ "$1" == "venezia" ]]; then
    is_laptop=1
    echo "Creating configuration for '$1'"
else
    echo "Error! Hostname is not valid! This hostname does not exist"
    exit 1
fi

# Copy basic configuration to home
copy_user_home_config_file bashrc;
copy_user_home_config_file inputrc;
copy_user_home_config_file bash_profile;

echo "Creating configuration folder"
mkdir -p ${home_config_dir}

echo "Overwriting configurations..."

# Delete existing configuration folders
for d in $master_config_dir/*/; do
    curent_config_dir=$(basename ${d})
    rm -r ${home_config_dir}/${curent_config_dir}
done

# Replace configuration folders with source
cp -r ${master_config_dir}/* ${home_config_dir}

### SWAY
echo "Building sway configuration..."
sway_config_dir=${home_config_dir}/sway

# Add an include to the correct config file
echo "include config_"$1 >> ${sway_config_dir}/config
echo "" >> ${sway_config_dir}/config
cp ./${custom_config_dir}/sway/config_$1 ${sway_config_dir}


### WAYBAR
echo "Building waybar configuration..."

waybar_config_dir=${home_config_dir}/waybar

# Finds the line number of a specific comment
comment_line_num=$(grep "// INSERT INITIAL CONFIG HERE" ${waybar_config_dir}/config_base.jsonc -n | cut -f1 -d:)
# Add initial config for waybar
head -n $((comment_line_num - 1)) ${waybar_config_dir}/config_base.jsonc > ${waybar_config_dir}/config.jsonc

# Copy specific config files based on flags
if [ $is_laptop -eq 1 ]; then
    cat ${custom_config_dir}/waybar/config_laptop.jsonc >> ${waybar_config_dir}/config.jsonc
else
    cat ${custom_config_dir}/waybar/config_workstation.jsonc >> ${waybar_config_dir}/config.jsonc
fi

# Write new config file 
tail -n +$((comment_line_num + 1)) ${waybar_config_dir}/config_base.jsonc >> ${waybar_config_dir}/config.jsonc

# Delete temporary files
rm ${waybar_config_dir}/config_base.jsonc

# Add the correct temperature path to waybar component
if [ -n "${temperature_file}" ]; then
    sed -i "s|// INSERT TEMP PATH HERE|\"hwmon-path\": [\"$temperature_file\"],|" "$waybar_config_dir"/components/system.jsonc
fi

echo "Waybar configuration built!"
