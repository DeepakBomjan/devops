# create nfs host file nfs configuration
```bash
cat > /home/ubuntu/ansible/exports.j2
{{ share_path }} *(rw)
```

## Inventory file
```bash
[nfs]
nfs-server ansible_host=192.168.1.100 ansible_user=your_ssh_user

[remote]
remote-client ansible_host=192.168.1.101 ansible_user=your_ssh_user

```

## Create hosts file
```bash
cat > /home/ubuntu/ansible/etc.hosts.j2
127.0.0.1	localhost {{ ansible_hostname}}
{{ nfs_ip }}	{{ nfs_hostname }}
```

## Create playbook
```bash
cat > /home/ubuntu/ansible/nfs.yml

- hosts: nfs
      become: yes
      vars:
        share_path: /mnt/nfsroot
      tasks:
        - name: install nfs
          yum:
            name: nfs-utils
            state: latest
        - name: start and enable nfs-server
          service:
            name: nfs-server
            state: started
            enabled: yes
        - name: configure exports
          template:
            src: /home/ubuntu/ansible/exports.j2
            dest: /etc/exports
          notify: update nfs
      handlers:
        - name: update nfs exports
          command: exportfs -a
          listen: update nfs
- hosts: remote
      become: yes
      vars:
        nfs_ip: "{{ hostvars['nfs']['ansible_default_ipv4']['address'] }}"
        nfs_hostname: "{{ hostvars['nfs']['ansible_hostname'] }}"
      vars_files:
        - /home/ubuntu/ansible/user-list.txt
      tasks:
        - name: configure hostsfile
          template:
            src: /home/ubuntu/ansible/etc.hosts.j2
            dest: /etc/hosts
        - name: get file status
          stat:
            path: /opt/user-agreement.txt
          register: filestat
        - name: debug info
          debug:
            var: filestat
        - name: create users
          user:
            name: "{{ item }}"
          when:  filestat.stat.exists
          loop: "{{ users }}"

```
## Execute playbook
```bash
ansible-playbook /home/ansible/nfs.yml
```

## Create user lists
```bash
cat > user-list.txt
users:
- user1
- user2
- user3
```