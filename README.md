## Proxmox Automation Script

### Create VMs with custom cloud-init provisioning

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Script47ph/proxmox-automation/main/pve-create-vms.sh)"
```

Features:
- [x] Easy to use
- [x] Pull latest image from generic cloud
- [x] Update to 5.x kernel
- [x] Adding zram
- [x] Enable ssh password authentication
- [x] Add qemu-guest-agent for better controlling vms

Available distributions:
- [x] Debian 10
- [x] Debian 11
- [ ] Ubuntu 18.04
- [ ] Ubuntu 20.04
- [ ] Ubuntu 22.04
- [ ] CentOS 7
- [ ] CentOS 8 Stream
- [ ] CentOS 9 Stream
- [ ] AlmaLinux 8
- [ ] AlmaLinux 9
- [ ] Rocky Linux 8
- [ ] Rocky Linux 9