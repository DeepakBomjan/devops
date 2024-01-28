## What are Vagrant Boxes?
* They are the package format for Vagrant environments
* Vagrant box commands:
    ```bash
    vagrant box add <ADDRESS>
    vagrant box list
    vagrant box outdated
    vagrant box prune
    vagrant box remove <NAME>
    vagrant box update
    vagrant init hashicorp/precise64
    ```

## Creating a Base box
[Installation/MinimalCD](https://help.ubuntu.com/community/Installation/MinimalCD)
1. Download ubuntu minimal cd
```bash
    mkdir vagrant_box
    cd vagrant_box
    curl http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/mini.iso -o mini.iso

```
2. Create virtual machine on VirtualBOx
    * Set machine type **ubuntu64** 
    * Set memory to 512 MB
    * Select disk type **VMDK** and size to **40GB** and select _dynamically allocated_
    * Go to virtual machine setting and uncheck **Enable Audio ** and **USB port**
    * Go to **Network** and **Advanced** and **Port Forwarding**. Set ssh **Host Port** to 2222 and **Guest Port** 22
    * Click on **Storage** , Controller IDE , click on _cdrom_ and **Choose Virtual Optical Disk File..** and select the  _mini.iso_ file just downloaded.
    * Make sure networking is selected as **NAT**.
    * Start the machine
    * create user as "`vagrant`"
    * Password: `vargrant`
    * Select following Packages
        * `OpenSSH Server`
        * `Basic Ubuntu Server`
    * Go to Virtual Machine **Setting** and **Storage** and remove installation media: _mini.iso_.
    * Login to the system 
    * Change password of root user to  `vagrant`
        ```bash
        passwd root
        ```

    * Create sudoers file for vagrant user and set _NOPASSWD_
        ```bash
        visudo -f /etc/sudoers.d/vagrant
        ## Add this
        vagrant ALL=(ALL) NOPASSWD:ALL
        ```
    * Copy Vagrant SSH key
        [SSH key](https://github.com/hashicorp/vagrant/blob/main/keys/vagrant.pub)

        ```bash
        mkdir /home/vagrant/.ssh
        chmod 0700 /home/vagrant/.ssh
        cd /home/vagrant/.ssh
        wget https://github.com/hashicorp/vagrant/blob/main/keys/vagrant.pub
        mv vagrant.pub authorized_keys
        chmod 0600 authorized_keys
        cd /home/vagrant
        chown -R vagrant .ssh
        ```
    * Configure Openssh config file
        ```bash
            vi /etc/ssh/sshd_config
        ```
        * Add at the bottom of file
        ```bash
            AuthorizedKeysFile %h/.ssh/authorized_keys
        ```
        * Restart ssh service
        ```bash
            service ssh restart
        ```
    * Install VirtualBox Header
        ```bash
        apt-get install -y gcc build-essential git linux-headers-$(uname -r) dkms
        ```
    * Install VirtualBox Tools
        
        * Go to **Devices** -> **Insert Guest Additions CD images..**
        * Mount CD-ROM
        ```bash
            mount /dev/cdrom /mnt
            cd /mnt
            ./VBoxLinuxAdditions.run
            #  write zeroes to all empty space on the volume
            dd if=/dev/zero of=/EMPTY bs=1M
            rm -f /EMPTY

        ```

    
3. Package the VagrantBox
    ```bash
    vagrant package --base ubuntu64-base
    ls
    vagrant box add ubuntu64 packages.box
    vagrant box list
    
    ```
4. Initialize vagrant project
    ```bash
    vagrant init ubuntu64 -m
    cat vagrantfile
    vagrant up
    vagrant ssh
    ```
    

    


.



