!/bin/bash
# Everything that is essential, regardless of hardware and use case.

# Ensure packages are up to date.
sudo pacman -Syu

# Essentials.
sudo pacman -S git base-devel gum

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
sudo pamac install firefox  --no-confirm

# Fonts.
sudo pamac install nerd-fonts-jetbrains-mono --no-confirm

# Terminal.
sudo pamac install alacritty --no-confirm

# Gnome stuff.
sudo pamac install gnome-browser-connector gnome-tweaks --no-confirm

# i3 stuff.
sudo pamac install feh xborder-git cronie rofi rofi-greenclip picom --no-confirm
chmod +x ~/.config/picom/scripts/toggle-picom-inactive-opacity.sh
# Stuff for polybar.
chmod +x ~/.config/polybar.personal/scripts/check-read-mode-status.sh
sudo pamac install polybar python-pywal pywal-git networkmanager-dmenu-git calc --no-confirm

# Install s-tui and set to run as admin.
sudo pamac install s-tui --no-confirm

# Manuals.
# man-db база данных дл€ того, чтобы подт€гивать информацию о приложени€х, прикольна€ вещь, лучше чем -h
# использовать так: man <им€ того, о чем хочешь узнать инфу>
sudo pamac install man-db --no-confirm

# Some aesthetic stuff.
sudo pamac install cmatrix bonsai.sh-git pipes.sh lolcat shell-color-scripts --no-confirm

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

# SDDM Login Manager
sudo pamac install sddm sddm-sugar-dark sddm-sugar-candy-git archlinux-tweak-tool-git --no-confirm
sudo systemctl disable display-manager && sudo systemctl enable sddm
sudo touch /etc/sddm.conf
sudo cp ~/.wallpapers/National_Park_Nord.png /usr/share/sddm/themes/sugar-candy/
sudo mv /usr/share/sddm/themes/sugar-candy/National_Park_Nord.png /usr/share/sddm/themes/sugar-candy/wall_secondary.png

# Media.
sudo pamac install playerctl --no-confirm

# Install lock screen.
sudo pamac install betterlockscreen-git --no-confirm
# Setup lock screen.
# Should this script run every time the screens change?  Yeah.
betterlockscreen -u ~/.wallpapers/Planets_Nord.png --display 1
betterlockscreen -u ~/.wallpapers/Planets_Nord.png --blur 0.5 --display 1
