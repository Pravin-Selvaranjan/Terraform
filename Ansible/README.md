# Ansible

![ansible (1)](https://user-images.githubusercontent.com/110179866/188485780-7ac2fbc0-bc28-4470-8a07-42eb0760d227.jpeg)



Ansible is one of the most used tools for managing cloud and on-premises infrastructure. If you are looking for a flexible and powerful tool to automate your infrastructure management and configuration tasks Ansible is the way to go.

## Benefits of Ansible


- A free and open-source community project with a huge audience.
- Battle-tested over many years as the preferred tool of IT wizards.
- Easy to start and use from day one, without the need for any special coding skills.
- Simple deployment workflow without any extra agents.
- Includes some sophisticated features around modularity and reusability that come in handy as users become more proficient.
- Extensive and comprehensive official documentation that is complemented by a plethora of online material produced by its community.
- To sum up, Ansible is simple yet powerful, agentless, community-powered, predictable, and secure.

## Concepts and Terms

- Host: A remote machine managed by Ansible.

- Group: Several hosts grouped together that share a common attribute.

- Inventory: A collection of all the hosts and groups that Ansible manages. Could be a static file in the simple cases or we can pull the inventory from remote sources, such as cloud providers.

- Modules: Units of code that Ansible sends to the remote nodes for execution.

- Tasks: Units of action that combine a module and its arguments along with some other parameters.

- Playbooks: An ordered list of tasks along with its necessary parameters that define a recipe to configure a system.

- Roles: Redistributable units of organization that allow users to share automation code easier. Learn why Roles are useful useful in Ansible.

- YAML: A popular and simple data format that is very clean and understandable by humans.


![1_W58VFc0-DYHd1uUS3DMsTA](https://user-images.githubusercontent.com/110179866/188485924-64d438b5-3d55-490d-a321-8a6a7eee4309.png)




## Ansible is AGENTLESS

- Ansible is agentless, meaning that it does not install software on the nodes that it manages. This removes a potential point of failure and security vulnerability and simultaneously saves system resources.



# Configuration Management

## Setting up Virtual Machines using Vagrant in order to utilise Ansible

- Run the Vagrantfile using `vagrant up`
- SSH into each VM using `vagrant ssh db` (db for example)
- Once we are up and running ensure to ssh into each VM and run update and upgrade `sudo apt-get update -y` etc
- This step may take some time potentially 10 minutes to update all 3 in this instance
  
## SSH into Controller VM

- Once you are in the Controller machine follow the steps 
- `sudo apt-get install software-properties-common`
- `sudo apt-add-repository ppa:ansible/ansible`
- `sudo apt-get update -y`
- `sudo apt-get install ansible -y`
- check the version once installed `ansible --version`
- go to the correct directory for ansible `/etc/ansible/`
- `sudo apt install tree` this is a design function
- use `tree` to see folders/files within location in a visually pleasing format


## Updating Hosts

- From the `/etc/ansible/` location update the `hosts` file
- in this instance we input 
```
[web]
192.168.33.10 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant


[db]
192.168.33.11 ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
```

- Now we can ping our respective machines from within the Controller machine

- `ping 192.168.33.10` etc
- We can also ssh into them directly from the controller using `ssh vagrant@192.168.33.10` 
- Ensure to input the correct password set in hosts when prompted
- we can also ping our machines and get a `pong` response using ` sudo ansible web -m ping`
- `-m` is module



## Playbooks with Ansible

- From within the controller we can create Playbooks that will run a set group of tasks for a particular vm
- On this occassion the below code is from a playbook created to install Nginx on the web machine
``` 
# create a playbook to install nginx web server inside web
# --- three dashes at the start of the file of YAML       

---

# add hosts or name of the host server
- hosts: web


# indentation is EXTREMELY IMPORTANT
# gather live information

  gather_facts: yes
# we need admin access

  become: true

# add the instructions
# install nginx in web server

  tasks:
  - name: Install Nginx
    apt: pkg=nginx state=present

# the nginx server status is running
```

- In order to create a playbook we can use `sudo nano your-playbook-name-playbook.yml`
- Use the above code to create relevant lines specific to your needs

- Once your playbook has been created use `ansible-playbook your-playbook-name-playbook.yml` in order to run it


### Reverse proxy playbook

```

---

# add hosts or name of the host server
- hosts: web


# indentation is EXTREMELY IMPORTANT  
# gather live information

  gather_facts: yes
# we need admin access

  become: true

# add the instructions
# install nginx in web server

  tasks:
  - name: Remove defualt Nginx file
    file:
      path: /etc/nginx/sites-enabled/default
      state: absent

  - name: create a file to replace
    file:
      path: /etc/nginx/sites-enabled/reverseproxy.conf
      state: touch
      mode: '666'

  - name: insert code lines
    blockinfile:
      path: /etc/nginx/sites-enabled/reverseproxy.conf
      backup: yes
      block:  |
        server {
          listen 80;
          listen [::]:80;

        access_log /var/log/nginx/reverse-access.log;
        error_log /var/log/nginx/reverse-error.log;

          location / {
                    proxy_pass http://localhost:3000;
          }
        }

```

### Nginx Playbook

```

# create a playbook to install nginx web server inside web
# --- three dashes at the start of the file of YAML

---

# add hosts or name of the host server
- hosts: web


# indentation is EXTREMELY IMPORTANT
# gather live information

  gather_facts: yes
# we need admin access

  become: true

# add the instructions
# install nginx in web server

  tasks:
  - name: Install Nginx
    apt: pkg=nginx state=present

# the nginx server status is running

```

### Nodejs Playbook

```
---

# add hosts or name of the host server
- hosts: web


# indentation is EXTREMELY IMPORTANT  
# gather live information

  gather_facts: yes
# we need admin access

  become: true

# add the instructions
# install nginx in web server

  tasks:
  - name: Install Nodejs
    apt: pkg=nodejs state=present

```

### Npm Playbook

```
---

# add hosts or name of the host server
- hosts: web


# indentation is EXTREMELY IMPORTANT  
# gather live information
vagrant@controller:/etc/ansible$ cat npm-playbook.yml
---

# add hosts or name of the host server
- hosts: web


# indentation is EXTREMELY IMPORTANT  
# gather live information

  gather_facts: yes
# we need admin access

  become: true

# add the instructions
# install nginx in web server

  tasks:
  - name: Install Npm
    apt: pkg=npm state=present


```


# Run a Playbook on prem that goes to Cloud with the correct auth method and launches a service

Ansible Vault Dependancies 
- python 3.7
- pip3
- aws cli
- ansible vault folder structure
- `/etc/ansible` - in this location create `group_vars/all/file.yml` to encrypt AWS keys
- `sudo ansible-playbook playbook.yml --ask-vault-pass--tags ec2_create


- automate the ssh key access
- copy pem file as well as generate another keypair called eng122
- in the playbook copy the .pub file to the ec2
- `sudo ansible-vault create pass.yml`
- `sudo chmod 600 pass.yml` permissions 


## Create ec2 instance 

```
# AWS playbook
---

- hosts: localhost
  connection: local
  gather_facts: False

  vars:
    ansible_python_interpreter: /usr/bin/python3
    key_name: 122new
    region: eu-west-1
    image: ami-07b63aa1cfd3bc3a5
    id: "db-test-2"
    sec_group: "{{ id }}-sec"


  tasks:

    - name: Facts
      block:

      - name: Get instances facts
        ec2_instance_facts:
          aws_access_key: "{{aws_access_key}}"
          aws_secret_key: "{{aws_secret_key}}"
          region: "{{ region }}"
        register: result

      - name: Instances ID
        debug:
          msg: "ID: {{ item.instance_id }} - State: {{ item.state.name }} - Public DNS: {{ item.public_dns_name }}"
        loop: "{{ result.instances }}"

      tags: always


    - name: Provisioning EC2 instances
      block:

      - name: Upload public key to AWS
        ec2_key:
          name: "{{ key_name }}"
          key_material: "{{ lookup('file', '/home/ubuntu/.ssh/{{ key_name }}.pub') }}"
          region: "{{ region }}"
          aws_access_key: "{{aws_access_key}}"
          aws_secret_key: "{{aws_secret_key}}"

      - name: Create security group
        ec2_group:
          name: "{{ sec_group }}"
          description: "Sec group for app {{ id }}"
          # vpc_id: 12345
          region: "{{ region }}"
          aws_access_key: "{{aws_access_key}}"
          aws_secret_key: "{{aws_secret_key}}"
          rules:
            - proto: tcp
              ports:
                - 22
              cidr_ip: 0.0.0.0/0
              rule_desc: allow all on ssh port
        register: result_sec_group

      - name: Provision instance(s)
        ec2:
          aws_access_key: "{{aws_access_key}}"
          aws_secret_key: "{{aws_secret_key}}"
          key_name: "{{ key_name }}"
          id: "{{ id }}"
          group_id: "{{ result_sec_group.group_id }}"
          image: "{{ image }}"
          instance_type: t2.micro
          region: "{{ region }}"
          wait: true
          count: 1

          instance_tags:
             Name: eng122_pravin_agent_db1

      tags: ['never', 'create_ec2']
```

- Run the playbook using `ansible-playbook playbook.yml --ask-vault-pass --tags create_ec2`

- Remember to use the tags, and include the vault pass when using access keys