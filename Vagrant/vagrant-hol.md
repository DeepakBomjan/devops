## [Install Vagrant on Ubuntu](https://developer.hashicorp.com/vagrant/downloads#Linux)
1. Install VirtualBox
    ```bash
    sudo apt-get update
    sudo apt-get install -y virtualbox
    sudo apt-get install -y virtualbox—ext–pack
    ```
2. Install Vagrant
    ```bash
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/    hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp. com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install vagrant
    ```
3. Install lxc container. Start `lxd init` and choose storage initialization to **dir**
    ```bash
    sudo apt-get install -y lxc-utils lxc-templates
    lxd init
    vagrant plugin install vagrant-lxc
    ```
## Test vagrant box
```bash
vagrant init -m debian/jessie64 --box-version 8.7.0
vagrant up --provider=lxc
```


## References 
[How to create a VirtualBox VM from command line](https://andreafortuna.org/2019/10/24/how-to-create-a-virtualbox-vm-from-command-line/)

## List gcloud instance
```bash
gcloud compute instances list
```
[gcloud cli](https://cloud.google.com/sdk/gcloud/reference)

## Start the Google Cloud Instance
```bash
gcloud compute instances create instance-2 \
  --enable-nested-virtualization \
  --zone=us-central1-a \
  --metadata=ssh-keys=devopslab:ecdsa-sha2-nistp256\ AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFBbpYZTVJL5ajoiQK35\+NH3FovDWjiHNa3jBiRNRgHJVBTsu6M8Nq0Fz4zESjUYYlFtuG\+VZDeDn88PfsVuwBw=\ devopslab \
  --image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240125 \
  --min-cpu-platform="Intel Haswell"
```
## Check Virtualization Support on Ubuntu 20.04
```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
sudo kvm-ok
```
## Install KVM on Ubuntu 20.04
```bash
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
sudo adduser ‘username’ libvirt
sudo adduser ‘[username]’ kvm
# Verify the Installation
virsh list --all
sudo systemctl status libvirtd
sudo systemctl enable --now libvirtd
```
## Creating a Virtual Machine on Ubuntu 20.04
```bash
sudo apt install virt-manager
```
1. Virt Manager GUI
2. Using Command Line

[What's a Linux container?](https://www.redhat.com/en/topics/containers/whats-a-linux-container)
[A brief history of containers](https://www.redhat.com/en/topics/containers/whats-a-linux-container)
[First steps with LXD](https://documentation.ubuntu.com/lxd/en/latest/tutorial/first_steps/)
[Vagrant Google Compute Engine (GCE) Provider](https://github.com/mitchellh/vagrant-google?tab=readme-ov-file#vagrant-google-compute-engine-gce-provider)

[Enable nested virtualization](https://cloud.google.com/compute/docs/instances/nested-virtualization/enabling)

## Vagrant Resource
[Vagrant Documentation](https://developer.hashicorp.com/vagrant/docs)
## Vagrantfile reference
[vagrantfile](https://github.com/vipin-k/vagrantfile/tree/master)
[Creating a Vagrantfile](https://mariadb.com/kb/en/creating-a-vagrantfile/)
## [Vagrant Tutorial](https://developer.hashicorp.com/tutorials/library?product=vagrant)

## VirtualBox VM
[Creating virtualbox vm using cli](https://www.oracle.com/technical-resources/articles/it-infrastructure/admin-manage-vbox-cli.html)
[Virtualbox cli](https://www.perkin.org.uk/posts/create-virtualbox-vm-from-the-command-line.html)