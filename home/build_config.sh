#/bin/bash
set -e

home_config_dir=~/.config
master_config_dir=./config

if [[ "$1" == "laptop" ]]; then
    echo "Creating configuration for $1"
elif [[ "$1" == "workstation" ]]; then
    echo "Creating configuration for $1"
else
    echo "Error! Configuration is not valid! This environment does not exist"
    exit 1
fi

echo "Creating configuration folder"
mkdir -p ${home_config_dir}

echo "Copying configurations..."

cp -r ${master_config_dir}/* ${home_config_dir}

echo "Building waybar configuration..."

waybar_config_dir=${home_config_dir}/waybar
comment_line_num=$(grep "// INSERT INITIAL CONFIG HERE" ${waybar_config_dir}/config_base.jsonc -n | cut -f1 -d:)
head -n $((comment_line_num - 1)) ${waybar_config_dir}/config_base.jsonc > ${waybar_config_dir}/config.jsonc
cat ${waybar_config_dir}/config_$1.jsonc >> ${waybar_config_dir}/config.jsonc
tail -n +$((comment_line_num + 1)) ${waybar_config_dir}/config_base.jsonc >> ${waybar_config_dir}/config.jsonc

rm ${waybar_config_dir}/config_base.jsonc
rm ${waybar_config_dir}/config_*.jsonc

echo "Waybar configuration built!"
