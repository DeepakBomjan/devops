#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/tmp/user_data_log.out 2>&1

# Below variable is resolved during the rendering of the Terraform template file.

# Installing Docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

## Create HOL Users

github_repo="https://github.com/DeepakBomjan/devops.git"

for i in {1..10}; do
    username="hol_user$i"
    password="changeme"

    # Check if the user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
    else
        # Create user with the specified username and set the password
        sudo useradd -m -s /bin/bash "$username"
        echo -e "$password\n$password" | sudo passwd "$username"

        # Add user to the "docker" group
        sudo usermod -aG docker "$username"

        # Add user to the "sudo" group
        sudo usermod -aG sudo "$username"
        echo "$username ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-home-lab-users

        # Clone the GitHub repository to the user's home directory
        sudo -u "$username" git clone "$github_repo" /home/"$username"/devops

        # Enable password authentication
         sed -i 's/no/yes/g' /etc/ssh/sshd_config.d/50-cloud-init.conf
         systemctl restart sshd
        echo "User $username created with password $password, added to the 'docker' group, and repository cloned to the home directory."
        
    fi
done


