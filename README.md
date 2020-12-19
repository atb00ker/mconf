# mconf

Ansible script for creating backup of configuration files of my machine & restoring them.

# Getting started

## Creating bootdrive sample

```
$ lsblk
$ sudo umount /dev/sdb1
$ sudo dd bs=64k if=debian-netinst.iso of=/dev/sdb conv=fdatasync  status=progress
```

## Installation

1. Disk paritions: `/, swap, EFI`
2. Installations: `standard system utilities`

# Usage

## Backup : `role: system-backup`

```bash
$ ansible-playbook -i inventory.yml playbook.yml -K
$ ansible-playbook -i inventory.yml playbook.yml -K --skip-tags "initialize"
```
### Options

#### Configurations
- initialize  : Delete old backups & create folder structure

#### Systems:
- raspi   : Commands for Raspberry Pi devices
- netinst : Commands for Normal Debian systems

#### Additional Software
- vscode      : Backup vscode configurations

## Restore : `role: system-restore`

```bash
$ ansible-playbook -i inventory.yml playbook.yml -K --tags "netinst,python,vscode,spotify"
```

### Options

#### Systems:
- raspi   : Commands for Raspberry Pi devices
- netinst : Commands for Normal Debian systems

#### Additional Software
- python      : Python requirements
- amd-graphics: Systems that have amd graphics card
- keybase     : Install keybase
- spotify     : Install Spotify
- vscode      : Restore vscode configurations
