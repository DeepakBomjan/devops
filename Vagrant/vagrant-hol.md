## [Install Vagrant on Ubuntu](https://developer.hashicorp.com/vagrant/downloads#Linux)
1. Install VirtualBox
    ```bash
    sudo apt-get update
    sudo apt-get install virtualbox
    sudo apt-get install virtualbox—ext–pack
    ```
2. Install Vagrant
    ```bash
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/    hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp. com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install vagrant
    ```
3. Install lxc container. Start `lxd init` and choose storage initialization to **dir**
    ```bash
    sudo apt-get install lxc-utils lxc-templates
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
gcloud compute instances create instance-4 --project=playground-s-11-30101b5f --zone=us-central1-a --machine-type=e2-medium --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default --metadata=ssh-keys=devopslab:ecdsa-sha2-nistp256\ AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFBbpYZTVJL5ajoiQK35\+NH3FovDWjiHNa3jBiRNRgHJVBTsu6M8Nq0Fz4zESjUYYlFtuG\+VZDeDn88PfsVuwBw=\ devopslab --maintenance-policy=MIGRATE --provisioning-model=STANDARD --service-account=824715130556-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --create-disk=auto-delete=yes,boot=yes,device-name=instance-4,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240125,mode=rw,size=10,type=projects/playground-s-11-30101b5f/zones/us-central1-a/diskTypes/pd-balanced --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --labels=goog-ec-src=vm_add-gcloud --reservation-affinity=any  --enable-nested-virtualization
```

[What's a Linux container?](https://www.redhat.com/en/topics/containers/whats-a-linux-container)
[A brief history of containers](https://www.redhat.com/en/topics/containers/whats-a-linux-container)
[First steps with LXD](https://documentation.ubuntu.com/lxd/en/latest/tutorial/first_steps/)
[Vagrant Google Compute Engine (GCE) Provider](https://github.com/mitchellh/vagrant-google?tab=readme-ov-file#vagrant-google-compute-engine-gce-provider)
