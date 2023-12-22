Ansible ad hoc commands are CLI commands used for simple and one-time tasks

**ansible** `<host-pattern>` **-m** `<module-name>` **-a** "`<module-command>`"

## Inventory file

```bash
[dev]

54.145.52.49   ansible_user=ubuntu

[prod]

3.95.196.233  ansible_user=ubuntu
```


## Sample Ansible config file **ansible.cfg**
```bash
[defaults]
inventory = ./inventory/hosts
retry_files_enabled = False
private_key_file = ubuntu-key.pem
host_key_checking = False

[ssh_connection]
pipelining = True
scp_if_ssh = True
```

```bash
ansible all -m ping
```
## Gather ansible facts
```bash
ansible myhost -m setup
```

## List inventory
```bash
ansible-inventory -i inventory --list
```
## Check access 
```bash
ansible all -i inventory -m ping
```

## Run Playbook
```bash
ansible-playbook -i inventory playbook.yml
```

## Organizing Servers Into Groups and Subgroups
```bash
[webservers]
203.0.113.111
203.0.113.112

[dbservers]
203.0.113.113
server_hostname

[development]
203.0.113.111
203.0.113.113

[production]
203.0.113.112
server_hostname
```

## Setting Up Host Aliases

```bash
server1 ansible_host=203.0.113.111
server2 ansible_host=203.0.113.112
server3 ansible_host=203.0.113.113
server4 ansible_host=server_hostname
```

# Setting Up Host Variables
```bash
server1 ansible_host=203.0.113.111 ansible_user=sammy
server2 ansible_host=203.0.113.112 ansible_user=sammy
server3 ansible_host=203.0.113.113 ansible_user=myuser
server4 ansible_host=server_hostname ansible_user=myuser
```
[Ansible Example](https://github.com/ansible/ansible-examples)

## Setting up ansible inventory

[How To Set Up Ansible Inventories](https://www.digitalocean.com/community/tutorials/how-to-set-up-ansible-inventories)