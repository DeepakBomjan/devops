1. Install Vagrant
    [go to](https://developer.hashicorp.com/vagrant/install)
2. Verify the installation
    ```bash
    vagrant
    ```
3. Initialize a project directory
    ```bash
    mkdir vagrant_getting_started
    cd vagrant_getting_started
    vagrant init hashicorp/bionic64
    ```
4. Install a box
    ```bash
    vagrant box add hashicorp/bionic64
    ```
5. Use a box
    ```bash
    ## add below vagrant config to vagrantfile
    Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"
    end
    ```
    >  To specify an explicit version of a box by specifying config.vm.box_version
    ```bash
    Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"
    config.vm.box_version = "1.0.282"
    end
    ```
    > To specify the URL to a box directly using config.vm.box_url
    ```bash
    Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/bionic64"
    config.vm.box_url = "https://vagrantcloud.com/hashicorp/bionic64"
    end
    ```
6. Find more boxes
    
    [Box search page](https://vagrantcloud.com/boxes/search)

7. Creating a Base Box
    [Go to](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox/boxes)