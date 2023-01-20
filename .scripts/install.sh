#!/bin/bash

# Ensure packages are up to date.
sudo pacman -Syu

# Essentials.
sudo pacman -S git base-devel

# Install yay.
git clone https://aur.archlinux.org/yay.git ~/GitHub/yay/
cd ~/GitHub/yay/ && makepkg -si && cd ~

# Use yay to get pamac.
# yay -S libpamac-full pamac-all # Support for snap and flatpak.
yay -S libpamac-aur pamac-aur # Only AUR.
sudo pacman -Syu polkit-gnome
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
sudo sed -Ei '/EnableAUR/s/^#//' /etc/pamac.conf

# Browser.
# Keep firefox since some programs use it by default (for example cargo).
sudo pamac install firefox --no-confirm

# Some aesthetic stuff.
sudo pamac install cmatrix bonsai.sh-git pipes.sh lolcat shell-color-scripts --no-confirm

# Fonts.  This is very large, maybe use smaller package.
sudo pamac install nerd-fonts-jetbrains-mono --no-confirm

# Manuals.
# man-db база данных дл€ того, чтобы подт€гивать информацию о приложени€х, прикольна€ вещь, лучше чем -h
# использовать так: man <им€ того, о чем хочешь узнать инфу>
sudo pamac install man-db --no-confirm

# Utilities.
# zathura - приложение дл€ просмотра pdf документов
# cpu-x - аналог cpu-z
# gnome-calculator - удобный калькул€тор
# btop - то же что и htop, просто под него есть конфиг, поэтому не хочу убирать, чтоб потом ничего не поломолось
# nvtop - дл€ мониторинга работы видеокарты
# thunar - файловый менеджер, надеюсь, он там сразу кастомный будет
# lazygit - программка дл€ работы с гитом, выгл€дит красиво, если настроить
# flameshot - дл€ создание скриншотов (хз как запустить)
# brightnessctl - необходима дл€ настройки €ркости, не пон€тно, насколько это необходимо 
# bottom - красивые графики по нагрузке всего и вс€
# dunst - уведомлени€
# goverlay - приложение дл€ мониторинга системы во врем€ игр)))
sudo pamac install zathura zathura-pdf-mupdf-git cpu-x fuse-common gnome-calculator btop nvtop thunar lazygit flameshot brightnessctl bottom dunst --no-confirm

# Icons.
sudo pamac install papirus-icon-theme --no-confirm

# GUI stuff.
sudo pamac install lxappearance-gtk3 gruvbox-material-gtk-theme-git gtk-theme-material-black --no-confirm

# Bootloader.

sudo pamac install refind --no-confirm
refind-install
sudo chmod +x ~/.scripts/setup_refind.sh && ~/.scripts/setup_refind.sh

# LY Login manager.
# можно его использовать, а можно SDDM, на выбор, не удал€ю, потому что не знаю, нужен ли он вообще
sudo pamac install ly --no-confirm

# SDDM Login Manager
sudo pamac install sddm sddm-sugar-dark sddm-sugar-candy-git archlinux-tweak-tool-git --no-confirm
sudo systemctl disable display-manager && sudo systemctl enable sddm
sudo touch /etc/sddm.conf
sudo sh -c "echo '[Theme]' >> /etc/sddm.conf"
sudo sh -c "echo 'Current=sugar-candy' >> /etc/sddm.conf"
sudo cp ~/.wallpapers/Planets_Nord.jpg /usr/share/sddm/themes/sugar-candy/
sudo mv /usr/share/sddm/themes/sugar-candy/Planets_Nord.jpg /usr/share/sddm/themes/sugar-candy/wall_secondary.png

# Gnome stuff.
sudo pamac install gnome-browser-connector gnome-tweaks --no-confirm

# Bluetooth.
sudo pamac install blueman --no-confirm 
systemctl enable bluetooth.service && systemctl restart bluetooth.service
sudo sed -i 's/#AutoEnable=false/AutoEnable=true/g' /etc/bluetooth/main.conf # Enable on startup.

# Terminal.
sudo pamac install alacritty --no-confirm

# Coding stuff.
sudo pamac install neovim ripgrep neovide xclip nvim-packer-git --no-confirm
sudo pamac install nodejs code --no-confirm

# Communication.
sudo pamac install telegram-desktop discord  --no-confirm

# i3 stuff.
sudo pamac install feh xborder-git cronie rofi rofi-greenclip picom --no-confirm
chmod +x ~/.config/picom/scripts/toggle-picom-inactive-opacity.sh
# Stuff for polybar.
chmod +x ~/.config/polybar.personal/scripts/check-read-mode-status.sh
sudo pamac install polybar python-pywal pywal-git networkmanager-dmenu-git calc --no-confirm

# Sound stuff.
sudo pamac install pulseaudio pavucontrol alsa-utils --no-confirm
# Prevent the crackling sound.
sudo sed -i 's/load-module module-udev-detect/load-module module-udev-detect tsched=0/g' /etc/pulse/default.pa

# Media.
sudo pamac install playerctl --no-confirm

# Power management.
sudo pamac install tlp --no-confirm
systemctl enable tlp.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket
sudo tlp start

# Programming.
sudo pamac install julia-bin emf-langserver cmake python go --no-confirm

# Setup optimus manager.
# NB: For Nvidia cards only!
sudo pamac install optimus-manager gdm-prime nvidia-settings nvidia-force-comp-pipeline --no-confirm 
sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/g' /etc/gdm/custom.conf
sudo sed -i 's/DisplayCommand/#DisplayCommand/g' /etc/sddm.conf
sudo sed -i 's/DisplayStopCommand/#DisplayStopCommand/g' /etc/sddm.conf
sudo touch /etc/optimus-manager/optimus-manager.conf 
sudo sh -c "echo '[optimus]' > /etc/optimus-manager/optimus-manager.conf" 
sudo sh -c "echo 'startup_mode=nvidia' > /etc/optimus-manager/optimus-manager.conf" 
nvidia-force-composition-pipeline
systemctl enable optimus-manager && systemctl start optimus-manager &


# Install s-tui and set to run as admin.
sudo pamac install s-tui --no-confirm


# Install language servers.
sudo chmod +x ~/.config/nvim/lua/alex/lang/lsp/install-servers.sh
~/.config/nvim/lua/alex/lang/lsp/install-servers.sh

# Install lock screen.
sudo pamac install betterlockscreen-git --no-confirm
# Setup lock screen.
# Should this script run every time the screens change?  Yeah.
# betterlockscreen -u ~/.wallpapers/forest-mountain-cloudy-valley.png --blur 0.5
# betterlockscreen -u ~/.wallpapers/misty_mountains.jpg --blur 0.5
betterlockscreen -u ~/.wallpapers/Planets_Nord.jpg --blur 0.5
betterlockscreen -u ~/.wallpapers/Planets_Nord.jpg

# Setup fish (shell).
sudo pamac install fish --no-confirm
fish <<'END_FISH'
	curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
	fisher install IlanCosman/tide@v5t
    echo "3\
          2\
          2\
          4\
          4\
          5\
          2\
          1\
          1\
          2\
          2\
          y\
         " | tide configure
END_FISH