#!/bin/bash

# Variables
OUTPUTDIR=/var/lib/vz/template/iso
CLOUDINITDIR=/var/lib/vz/snippets
VMNET0=virtio,bridge=
GIT_URL=https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/
DEBIAN_URL=https://cloud.debian.org/images/cloud

# Function
function vmid_check {
    read -p "Enter VM ID : " VMID
    check_id=$(qm list | awk '{print $1}' | grep $VMID)
    if [[ $VMID == $check_id ]]; then
        echo "VM ID already exist"
        vmid_check
    else
        echo "VM ID is available"
    fi
}
function env_var {
    if [[ $choice == "1" ]]; then
        export OUTPUTFILE=debian-10-generic-amd64-daily.qcow2
        export CLOUDIMGURL=${DEBIAN_URL}/buster/daily/latest/debian-10-generic-amd64-daily.qcow2
        export CLOUDINITFILE=vendor-debian-10.yaml
        export CLOUDINITURL=${GIT_URL}/debian-10/vendor-debian-10.yml
        export NAME=Debian-10
    elif [[ $choice == "2" ]]; then
        export OUTPUTFILE=debian-11-generic-amd64-daily.qcow2
        export CLOUDIMGURL=${DEBIAN_URL}/bullseye/daily/latest/debian-11-generic-amd64-daily.qcow2
        export CLOUDINITFILE=vendor-debian-11.yaml
        export CLOUDINITURL=${GIT_URL}/debian-11/vendor-debian-11.yml
        export NAME=Debian-11
    fi
}
function confirmation {
    echo -n "Do you want to use custom settings? [y/n]: "
    read customconfig
    while [[ $customconfig != 'Y' ]] && [[ $customconfig != 'y' ]] && [[ $customconfig != 'N' ]] && [[ $customconfig != 'n' ]];
    do
        echo "Error, your choice not found"
        echo -n "Do you want to use custom settings? [y/n]: "
        read customconfig
    done
    if [[ $customconfig == 'Y' ]] || [[ $customconfig == 'y' ]]; then
        custom
    elif [[ $customconfig == 'N' ]] || [[ $customconfig == 'n' ]]; then
        download
        cloudinit
        sleep 1
        echo "Creating VM..."
        createvm
        echo "Applying Cloud Init..."
        applycloudinit
        sleep 1
    fi
}
function custom {
    read -p "Enter VM Name or leave blank to default (${NAME}): " VMNAME
    read -p "Enter VM CPU or leave blank to default (1): " VMCPU
    read -p "Enter VM Memory in byte or leave blank to default (2048): " VMMEMORY
    read -p "Enter VM Network or leave blank to default (vmbr0): " VMBRIDGE
    read -p "Enter Storage or leave blank to default (local): " PROXMOXSTRG
    read -p "Enter Output Format or leave blank to default (qcow2): " OUTPUTFORMAT
    download
    cloudinit
    sleep 1
    echo "Creating VM..."
    createvm
    echo "Applying Cloud Init..."
    applycloudinit
    sleep 1
}
function download {
    echo "Checking image..."
    sleep 1
    if [[ -f ${OUTPUTDIR}/${OUTPUTFILE} ]]; then
        echo "Image already exist"
    else
        echo "Downloading image..."
        wget -q --show-progress -O ${OUTPUTDIR}/${OUTPUTFILE} ${CLOUDIMGURL}
    fi
}
function cloudinit {
    echo "Checking cloud-init file..."
    sleep 1
    if [[ -f ${CLOUDINITDIR}/${CLOUDINITFILE} ]]; then
        echo "Cloud-init file already exist"
        echo -n "Do you want to overwrite it? [y/n]: "
        read overwrite
        while [[ $overwrite != 'Y' ]] && [[ $overwrite != 'y' ]] && [[ $overwrite != 'N' ]] && [[ $overwrite != 'n' ]]; 
        do
            echo "Error, your choice not found"
            echo -n "Do you want to overwrite it? [y/n]: "
            read overwrite
        done
        if [[ $overwrite == 'Y' ]] || [[ $overwrite == 'y' ]]; then
            echo "Downloading cloud-init file..."
            wget -q --show-progress -O ${CLOUDINITDIR}/${CLOUDINITFILE} ${CLOUDINITURL}
        elif [[ $overwrite == 'N' ]] || [[ $overwrite == 'n' ]]; then
            echo "Skipping..."
        fi
    else
        echo "Downloading cloud-init file..."
        wget -q --show-progress -O ${CLOUDINITDIR}/${CLOUDINITFILE} ${CLOUDINITURL}
    fi
}
function createvm {
    # Environment Variables
    if [[ $VMNAME == "" ]]; then
        export VMNAME=${NAME}
    fi
    if [[ $VMCPU == "" ]]; then
        export VMCPU=1
    fi
    if [[ $VMMEMORY == "" ]]; then
        export VMMEMORY=2048
    fi
    if [[ $VMBRIDGE == "" ]]; then
        export VMBRIDGE=vmbr0
    fi
    if [[ $PROXMOXSTRG == "" ]]; then
        export PROXMOXSTRG=local
    fi
    if [[ $OUTPUTFORMAT == "" ]]; then
        export OUTPUTFORMAT=qcow2
    fi
    qm create ${VMID} --agent 1 --name ${VMNAME} --cores $VMCPU --memory ${VMMEMORY} --net0 ${VMNET0}${VMBRIDGE} 1>/dev/null
    qm importdisk ${VMID} ${OUTPUTDIR}/${OUTPUTFILE} ${PROXMOXSTRG} --format ${OUTPUTFORMAT} 1>/dev/null
    qm set ${VMID} --scsihw virtio-scsi-pci --scsi0 ${PROXMOXSTRG}:${VMID}/vm-${VMID}-disk-0.${OUTPUTFORMAT} --ide2 ${PROXMOXSTRG}:cloudinit --boot c --bootdisk scsi0 --serial0 socket --vga serial0 1>/dev/null
}
function applycloudinit {
    qm set ${VMID} --cicustom "vendor=${PROXMOXSTRG}:snippets/${CLOUDINITFILE}" 1>/dev/null
}

# Main
again='y'
while [[ $again == 'Y' ]] || [[ $again == 'y' ]]; do
    clear
    echo "+================================================================+"
    echo "+                     Proxmox VE - Create VM                     +"
    echo "+     Maintenance by Script47ph - https://script47.pages.dev     +"
    echo "+================================================================+"
    echo "+ [1] Debian 10 - Cloud Image                                    +"
    echo "+ [2] Debian 11 - Cloud Image                                    +"
    echo "+ [3] Exit                                                       +"
    echo "+================================================================+"
    read -p " Choose your choice [1 - 3] : " choice
    echo ""
    case $choice in

    1)
        echo " Debian 10 - Cloud Image"
        vmid_check
        env_var
        confirmation
        echo "VM Created. Exiting..."
        sleep 1
        exit 0
        ;;

    2)
        echo " Debian 11 - Cloud Image"
        vmid_check
        env_var
        confirmation
        echo "VM Created. Exiting..."
        sleep 1
        exit 0
        ;;

    3)
        exit
    ;;
    *) echo "Error, please choose between 1 to 8" ;;
    esac
    echo -n "Back to menu? [y/n]: "
    read again
    while [[ $again != 'Y' ]] && [[ $again != 'y' ]] && [[ $again != 'N' ]] && [[ $again != 'n' ]]; do
        echo "Error, your choice not found"
        echo -n "Back to menu? [y/n]: "
        read again
    done
done
