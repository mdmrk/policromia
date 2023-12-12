#!/bin/sh

set -e

PACKAGES="awesome-git picom-git redshift kitty rofi xclip xorg-xwininfo scrot ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk networkmanager betterlockscreen brightnessctl pipewire pipewire-alsa pipewire-pulse alsa-utils acpi zsh gvfs thunar lsd zoxide bat lxappearance jq curl p7zip"

if [ -t 1 ]; then
	is_tty() {
		true
	}
else
	is_tty() {
		false
	}
fi

setup_color() {
	if ! is_tty; then
		# Reset
		Normal=''

		# Regular Colors
		Black=''
		Red=''
		Green=''
		Yellow=''
		Blue=''
		Purple=''
		Cyan=''
		White=''

		# Bold
		BBlack=''
		BRed=''
		BGreen=''
		BYellow=''
		BBlue=''
		BPurple=''
		BCyan=''
		BWhite=''

		# Undeline
		UBlack=''
		URed=''
		UGreen=''
		UYellow=''
		UBlue=''
		UPurple=''
		UCyan=''
		UWhite=''

		# Background
		On_Black=''
		On_Red=''
		On_Green=''
		On_Yellow=''
		On_Blue=''
		On_Purple=''
		On_Cyan=''
		On_White=''
		return
	fi

	# Reset
	Normal='\033[0m'

	# Regular Colors
	Black='\033[0;30m'
	Red='\033[0;31m'
	Green='\033[0;32m'
	Yellow='\033[0;33m'
	Blue='\033[0;34m'
	Purple='\033[0;35m'
	Cyan='\033[0;36m'
	White='\033[0;37m'

	# Bold
	BBlack='\033[1;30m'
	BRed='\033[1;31m'
	BGreen='\033[1;32m'
	BYellow='\033[1;33m'
	BBlue='\033[1;34m'
	BPurple='\033[1;35m'
	BCyan='\033[1;36m'
	BWhite='\033[1;37m'

	# Underline
	UBlack='\033[4;30m'
	URed='\033[4;31m'
	UGreen='\033[4;32m'
	UYellow='\033[4;33m'
	UBlue='\033[4;34m'
	UPurple='\033[4;35m'
	UCyan='\033[4;36m'
	UWhite='\033[4;37m'

	# Background
	On_Black='\033[40m'
	On_Red='\033[41m'
	On_Green='\033[42m'
	On_Yellow='\033[43m'
	On_Blue='\033[44m'
	On_Purple='\033[45m'
	On_Cyan='\033[46m'
	On_White='\033[47m'
}

print_style() {
	printf "%s$*${Normal}\n"
}

error() {
	print_style "${Red}err: $*"
	exit 1
}

setup_policromia() {
	print_style ${Yellow} "downloading and installing packages"
	sudo pacman -Syy
	paru -S ${PACKAGES}
	cd /tmp
	print_style ${Yellow} "cloning policromia"
	git clone --depth 1 --recurse-submodules --shallow-submodules https://github.com/mdmrk/policromia --branch 2.0
	cd policromia
	print_style ${Yellow} "installing"
	mkdir -p ~/.config/awesome && cp -r config/awesome/* ~/.config/awesome
	cp ~/.config/awesome/env.example.lua ~/.config/awesome/env.lua
	mkdir -p ~/.config/picom && cp -r config/picom/* ~/.config/picom
	mkdir -p ~/.config/kitty && cp -r config/kitty/* ~/.config/kitty
	mkdir -p ~/.config/rofi && cp -r config/rofi/* ~/.config/rofi
	mkdir -p ~/.local/share/fonts && cp -r fonts/* ~/.local/share/fonts
	mkdir -p ~/.themes && 7z x config/gtk/themes.7z -oconfig/gtk && rm config/gtk/themes.7z && cp -r config/gtk/* ~/.themes
	chmod +x ~/.config/awesome/scripts/*.sh
	print_style ${BYellow} "installation complete"
	print_success
}

print_title() {
	print_style "${Yellow} ▄▄▄·      ▄▄▌  ▪   ▄▄· ▄▄▄        • ▌ ▄ ·. ▪   ▄▄▄· "
	print_style "${Yellow}▐█ ▄█▪     ██•  ██ ▐█ ▌▪▀▄ █·▪     ·██ ▐███▪██ ▐█ ▀█ "
	print_style "${Yellow} ██▀· ▄█▀▄ ██▪  ▐█·██ ▄▄▐▀▀▄  ▄█▀▄ ▐█ ▌▐▌▐█·▐█·▄█▀▀█ "
	print_style "${Yellow}▐█▪·•▐█▌.▐▌▐█▌▐▌▐█▌▐███▌▐█•█▌▐█▌.▐▌██ ██▌▐█▌▐█▌▐█ ▪▐▌"
	print_style "${Yellow}.▀    ▀█▄▀▪.▀▀▀ ▀▀▀·▀▀▀ .▀  ▀ ▀█▄▀▪▀▀  █▪▀▀▀▀▀▀ ▀  ▀ "
}

print_success() {
	print_style "${Green}success!"
	print_style "${UGreen}rebooting is recommended"
}

main() {
	setup_color
	print_title
	setup_policromia # Main workflow
}

main "$@"
