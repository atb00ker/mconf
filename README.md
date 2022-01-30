# MConf

Ansible script for creating backup of configuration files of my machine & restoring them.

- [Getting started](#getting-started)
  - [Creating bootdrive sample](#creating-bootdrive-sample)
- [Usage](#usage)
  - [Backup](#backup)
  - [Restore](#restore)

## Getting started

### Creating bootdrive sample

```
$ lsblk
$ sudo umount /dev/sdb1
$ sudo dd bs=64k if=debian-netinst.iso of=/dev/sdb conv=fdatasync  status=progress
```

## Usage

### Backup

The role for backup is called : `system-backup`

```bash
# Backup and run idempotence check
$ mconf_backup
# Or run from directory
$ cd /home/atb00ker/Documents/develop/mconf
$ sed -i 's/role:.*/role: system-backup/' playbook.yml
$ sudo ansible-playbook -i inventory.yml playbook.yml -K
```

### Restore

The role for restore is called : `system-restore`

1. (root) Connect to network

   1.1. Wireless: You can get the value of `DRIVER` by `wpa_supplicant` & `INTERFACE` by `ip address`.

```bash
wpa_passphrase SSID PASSWORD > /tmp/wpa.conf
wpa_supplicant -i INTERFACE -D Driver -c /tmp/wpa.conf
dhclient INTERFACE
```

2. `curl -L bit.do/mconf-debian | bash -`

Enjoy, now Configure GUI to your wish.
