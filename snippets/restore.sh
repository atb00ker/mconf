#!/bin/bash
# curl -L -s http://rebrandly.do/mconf-debian -o setup.sh; bash setup.sh
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run as root"
    exit 1
fi

su root -c 'apt update'
su root -c 'apt install curl git python3-pip ansible'

read -p "Do you want to clone at location (~/Documents/develop/mconf)? (Y/n) " clone

if [[ "$clone" == [Yy]* ]] ; then
    mkdir -p ~/Documents/develop/
    cd ~/Documents/develop/
    git clone https://github.com/atb00ker/mconf || true
    cd mconf/
fi

cd ~/Documents/develop/mconf/
ansible-galaxy install -r requirements.yml
sed -i 's/role:.*/role: system-restore/' playbook.yml

read -p "Ready to run the playbook? (Y/n) " runPlaybook

if [[ "$runPlaybook" == [Yy]* ]] ; then
    read -p "Enter tags you want to run(i3wm,xfce,raspi): " tags
    ansible-playbook -i inventory.yml playbook.yml -K --become-method su --tags "${tags}"
fi

