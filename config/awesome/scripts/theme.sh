#!/bin/bash

theme_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/../theme
directories=$(find ${theme_dir}/ -mindepth 1 -maxdepth 1 -type d)
declare -A name_map

for directory in $directories; do
	basename=$(basename "$directory")
	formatted_name=$(basename "$directory" | tr '-' ' ' | sed 's/\<./\u&/g')
	name_map["$formatted_name"]=$(basename "$directory")
done

theme=$(printf '%s\n' "${!name_map[@]}" | rofi -dmenu -theme theme)
if [ -z "$theme" ]; then
	exit 1
fi
selectedtheme="${name_map[$theme]}"
activetheme=${theme_dir}/${selectedtheme}

echo "$selectedtheme" >${theme_dir}/activetheme &
cp $activetheme/colors.conf $HOME/.config/kitty/colors.conf &
cp $activetheme/colors.rasi $HOME/.config/rofi/colors.rasi &
sed -i "s/\(gtk-theme-name=\).*/\1$(cat ${activetheme}/colors.gtk)/" $HOME/.config/gtk-3.0/settings.ini
sed -i "s/\(gtk-theme-name=\).*/\1\"$(cat ${activetheme}/colors.gtk)\"/" $HOME/.gtkrc-2.0
sed -i "/theme =/s/\"[^\"]*\"/\"$(cat ${activetheme}/colors.nvim)\"/" $HOME/.config/nvim/lua/custom/chadrc.lua
echo 'awesome.restart()' | awesome-client >/dev/null
