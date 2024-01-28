## How to install KVM on Ubuntu 20.04
1. Install the required packages
    ```bash
    sudo apt -y install bridge-utils cpu-checker libvirt-clients libvirt-daemon qemu qemu-kvm
    ```
3. Authorize Users
    ```bash
    sudo adduser ‘username’ libvirt
    sudo adduser ‘username’ kvm
    ```
3. Check virtualisation capabilities
    ```bash
    kvm-ok
    ## or
    egrep -c '(vmx|svm)' /proc/cpuinfo

    ```
4. Verify the Installation
    ```bash
    virsh list --all
    sudo systemctl status libvirtd
    sudo systemctl enable --now libvirtd
    ```
## Creating a Virtual Machine on Ubuntu 20.04
1. install virt-manager
    ```bash
    sudo apt install virt-manager
    ```

## Using command line
1. Launch a VM
    ```bash
    sudo virt-install --name ubuntu-guest --os-variant ubuntu20.04 --vcpus 2 --ram 2048 --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/ --network bridge=virbr0,model=virtio --graphics none --extra-args='console=ttyS0,115200n8 serial'
    ```

[KVM hypervisor: a beginners’ guide](https://ubuntu.com/blog/kvm-hyphervisor)

[Ubuntu ISO install using virt-install](https://wiki.ubuntu.com/UEFI/virt-install)
1. Prerequisite
    ```bash

    sudo apt install -y virt-manager qemu-efi
    ```
2. Download ISO
    ```bash
    wget http://cdimage.ubuntu.com/ubuntu-server/daily/current/bionic-server-arm64.iso
    ```
3. Create a virtual disk to install the ISO
    ```bash
    qemu-img create -f raw bionic-image1.img +2G
    ```
4. Install Bionic using virt-install
    ```bash
    sudo virt-install --machine=virt --arch=aarch64 --boot loader=/usr/share/qemu-efi/QEMU_EFI.fd --name=bionic-vm2 --virt-type=kvm --boot cdrom,hd --network=default,model=virtio --disk path=/home/ubuntu/bionic-image1.img,format=raw,device=disk,bus=virtio,cache=none --memory=2048 --vcpu=1 --cdrom=./bionic-server-arm64.iso --graphics vnc,listen=10.228.68.8 --check all=off
    ```


## [ Use Ubuntu Cloud Image with KVM](https://medium.com/@art.vasilyev/use-ubuntu-cloud-image-with-kvm-1f28c19f82f8)

## Gist link
* [ManageVMs remotely from a Mac using virt-manager.](https://gist.github.com/davesilva/da709c6f6862d5e43ae9a86278f79188)

* [How to install and use Virt-Manager on Windows 10](https://linux.how2shout.com/how-to-install-and-use-virt-manager-on-windows-10/)

* [How to install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)