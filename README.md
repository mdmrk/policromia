# dotfiles

<p align="center">
  <img src="/assets/tricolor.png" width="800" />
</p>

<p align="center">
  <img src="/assets/rofi_apps.png" width="350" />
  <img src="/assets/rofi_emojis.png" width="350" /> 
</p>

## Details

- **OS:** [Arch Linux](https://archlinux.org)
- **WM:** [awesome](https://github.com/awesomeWM/awesome)
- **Terminal:** [kitty](https://github.com/kovidgoyal/kitty)
- **Shell:** [zsh](https://www.zsh.org/)
- **Editor:** [neovim](https://github.com/neovim/neovim)
- **Compositor:** [picom](https://github.com/yshui/picom)
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)

AwesomeWM Modules:

- **[bling](https://github.com/blingcorp/bling)**
  - Adds new layouts, modules, and widgets that try to focus on window management primarily

## Setup

Using [paru](https://github.com/Morganamilo/paru) as the AUR helper

### Dependencies

```
paru -S awesome-git picom-git zsh redshift thunar kitty rofi rofi-emoji xclip scrot gvfs nerd-fonts-jetbrains-mono noto-fonts noto-fonts-cjk networkmanager lxappearance materia-gtk-theme papirus-icon-theme lsd playerctl brightnessctl pipewire pipewire-alsa pipewire-pulse alsa-utils acpi
```

### Get the repo

```
git clone --recurse-submodules https://github.com/mariod8/dotfiles
cd dotfiles
```

### Install

```
cp -r config/awesome ~/.config/awesome
cp -r config/picom ~/.config/picom
cp -r config/fontconfig ~/.config/fontconfig
cp -r config/kitty ~/.config/kitty
cp -r config/rofi ~/.config/rofi
cp -r fonts/* ~/.local/share/fonts
```
