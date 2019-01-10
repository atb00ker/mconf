mconf
---

system-backup
```bash
$ ansible-playbook -i inventory.yml playbook.yml -K
$ ansible-playbook -i inventory.yml playbook.yml -K --skip-tags "initialize"
```