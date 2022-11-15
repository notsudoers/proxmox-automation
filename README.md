## Proxmox Automation Script

### Create VMs with custom cloud-init provisioning

#### Proxmox Debian Method

Script for proxmox debian installation method.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Script47ph/proxmox-automation/main/pve-create-vms.sh)"
```

#### Proxmox Iso Method

Script for proxmox iso installation method. Add "snippets" to the content of local storage via proxmox dashboard (Datacenter > Storage > local > edit) before using this script.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Script47ph/proxmox-automation/main/pve-create-vms-iso.sh)"
```

Features:
- [x] Easy to use
- [x] Pull latest image from generic cloud
- [x] Update to 5.x kernel
- [x] Enable zram
- [x] Enable ssh password authentication
- [x] Add qemu-guest-agent for better controlling vms
- [x] Add dedicated speedtest (Powered by Fast.com - Netflix). Thanks to [ddo/fast](https://github.com/ddo/fast) for bringing this to the cli world.

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