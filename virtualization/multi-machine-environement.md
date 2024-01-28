## Defining Multiple Machines in Vagrantfile

### Vagrantfile

```bash
Vagrant.configure("2") do |config|
    config.vm.define "web" do |web|
        web.vm.box = "ubuntu/trusty64"
        
    end
    config.vm.define "db" do |db|
        db.vm.box = "ubuntu/trusty64"
    end
end
```

### Run Vagrantfile
```bash
    vagrant up
```
### Using Provisioner
1. Destory existing Environment
    ```bash
    vagrant destroy -f

    ```
2. Add hostname
    ```bash
    Vagrant.configure("2") do |config|
        config.vm.define "web" do |web|
            web.vm.box = "ubuntu/trusty64"
            web.vm.hostname = "web.vagrant.vm"
        end
        config.vm.define "db" do |db|
            db.vm.box = "ubuntu/trusty64"
        end
    end
    ```
    ```bash
    vagrant up web
    ```
3. Add shell provisioner
    ```bash
    Vagrant.configure("2") do |config|
        config.vm.define "web" do |web|
            web.vm.box = "ubuntu/bionic64"
            web.vm.hostname = "web.vagrant.vm"
            web.vm.provision "shell" do |shell|
                shell.inline = "apt-get update -y"
                shell.inline = "apt-get install apache2 -y"
            end
        end
        config.vm.define "db" do |db|
            db.vm.box = "ubuntu/bionic64"
            config.vm.provision "shell", inline: $script
        end
    end
    ```

    ```bash
    vagrant reload --provision
    ```
4. Add hostname to db server
```bash
    $script = <<-SCRIPT
export DEBIAN_FRONTEND="noninteractive"
sudo apt-get install -y debconf-utils
sudo debconf-get-selections | grep mysql
sudo debconf-set-selections <<< "mysql-server mysql-serverroot_password password changeme"
sudo debconf-set-selections <<< "mysql-server mysql-serverroot_password_again password changeme"
sudo apt-get install -y mysql-server-5.6
mysql_secure_installation
SCRIPT

    Vagrant.configure("2") do |config|
        config.vm.define "web" do |web|
            web.vm.box = "ubuntu/bionic64"
            web.vm.hostname = "web.vagrant.vm"
            web.vm.provision "shell" do |shell|
                shell.inline = "apt-get update -y"
                shell.inline = "apt-get install apache2 -y"
            end
        end
        config.vm.define "db" do |db|
            db.vm.box = "ubuntu/bionic64"
            config.vm.provision "shell", inline: $script
        end
    end
    ```
```bash
vagrant up db
vagrant ssh db
mysql
```








## Examples 1
```bash
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

$script = <<SCRIPT
    set -x
    echo I am provisioning...
    date > /etc/vagrant_provisioned_at
    echo "hello world"
    yum install mysql-server -y
    /sbin/service mysqld start
    mysql -e "create user 'mycooluser'@'%' identified by 'mypassword'"

SCRIPT
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "chef/centos-6.5"
  config.vm.provision :shell, :inline => $script
```

```bash
vagrant up
vagrant ssh
mysql -uroot
/usr/bin/mysql -u root -p
```

[Multi-Machine](https://developer.hashicorp.com/vagrant/docs/multi-machine)

[install mysql](https://gist.github.com/rrosiek/8190550)

[Installing MySQL (with Debconf)](https://serversforhackers.com/c/installing-mysql-with-debconf)