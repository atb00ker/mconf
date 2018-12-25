#!/bin/bash

# Simple script to help automatically backup
# files and settings before factory reset

init_backup() {
if [ "$#" -ne 3 ]; then
  printf "
\e[1;33mYou need to pass arugments to run this script, example:
MCONF_PATH=\"~/mconf\"
INCLUDE_GNOME=1
INCLUDE_VSCODE=1
init_backup \$MCONF_    PATH \$INCLUDE_GNOME \$INCLUDE_VSCODE
\n\e[1;31mNo backup made!\n\e[0m"
    exit 0
fi

BACKUP_FOLDER="$1/backup/files"

rm -rf $BACKUP_FOLDER
mkdir -p $BACKUP_FOLDER

if [ "$2" -eq 1 ]; then
    dconf dump /org/gnome/ > $BACKUP_FOLDER/gnome.txt
    sed -i '/virtual-root=/d' $BACKUP_FOLDER/gnome.txt
    sed -i '/last-save-directory=/d' $BACKUP_FOLDER/gnome.txt
fi
if [ "$3" -eq 1 ]; then
    mkdir -p $BACKUP_FOLDER/vscode
    cp -p ~/.config/Code/User/keybindings.json $BACKUP_FOLDER/vscode/keybindings.json
    cp -p ~/.config/Code/User/settings.json $BACKUP_FOLDER/vscode/settings.json
    sed -i '/python.pythonPath/d' $BACKUP_FOLDER/vscode/settings.json
fi

sed -n '/# custom aliases/,/# end custom aliases/p;/# end custom aliases/q' ~/.bashrc > $BACKUP_FOLDER/custom-aliases
cp -p -r ~/.config/autostart $BACKUP_FOLDER


printf "
\e[1;31mRemember to backup:
1. Documents
2. Downloads
3. Code(Git)
\nRemove useless lines & potentially sensitive data!
\nComplete! \n\e[0m"
}

printf "\e[1;31mbackup.sh is ready! Call init_backup() to initiate backup...\n\e[0m"