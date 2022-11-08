## Proxmox Automation Script

By: [@Script47ph](https://github.com/Script47ph)

### Create VMs with custom cloud-init provisioning

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Script47ph/proxmox-automation/main/pve-create-vms.sh)"
```

Features:
- [x] Easy to use
- [x] Pull latest image from generic cloud
- [x] Update to 5.x kernel
- [x] Enable zram
- [x] Enable ssh password authentication
- [x] Add qemu-guest-agent for better controlling vms

Available distributions:
- [x] Debian 10
- [x] Debian 11
- [x] Ubuntu 18.04
- [x] Ubuntu 20.04
- [x] Ubuntu 22.04
- [x] CentOS 7
- [x] CentOS 8 Stream
- [x] CentOS 9 Stream
- [x] AlmaLinux 8
- [x] AlmaLinux 9
- [x] Rocky Linux 8
- [x] Rocky Linux 9