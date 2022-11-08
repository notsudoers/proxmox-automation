#!/bin/bash

# Variables
OUTPUTDIR=/var/lib/vz/template/iso
CLOUDINITDIR=/var/lib/vz/snippets
VMNET0=virtio,bridge=
GIT_URL=https://raw.githubusercontent.com/Script47ph/Linux-Docs/main/Linux/Setup/Debian/Private-Cloud/Proxmox-Virtual-Environment/cloud-init/
DEBIAN_URL=https://cloud.debian.org/images/cloud
UBUNTU_URL=https://cloud-images.ubuntu.com/daily/server
CENTOS_URL=https://cloud.centos.org/centos
ALMA_URL=https://repo.almalinux.org/almalinux
ROCKY_URL=https://download.rockylinux.org/pub/rocky

# Function
function run {
    read -p "Enter VM ID : " VMID
    check_id=$(qm list | awk '{print $1}' | grep $VMID)
    if [[ $VMID == $check_id ]]; then
        echo "VM ID already exist"
        run
    else
        echo "VM ID is available"
    fi
    env_var
    confirmation
    echo "VM Created. Exiting..."
    sleep 1
    exit 0
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
    elif [[ $choice == "3" ]]; then
        export OUTPUTFILE=ubuntu-18.04-server-cloudimg-amd64-daily.qcow2
        export CLOUDIMGURL=${UBUNTU_URL}/bionic/current/bionic-server-cloudimg-amd64.img
        export CLOUDINITFILE=vendor-bionic.yaml
        export CLOUDINITURL=${GIT_URL}/bionic/vendor-bionic.yml
        export NAME=Ubuntu-18.04
    elif [[ $choice == "4" ]]; then
        export OUTPUTFILE=ubuntu-20.04-server-cloudimg-amd64-daily.qcow2
        export CLOUDIMGURL=${UBUNTU_URL}/focal/current/focal-server-cloudimg-amd64.img
        export CLOUDINITFILE=vendor-focal.yaml
        export CLOUDINITURL=${GIT_URL}/focal/vendor-focal.yml
        export NAME=Ubuntu-20.04
    elif [[ $choice == "5" ]]; then
        export OUTPUTFILE=ubuntu-22.04-server-cloudimg-amd64-daily.qcow2
        export CLOUDIMGURL=${UBUNTU_URL}/jammy/current/jammy-server-cloudimg-amd64.img
        export CLOUDINITFILE=vendor-jammy.yaml
        export CLOUDINITURL=${GIT_URL}/jammy/vendor-jammy.yml
        export NAME=Ubuntu-22.04
    elif [[ $choice == "6" ]]; then
        export OUTPUTFILE=CentOS-7-x86_64-GenericCloud-2111.qcow2
        export CLOUDIMGURL=${CENTOS_URL}/7/images/CentOS-7-x86_64-GenericCloud-2111.qcow2
        export CLOUDINITFILE=vendor-centos-7.yaml
        export CLOUDINITURL=${GIT_URL}/centos-7/vendor-centos-7.yml
        export NAME=CentOS-7
    elif [[ $choice == "7" ]]; then
        export OUTPUTFILE=CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2
        export CLOUDIMGURL=${CENTOS_URL}/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2
        export CLOUDINITFILE=vendor-centos-8-stream.yaml
        export CLOUDINITURL=${GIT_URL}/centos-8-stream/vendor-centos-8-stream.yml
        export NAME=CentOS-8-Stream
    elif [[ $choice == "8" ]]; then
        export OUTPUTFILE=CentOS-Stream-GenericCloud-9-20220919.0.x86_64.qcow2
        export CLOUDIMGURL=${CENTOS_URL}/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20220919.0.x86_64.qcow2
        export CLOUDINITFILE=vendor-centos-9-stream.yaml
        export CLOUDINITURL=${GIT_URL}/centos-9-stream/vendor-centos-9-stream.yml
        export NAME=CentOS-9-Stream
    elif [[ $choice == "9" ]]; then
        export OUTPUTFILE=AlmaLinux-8-GenericCloud-latest.x86_64.qcow2
        export CLOUDIMGURL=${ALMA_URL}/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2
        export CLOUDINITFILE=vendor-rhel-8-based.yaml
        export CLOUDINITURL=${GIT_URL}/rhel-based/vendor-rhel-8-based.yml
        export NAME=Almalinux-8
    elif [[ $choice == "10" ]]; then
        export OUTPUTFILE=AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
        export CLOUDIMGURL=${ALMA_URL}/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
        export CLOUDINITFILE=vendor-rhel-9-based.yaml
        export CLOUDINITURL=${GIT_URL}/rhel-based/vendor-rhel-9-based.yml
        export NAME=Almalinux-9
    elif [[ $choice == "11" ]]; then
        export OUTPUTFILE=Rocky-8-GenericCloud.latest.x86_64.qcow2
        export CLOUDIMGURL=${ROCKY_URL}/8/images/x86_64/Rocky-8-GenericCloud.latest.x86_64.qcow2
        export CLOUDINITFILE=vendor-rhel-8-based.yaml
        export CLOUDINITURL=${GIT_URL}/rhel-based/vendor-rhel-8-based.yml
        export NAME=Rockylinux-8
    elif [[ $choice == "12" ]]; then
        export OUTPUTFILE=Rocky-9-GenericCloud.latest.x86_64.qcow2
        export CLOUDIMGURL=${ROCKY_URL}/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2
        export CLOUDINITFILE=vendor-rhel-9-based.yaml
        export CLOUDINITURL=${GIT_URL}/rhel-based/vendor-rhel-9-based.yml
        export NAME=Rockylinux-9
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
    echo "+=================================================================+"
    echo "+                     Proxmox VE - Create VM                      +"
    echo "+      Maintenance by Script47ph - https://script47.pages.dev     +"
    echo "+=================================================================+"
    echo "+  [1] Debian 10 - Cloud Image                                    +"
    echo "+  [2] Debian 11 - Cloud Image                                    +"
    echo "+  [3] Ubuntu 18.04 - Cloud Image                                 +"
    echo "+  [4] Ubuntu 20.04 - Cloud Image                                 +"
    echo "+  [5] Ubuntu 22.04 - Cloud Image                                 +"
    echo "+  [6] CentOS 7 - Cloud Image                                     +"
    echo "+  [7] CentOS 8 Stream - Cloud Image                              +"
    echo "+  [8] CentOS 9 Stream - Cloud Image                              +"
    echo "+  [9] AlmaLinux 8 - Cloud Image                                  +"
    echo "+ [10] Almalinux 9 - Cloud Image                                  +"
    echo "+ [11] Rocky Linux 8 - Cloud Image                                +"
    echo "+ [12] Rocky Linux 9 - Cloud Image                                +"
    echo "+ [13] Exit                                                       +"
    echo "+=================================================================+"
    read -p " Choose your choice [1 - 13] : " choice
    echo ""
    case $choice in

    1)
        echo " Debian 10 - Cloud Image"
        run
        ;;

    2)
        echo " Debian 11 - Cloud Image"
        run
        ;;
    3)
        echo " Ubuntu 18.04 - Cloud Image"
        run
        ;;

    4)
        echo " Ubuntu 20.04 - Cloud Image"
        run
        ;;
    
    5)
        echo " Ubuntu 22.04 - Cloud Image"
        run
        ;;
    
    6)
        echo " CentOS 7 - Cloud Image"
        run
        ;;

    7)
        echo " CentOS 8 Stream - Cloud Image"
        run
        ;;

    8)
        echo " CentOS 9 Stream - Cloud Image"
        run
        ;;
    
    9)
        echo " AlmaLinux 8 - Cloud Image"
        run
        ;;

    10)
        echo " AlmaLinux 9 - Cloud Image"
        run
        ;;

    11)
        echo " Rocky Linux 8 - Cloud Image"
        run
        ;;
    
    12)
        echo " Rocky Linux 9 - Cloud Image"
        run
        ;;

    13)
        exit
    ;;
    *) echo "Error, please choose between 1 to 13" ;;
    esac
    echo -n "Back to menu? [y/n]: "
    read again
    while [[ $again != 'Y' ]] && [[ $again != 'y' ]] && [[ $again != 'N' ]] && [[ $again != 'n' ]]; do
        echo "Error, your choice not found"
        echo -n "Back to menu? [y/n]: "
        read again
    done
done
