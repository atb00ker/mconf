#!/bin/bash

# Simple script to help automatically restore
# my machine setup
set -e -x

debian_packages() {
# Add keys
## vscode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
## chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Start installation
apt update & full-upgrade
apt install curl apt-transport-https xclip git code google-chrome-stable make ansible undistract-me
if [ "$GNOME" ]; then
    apt install gnome-tweak-tool
    ## Remove Dock
    apt remove gnome-shell-extension-ubuntu-dock
fi
if [ "$WPS" ]; then
    wget -O wps-office.deb http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
    wget -O web-office-fonts.deb http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb
    dpkg -i wps-office.deb
    apt-get -f install
    dpkg -i web-office-fonts.deb
fi
if [ "$PYTHON" ]; then
    apt install python python3 python3-pip
fi

# clean
rm -f microsoft.gpg wps-office.deb web-office-fonts.deb
apt autoremove
apt autoclean
}

gnome_configure() {
# Gnome Hide-top-bar
mkdir -p ~/.local/share/gnome-shell/extensions/
cd ~/.local/share/gnome-shell/extensions/
git clone https://github.com/mlutfy/hidetopbar.git hidetopbar@mathieu.bidon.ca
cd hidetopbar@mathieu.bidon.ca
make schemas
gnome-shell-extension-tool -e hidetopbar@mathieu.bidon.ca
gnome-shell --replace &
# settings
dconf load /org/gnome/ < ../backup/files/gnome.txt
sudo dconf update
}

common_configuration() {
# misc
mkdir ~/Documents/develop
git config --global user.email "ajay39in@gmail.com"
git config --global user.name "Ajay Tripathi"
# vscode
code --install-extension ms-vscode.atom-keybindings
mkdir -p ~/.config/Code/User/
cp -p $MCONF_PATH/backup/files/vscode/keybindings.json ~/.config/Code/User/keybindings.json
cp -p $MCONF_PATH/backup/files/vscode/settings.json ~/.config/Code/User/settings.json
# bashrc
cat $MCONF_PATH/backup/files/custom-aliases >> ~/.bashrc
cat $MCONF_PATH/restore/files/undistract-me >> ~/.bashrc
cp -r -p $MCONF_PATH/backup/files/autostart ~/.config/autostart
}

printf "\e[1;31m\nRemember to check\n1.Tweak tool settings\n2.GUI settings\n3.Chrome>settings>Appearance>'Use system title bar and borders'\nComplete! \n\e[0m"