## Setup repository
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

## Install Docker Engine
```bash
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Start docker service
```bash
sudo systemctl start docker
```

## Add ec2-user to docker group

```bash
sudo usermod -aG docker ec2-user
```