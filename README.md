# mconf

Ansible script for creating backup of configuration files of my machine & restoring them.

# Getting started

## Creating bootdrive sample

```
$ lsblk
$ sudo umount /dev/sdb1
$ sudo dd bs=4M if=debian-netinst.iso of=/dev/sdb conv=fdatasync  status=progress
```

## Installation

1. Disk paritions: `/, swap, EFI`
2. Installations: `standard system utilities`

# Usage

1. Backup : `- role: system-backup`

```bash
$ ansible-playbook -i inventory.yml playbook.yml -K
$ ansible-playbook -i inventory.yml playbook.yml -K --skip-tags "initialize"
```

2. Restore : `- role: system-restore`

```bash
$ ansible-playbook -i inventory.yml playbook.yml -K
$ ansible-playbook -i inventory.yml playbook.yml -K --tags "basic"
```

## Options

- initialize : create folder structure / delete old backups
- vscode     : vscode configurations
- system     : system configurations
- basic      : basic requirements
- python     : basic Python requirements
