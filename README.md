# policromia

<p align="center">
  <img src="cyberpunk.png" width="400" />
  <img src="dark.png" width="400" />
  <img src="light.png" width="400" />
</p>

## Details

- **OS:** [Arch Linux](https://archlinux.org)
- **WM:** [awesome](https://github.com/awesomeWM/awesome)
- **Terminal:** [kitty](https://github.com/kovidgoyal/kitty)
- **Shell:** [zsh](https://www.zsh.org/)
- **Editor:** [neovim](https://github.com/neovim/neovim)
- **Compositor:** [picom](https://github.com/yshui/picom)
- **Application Launcher:** [rofi](https://github.com/davatorium/rofi)
- **Emoji List:** [rofi-emoji](https://github.com/Mange/rofi-emoji)

AwesomeWM Modules:

- **[bling](https://github.com/blingcorp/bling)**
  - Adds new layouts, modules, and widgets that try to focus on window management primarily

### Keys

| Shortcut                                           | Action                    |
| :------------------------------------------------- | :------------------------ |
| <kbd>Super</kbd> + <kbd>d</kbd>                    | Toggle dashboard          |
| <kbd>Super</kbd> + <kbd>e</kbd>                    | Open application launcher |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>e</kbd> | Open emoji list           |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>s</kbd> | Cropped screenshot        |
| <kbd>Super</kbd> + <kbd>t</kbd>                    | Toggle on top             |
| <kbd>Super</kbd> + <kbd>f</kbd>                    | Toggle fullscreen         |
| <kbd>Super</kbd> + <kbd>Tab</kbd>                  | Toggle floating           |
| <kbd>Alt</kbd> + <kbd>Tab</kbd>                    | Focus next                |

## Setup

Using [paru](https://github.com/Morganamilo/paru) as the AUR helper

### Dependencies

```
paru -S awesome-git picom-git zsh redshift thunar kitty rofi rofi-emoji xclip scrot gvfs ttf-jetbrains-mono noto-fonts noto-fonts-cjk networkmanager betterlockscreen lxappearance materia-gtk-theme papirus-icon-theme lsd playerctl brightnessctl pipewire pipewire-alsa pipewire-pulse alsa-utils acpi
```

### Get the repo

```
git clone --recurse-submodules https://github.com/mariod8/dotfiles
cd dotfiles
```

### Install

```
cp -r config/awesome/* ~/.config/awesome
cp -r config/picom/* ~/.config/picom
cp -r config/fontconfig/* ~/.config/fontconfig
cp -r config/kitty/* ~/.config/kitty
cp -r config/rofi/* ~/.config/rofi
cp -r fonts/* ~/.local/share/fonts
```
