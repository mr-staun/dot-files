#/bin/bash

home_config_dir=~/.config
master_config_dir=./home/config

echo "Creating configuration folder"
mkdir -p ${home_config_dir}

echo "Copying configurations..."

cp -r ${master_config_dir}/* ${home_config_dir}

echo "Building waybar configuration..."

waybar_config_dir=${home_config_dir}/waybar
comment_line_num=$(grep "// INSERT INITIAL CONFIG HERE" ${waybar_config_dir}/base_config.jsonc -n | cut -f1 -d:)
head -n $((line_number_temp - 1)) ${waybar_config_dir}/base_config.jsonc >> ${waybar_config_dir}/config.jsonc
cat ${waybar_config_dir}/config_laptop.jsonc >> ${waybar_config_dir}/config.jsonc
tail -n +$((line_number_temp + 1)) ${waybar_config_dir}/base_config.jsonc >> ${waybar_config_dir}/config.jsonc

rm ${waybar_config_dir}/base_config.jsonc
rm ${waybar_config_dir}/config_*.jsonc

echo "Waybar configuration built!"