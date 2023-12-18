## Package Management Redhat
[YUM command cheatsheet](https://access.redhat.com/sites/default/files/attachments/rh_yum_cheatsheet_1214_jcs_print-1.pdf)

## Package Management Ubuntu
[apt-get command cheatsheet](https://chenweixiang.github.io/docs/apt_cheat_sheet.pdf)

## Third party repository
### Redhat
Extra Packages for Enterprise Linux (EPEL)
### Ubuntu
Personal Package Archive (PPA)



#### Example Ubuntu
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

### Configure RHEL local repo

```bash
## Mount ISO
mount -t iso9660 -o loop /ISO_absolute_path /mnt/ISO_mount_dir/

## Configure repo
cat > /etc/yum.repos.d/rhel_iso.repo
[RHEL_Repo]
name = RHEL_Repo
baseurl = file:///mnt/ISO_mount_dir/
gpgcheck = 0
```
### Create custom rhel repo local
```bash
# Install createrepo
yum install createrepo

# Copy package
mkdir /path/to/repository
cp /path/to/packages /path/to/repository

createrepo /path/to/repository

# Configure repo 
# /etc/yum.repos.d/myrepo.repo
[myrepo]
name=My Repository
baseurl=file:///path/to/repository/
enabled=1
gpgcheck=0
```

### Setting up ubuntu local repository
```bash
cd /usr/local/mydebs
 dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
 
 cat > /etc/apt/sources.list
 deb deb [trusted=yes] file:/usr/local/mydebs ./

### Script
```bash

#!/bin/bash
# Source: https://askubuntu.com/a/772636
cd /usr/local/myrepo #change accordingly
# Generate the Packages file 
dpkg-scanpackages . /dev/null > Packages 
gzip — keep — force -9 Packages
# Generate the Release file 
cat conf/distributions > Release 
# The Date: field has the same format as the Debian package changelog entries, 
# that is, RFC 2822 with time zone +0000 
echo -e “Date: `LANG=C date -Ru`” >> Release 
# Release must contain MD5 sums of all repository files (in a simple repo just the Packages and Packages.gz files) 
echo -e ‘MD5Sum:’ >> Release 
printf ‘ ‘$(md5sum Packages.gz | cut — delimiter=’ ‘ — fields=1)’ %16d Packages.gz’ $(wc — bytes Packages.gz | cut — delimiter=’ ‘ — fields=1) >> Release 
printf ‘\n ‘$(md5sum Packages | cut — delimiter=’ ‘ — fields=1)’ %16d Packages’ $(wc — bytes Packages | cut — delimiter=’ ‘ — fields=1) >> Release 
# Release must contain SHA256 sums of all repository files (in a simple repo just the Packages and Packages.gz files) 
echo -e ‘\nSHA256:’ >> Release 
printf ‘ ‘$(sha256sum Packages.gz | cut — delimiter=’ ‘ — fields=1)’ %16d Packages.gz’ $(wc — bytes Packages.gz | cut — delimiter=’ ‘ — fields=1) >> Release 
printf ‘\n ‘$(sha256sum Packages | cut — delimiter=’ ‘ — fields=1)’ %16d Packages’ $(wc — bytes Packages | cut — delimiter=’ ‘ — fields=1) >> Release
# Clearsign the Release file (that is, sign it without encrypting it) 
gpg — clearsign — digest-algo SHA512 -o InRelease Release
# Release.gpg only need for older apt versions 
# gpg -abs — digest-algo SHA512 — local-user $USER -o Release.gpg Release
# Get apt to see the changes 
sudo apt-get update
```
