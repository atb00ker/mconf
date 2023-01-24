#!/bin/bash
# curl -L -s http://bit.do/mconf-debian -o setup.sh; bash setup.sh
if [ "$EUID" -eq 0 ]; then
    echo "Please do not run as root"
    exit 1
fi

su root -c 'apt update'
su root -c 'apt install curl git python3-pip'
su root -c 'pip3 install ansible'

export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin

mkdir -p ~/Documents/develop/
cd ~/Documents/develop/
git clone https://github.com/atb00ker/mconf || true
cd mconf/

read -p "Enter tags you want to run: " tags

ansible-galaxy install -r requirements.yml
sed -i 's/role:.*/role: system-restore/' playbook.yml
ansible-playbook -i inventory.yml playbook.yml -K --become-method su --tags "${tags}"
